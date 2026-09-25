import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;
import 'package:uuid/uuid.dart';

import '../models/business_card.dart';
import '../models/card_folder.dart';
import '../services/automatic_backup_service.dart';
import '../services/backup_service.dart';
import '../services/local_storage_service.dart';
import 'app_settings_store.dart';

/// Comment une sauvegarde restaurée doit se combiner avec les données déjà
/// présentes sur l'appareil.
enum RestoreMode {
  /// Ajoute ce qui manque, sans toucher à l'existant.
  merge,

  /// Efface les cartes et classeurs actuels, puis les remplace entièrement
  /// par le contenu de la sauvegarde.
  replace,
}

class RestoreResult {
  const RestoreResult({
    required this.addedCards,
    required this.existingCards,
    required this.addedFolders,
    required this.existingFolders,
  });

  final int addedCards;
  final int existingCards;
  final int addedFolders;
  final int existingFolders;
}

class CardStore extends ChangeNotifier {
  CardStore(
    this._storage,
    this._settings,
  );

  /// Délai d’attente avant de reconstruire l’archive de sauvegarde. Sans lui,
  /// chaque enregistrement de carte recompresse l’intégralité du répertoire.
  static const _backupDebounce = Duration(seconds: 6);

  final LocalStorageService _storage;
  final AppSettingsStore _settings;
  final Uuid _uuid = const Uuid();
  final AutomaticBackupService _automaticBackup = AutomaticBackupService();

  List<BusinessCard> _cards = [];
  List<CardFolder> _folders = [];
  bool _loading = true;
  bool _onboardingComplete = false;

  Timer? _backupTimer;
  Future<void>? _backupInFlight;
  bool _backupPending = false;

  List<BusinessCard> get cards => List.unmodifiable(_cards);
  List<CardFolder> get folders => List.unmodifiable(_folders);

  /// Cartes d'un classeur Abonnement dont la date d'expiration tombe dans
  /// les 30 jours à venir, ou déjà dépassée — utilisé pour l'alerte au
  /// lancement de l'application.
  List<BusinessCard> get expiringSubscriptionCards {
    final subscriptionFolderIds = _folders
        .where((folder) => folder.kind == FolderKind.subscription)
        .map((folder) => folder.id)
        .toSet();

    final threshold = DateTime.now().add(const Duration(days: 30));

    return _cards.where((card) {
      final expiration = card.expirationDate;

      if (expiration == null) return false;
      if (!subscriptionFolderIds.contains(card.folderId)) return false;

      return expiration.isBefore(threshold);
    }).toList();
  }

  bool get loading => _loading;
  bool get onboardingComplete => _onboardingComplete;

  @override
  void dispose() {
    _backupTimer?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _cards = await _storage.loadCards();
    _folders = await _storage.loadFolders();
    _onboardingComplete = await _storage.isOnboardingComplete();

    // Filet de rattrapage pour les installations déjà migrées avant
    // l'ajout des classeurs par défaut Abonnement et Carte de fidélité —
    // sans effet si déjà présents, donc sûr à exécuter à chaque démarrage.
    await _ensureDefaultFolderKinds();

    _loading = false;
    notifyListeners();
  }

  Future<void> _ensureDefaultFolderKinds() async {
    final additions = <CardFolder>[
      if (!_folders.any((folder) => folder.id == 'subscription'))
        const CardFolder(
          id: 'subscription',
          name: 'Cartes Abonnement',
          isDefault: true,
          kind: FolderKind.subscription,
        ),
      if (!_folders.any((folder) => folder.id == 'discount'))
        const CardFolder(
          id: 'discount',
          name: 'Cartes de fidélité',
          isDefault: true,
          kind: FolderKind.discount,
        ),
    ];

    if (additions.isEmpty) return;

    _folders = [..._folders, ...additions];
    await _storage.saveFolders(_folders);
  }

  BusinessCard createCard({String folderId = 'personal'}) {
    final now = DateTime.now();

    return BusinessCard(
      id: _uuid.v4(),
      folderId: folderId,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> saveCard(BusinessCard card) async {
    final index = _cards.indexWhere((item) => item.id == card.id);

    if (index == -1) {
      _cards = [..._cards, card];
    } else {
      _cards[index] = card;
    }

    await _storage.upsertCard(card);
    notifyListeners();
    _scheduleAutomaticBackup();
  }

  Future<bool> importCard(BusinessCard card) async {
    if (_cards.any((existing) => existing.id == card.id)) {
      return false;
    }

    _cards = [..._cards, card];

    await _storage.upsertCard(card);
    notifyListeners();
    _scheduleAutomaticBackup();

    return true;
  }

  Future<RestoreResult?> restoreBackup(
    BackupData backup, {
    RestoreMode mode = RestoreMode.merge,
  }) async {
    if (mode == RestoreMode.replace) {
      return _replaceWithBackup(backup);
    }

    var addedFolders = 0;
    var existingFolders = 0;
    var addedCards = 0;
    var existingCards = 0;

    final knownFolderIds = _folders.map((folder) => folder.id).toSet();
    final knownFolderNames =
        _folders.map((folder) => _normalizeFolderName(folder.name)).toSet();

    for (final folder in backup.folders) {
      final normalizedName = _normalizeFolderName(folder.name);

      if (knownFolderIds.contains(folder.id) ||
          knownFolderNames.contains(normalizedName)) {
        existingFolders += 1;
        continue;
      }

      _folders = [..._folders, folder];
      knownFolderIds.add(folder.id);
      knownFolderNames.add(normalizedName);
      addedFolders += 1;
    }

    final knownCardIds = _cards.map((card) => card.id).toSet();

    for (final card in backup.cards) {
      if (knownCardIds.contains(card.id)) {
        existingCards += 1;
        continue;
      }

      final folderExists = knownFolderIds.contains(card.folderId);

      _cards = [
        ..._cards,
        folderExists
            ? card
            : card.copyWith(
                folderId: 'personal',
                updatedAt: DateTime.now(),
              ),
      ];

      knownCardIds.add(card.id);
      addedCards += 1;
    }

    await _storage.saveFolders(_folders);
    await _storage.saveCards(_cards);
    notifyListeners();

    // Une restauration est un événement rare et important : on écrit
    // l’archive tout de suite plutôt que d’attendre le délai.
    await flushAutomaticBackup();

    return RestoreResult(
      addedCards: addedCards,
      existingCards: existingCards,
      addedFolders: addedFolders,
      existingFolders: existingFolders,
    );
  }

  /// Efface les données actuelles et les remplace entièrement par celles de
  /// la sauvegarde. Contrairement à la fusion, aucun décompte détaillé n'est
  /// utile ici : c'est un remplacement complet, pas une combinaison.
  Future<RestoreResult?> _replaceWithBackup(BackupData backup) async {
    // Si la sauvegarde ne contient étrangement aucun classeur, on préfère
    // garder les classeurs actuels plutôt que de laisser l'application sans
    // aucun classeur du tout.
    _folders = backup.folders.isNotEmpty ? backup.folders : _folders;
    _cards = backup.cards;

    await _storage.saveFolders(_folders);
    await _storage.replaceAllCards(_cards);
    notifyListeners();

    await flushAutomaticBackup();

    return null;
  }

  Future<void> deleteCard(String id) async {
    _cards.removeWhere((card) => card.id == id);

    await _storage.deleteCardById(id);
    notifyListeners();
    _scheduleAutomaticBackup();
  }

  Future<bool> addFolder(
    String name, {
    FolderKind kind = FolderKind.businessCard,
  }) async {
    final cleanName = name.trim();
    final normalizedName = _normalizeFolderName(cleanName);

    if (normalizedName.isEmpty) return false;

    final alreadyExists = _folders.any(
      (folder) => _normalizeFolderName(folder.name) == normalizedName,
    );

    if (alreadyExists) return false;

    _folders = [
      ..._folders,
      CardFolder(id: _uuid.v4(), name: cleanName, kind: kind),
    ];

    await _storage.saveFolders(_folders);
    notifyListeners();
    _scheduleAutomaticBackup();

    return true;
  }

  /// Renomme un classeur existant. Refuse si le nom (une fois normalisé)
  /// est déjà pris par un autre classeur — même règle que [addFolder].
  Future<bool> renameFolder(String folderId, String newName) async {
    final cleanName = newName.trim();
    final normalizedName = _normalizeFolderName(cleanName);

    if (normalizedName.isEmpty) return false;

    final index = _folders.indexWhere((folder) => folder.id == folderId);

    if (index == -1) return false;

    // Les trois classeurs par défaut (Mes cartes de visite, Clients,
    // Fournisseurs) sont fixes : seuls les classeurs créés par
    // l'utilisateur peuvent être renommés.
    if (_folders[index].isDefault) return false;

    final alreadyTaken = _folders.any(
      (folder) =>
          folder.id != folderId &&
          _normalizeFolderName(folder.name) == normalizedName,
    );

    if (alreadyTaken) return false;

    final current = _folders[index];
    final updated = [..._folders];
    updated[index] = CardFolder(
      id: current.id,
      name: cleanName,
      isDefault: current.isDefault,
      colorValue: current.colorValue,
    );
    _folders = updated;

    await _storage.saveFolders(_folders);
    notifyListeners();
    _scheduleAutomaticBackup();

    return true;
  }

  /// Change la couleur d'un classeur. Contrairement à [renameFolder] et
  /// [deleteFolder], la couleur reste modifiable même pour les trois
  /// classeurs par défaut — ce n'est qu'une préférence d'affichage, pas une
  /// donnée structurante.
  Future<bool> setFolderColor(String folderId, Color? color) async {
    final index = _folders.indexWhere((folder) => folder.id == folderId);

    if (index == -1) return false;

    final current = _folders[index];
    final updated = [..._folders];
    updated[index] = CardFolder(
      id: current.id,
      name: current.name,
      isDefault: current.isDefault,
      colorValue: color?.toARGB32(),
    );
    _folders = updated;

    await _storage.saveFolders(_folders);
    notifyListeners();
    _scheduleAutomaticBackup();

    return true;
  }

  Future<bool> deleteFolder(String folderId) async {
    final folder = _folders.where((item) => item.id == folderId).firstOrNull;

    if (folder == null) return false;

    // Même règle que pour le renommage : les classeurs par défaut ne se
    // suppriment jamais, quel que soit leur contenu.
    if (folder.isDefault) return false;

    if (_cards.any((card) => card.folderId == folderId)) {
      return false;
    }

    _folders.removeWhere((item) => item.id == folderId);

    await _storage.saveFolders(_folders);
    notifyListeners();
    _scheduleAutomaticBackup();

    return true;
  }

  Future<void> finishOnboarding(BusinessCard firstCard) async {
    await saveCard(firstCard);

    _onboardingComplete = true;
    await _storage.setOnboardingComplete();
    notifyListeners();

    await flushAutomaticBackup();
  }

  /// Reporte l’écriture de l’archive : chaque nouvel appel réarme le délai.
  /// Les données elles-mêmes sont déjà enregistrées de façon synchrone par
  /// [LocalStorageService], donc rien n’est perdu entre-temps.
  void _scheduleAutomaticBackup() {
    _backupPending = true;

    _backupTimer?.cancel();
    _backupTimer = Timer(_backupDebounce, () {
      _runAutomaticBackup();
    });
  }

  /// Écrit immédiatement l’archive si une sauvegarde est en attente.
  /// À appeler lorsque l’application passe en arrière-plan.
  Future<void> flushAutomaticBackup() async {
    _backupTimer?.cancel();
    _backupTimer = null;

    if (!_backupPending) {
      await _backupInFlight;
      return;
    }

    await _runAutomaticBackup();
  }

  Future<void> _runAutomaticBackup() async {
    // Une seule reconstruction à la fois : si une écriture est déjà en cours,
    // on attend qu’elle finisse avant de relancer.
    final inFlight = _backupInFlight;

    if (inFlight != null) {
      await inFlight;
    }

    if (!_backupPending) return;

    _backupPending = false;

    final task = _saveAutomaticBackup();
    _backupInFlight = task;

    try {
      await task;
    } finally {
      _backupInFlight = null;
    }
  }

  Future<void> _saveAutomaticBackup() async {
    try {
      await _automaticBackup.saveAfterChange(
        cards: _cards,
        folders: _folders,
        externalBackupEnabled: _settings.externalBackupEnabled,
      );
    } catch (_) {
      // Les données dans SharedPreferences ont déjà été sauvegardées.
      // Une erreur d'archive ou de cloud ne bloque pas le travail local.
    }
  }

  List<BusinessCard> cardsForFolder(String folderId) {
    final cards = _cards.where((card) => card.folderId == folderId).toList();

    cards.sort(
      (first, second) =>
          first.title.toLowerCase().compareTo(second.title.toLowerCase()),
    );

    return cards;
  }

  String _normalizeFolderName(String value) {
    return value.trim().toLowerCase().replaceAll(
          RegExp(r'\s+'),
          ' ',
        );
  }
}

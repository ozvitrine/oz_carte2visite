import 'package:drift/drift.dart';

import '../../models/business_card.dart';
import '../../models/card_folder.dart';
import '../local_storage_service.dart';
import 'app_database.dart';

/// Stockage structuré (SQLite via Drift) qui remplace SharedPreferences pour
/// les cartes et les classeurs. Conserve exactement la même interface que
/// [LocalStorageService] : rien d'autre dans l'application n'a besoin de
/// savoir lequel des deux est utilisé.
class DriftStorageService implements LocalStorageService {
  DriftStorageService(this._db);

  final AppDatabase _db;

  /// Toujours nécessaire : source des classeurs par défaut au tout premier
  /// lancement (ci-dessous), et relais pour le statut d'onboarding, que
  /// Drift ne stocke pas lui-même.
  final LocalStorageService _legacy = LocalStorageService();

  @override
  Future<List<BusinessCard>> loadCards() async {
    final rows = await _db.select(_db.cards).get();
    return rows.map(_toBusinessCard).toList();
  }

  @override
  Future<List<CardFolder>> loadFolders() async {
    final rows = await _db.select(_db.folders).get();

    if (rows.isEmpty) {
      // Filet de sécurité : ne devrait pas arriver si la migration a bien
      // tourné (elle insère toujours au moins les classeurs par défaut),
      // mais on ne laisse jamais l'application sans aucun classeur.
      final defaults = await _legacy.loadFolders();

      await _db.batch((batch) {
        batch.insertAll(_db.folders, defaults.map(_folderToCompanion));
      });

      return defaults;
    }

    return rows.map(_toCardFolder).toList();
  }

  /// Remplacement en bloc : utilisé uniquement lors d'une restauration de
  /// sauvegarde, où la liste fournie est toujours une surliste de
  /// l'existant (fusion additive). Pour l'ajout, la modification ou la
  /// suppression d'une carte au fil de l'eau, voir [upsertCard] et
  /// [deleteCardById] — c'est ce qui évite de réécrire toute la table à
  /// chaque frappe.
  @override
  Future<void> saveCards(List<BusinessCard> cards) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.cards,
        cards.map(_cardToCompanion),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Remplacement complet de la table des classeurs. Contrairement aux
  /// cartes, le nombre de classeurs reste toujours faible : une réécriture
  /// totale ici n'a pas d'impact de performance mesurable, et c'est ce qui
  /// permet à [deleteFolder] de fonctionner simplement en fournissant la
  /// liste déjà réduite.
  @override
  Future<void> saveFolders(List<CardFolder> folders) async {
    await _db.transaction(() async {
      await _db.delete(_db.folders).go();
      await _db.batch((batch) {
        batch.insertAll(_db.folders, folders.map(_folderToCompanion));
      });
    });
  }

  /// Remplacement complet, contrairement à [saveCards] : les cartes qui
  /// n'apparaissent pas dans la liste fournie sont supprimées. Utilisé
  /// uniquement pour une restauration en mode « remplacer », un événement
  /// rare — la réécriture totale de la table n'a pas d'impact au quotidien.
  Future<void> replaceAllCards(List<BusinessCard> cards) async {
    await _db.transaction(() async {
      await _db.delete(_db.cards).go();
      await _db.batch((batch) {
        batch.insertAll(_db.cards, cards.map(_cardToCompanion));
      });
    });
  }

  Future<void> upsertCard(BusinessCard card) async {
    await _db.into(_db.cards).insertOnConflictUpdate(_cardToCompanion(card));
  }

  Future<void> deleteCardById(String id) async {
    await (_db.delete(_db.cards)..where((table) => table.id.equals(id))).go();
  }

  @override
  Future<bool> isOnboardingComplete() => _legacy.isOnboardingComplete();

  @override
  Future<void> setOnboardingComplete() => _legacy.setOnboardingComplete();

  BusinessCard _toBusinessCard(CardEntity row) {
    return BusinessCard(
      id: row.id,
      company: row.company,
      name: row.name,
      phone: row.phone,
      email: row.email,
      notes: row.notes,
      folderId: row.folderId,
      frontImagePath: row.frontImagePath,
      backImagePath: row.backImagePath,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      expirationDate: row.expirationDate,
      barcodeValue: row.barcodeValue,
      barcodeFormat: row.barcodeFormat,
      merchantPhone: row.merchantPhone,
      merchantEmail: row.merchantEmail,
    );
  }

  CardsCompanion _cardToCompanion(BusinessCard card) {
    return CardsCompanion(
      id: Value(card.id),
      company: Value(card.company),
      name: Value(card.name),
      phone: Value(card.phone),
      email: Value(card.email),
      notes: Value(card.notes),
      folderId: Value(card.folderId),
      frontImagePath: Value(card.frontImagePath),
      backImagePath: Value(card.backImagePath),
      createdAt: Value(card.createdAt),
      updatedAt: Value(card.updatedAt),
      expirationDate: Value(card.expirationDate),
      barcodeValue: Value(card.barcodeValue),
      barcodeFormat: Value(card.barcodeFormat),
      merchantPhone: Value(card.merchantPhone),
      merchantEmail: Value(card.merchantEmail),
    );
  }

  CardFolder _toCardFolder(FolderEntity row) {
    return CardFolder(
      id: row.id,
      name: row.name,
      isDefault: row.isDefault,
      colorValue: row.colorValue,
      kind: FolderKind.fromValue(row.kindValue),
    );
  }

  FoldersCompanion _folderToCompanion(CardFolder folder) {
    return FoldersCompanion(
      id: Value(folder.id),
      name: Value(folder.name),
      isDefault: Value(folder.isDefault),
      colorValue: Value(folder.colorValue),
      kindValue: Value(folder.kind.value),
    );
  }
}

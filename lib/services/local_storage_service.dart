import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/business_card.dart';
import '../models/card_folder.dart';

class LocalStorageService {
  static const _cardsKey = 'oz_cards';
  static const _foldersKey = 'oz_folders';
  static const _onboardingKey = 'oz_onboarding_complete';

  Future<List<BusinessCard>> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final source = prefs.getString(_cardsKey);
    if (source == null) return [];

    try {
      final decoded = jsonDecode(source);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map((item) => BusinessCard.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .where((card) => card.id.isNotEmpty)
          .toList();
    } on FormatException {
      return [];
    }
  }

  Future<List<CardFolder>> loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final source = prefs.getString(_foldersKey);
    if (source == null) return _defaultFolders;

    try {
      final decoded = jsonDecode(source);
      if (decoded is! List) return _defaultFolders;

      return decoded
          .whereType<Map>()
          .map((item) => CardFolder.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .where((folder) => folder.id.isNotEmpty)
          .toList();
    } on FormatException {
      return _defaultFolders;
    }
  }

  Future<void> saveCards(List<BusinessCard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cardsKey,
      jsonEncode(cards.map((card) => card.toJson()).toList()),
    );
  }

  /// SharedPreferences réécrit déjà la clé entière à chaque appel de
  /// [saveCards] : c'est donc déjà un remplacement complet, pas besoin
  /// d'une implémentation séparée ici.
  Future<void> replaceAllCards(List<BusinessCard> cards) => saveCards(cards);

  Future<void> saveFolders(List<CardFolder> folders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _foldersKey,
      jsonEncode(folders.map((folder) => folder.toJson()).toList()),
    );
  }

  /// Implémentation de repli pour rester compatible avec l'interface
  /// commune : SharedPreferences ne permet pas de mise à jour ciblée, donc
  /// on relit et on réécrit la liste entière. C'est précisément la
  /// limitation que DriftStorageService corrige.
  Future<void> upsertCard(BusinessCard card) async {
    final cards = await loadCards();
    final index = cards.indexWhere((existing) => existing.id == card.id);
    final updated = [...cards];

    if (index == -1) {
      updated.add(card);
    } else {
      updated[index] = card;
    }

    await saveCards(updated);
  }

  Future<void> deleteCardById(String id) async {
    final cards = await loadCards();
    cards.removeWhere((card) => card.id == id);
    await saveCards(cards);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  List<CardFolder> get _defaultFolders => const [
        CardFolder(
          id: 'personal',
          name: 'Mes cartes de visite',
          isDefault: true,
        ),
        CardFolder(
          id: 'clients',
          name: 'Cartes clients',
          isDefault: true,
        ),
        CardFolder(
          id: 'suppliers',
          name: 'Cartes fournisseurs',
          isDefault: true,
        ),
      ];
}

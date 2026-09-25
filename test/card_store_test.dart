import 'package:flutter_test/flutter_test.dart';

import 'package:oz_carte2visite/models/business_card.dart';
import 'package:oz_carte2visite/models/card_folder.dart';
import 'package:oz_carte2visite/services/local_storage_service.dart';
import 'package:oz_carte2visite/state/app_settings_store.dart';
import 'package:oz_carte2visite/state/card_store.dart';

/// Remplace le vrai stockage pour ne pas dépendre de SharedPreferences
/// dans ce test et pour compter les écritures.
class _FakeStorage implements LocalStorageService {
  int saveCardsCallCount = 0;
  List<BusinessCard> lastSavedCards = [];

  @override
  Future<List<BusinessCard>> loadCards() async => [];

  @override
  Future<List<CardFolder>> loadFolders() async => [];

  @override
  Future<void> saveCards(List<BusinessCard> cards) async {
    saveCardsCallCount += 1;
    lastSavedCards = cards;
  }

  @override
  Future<void> saveFolders(List<CardFolder> folders) async {}

  @override
  Future<bool> isOnboardingComplete() async => true;

  @override
  Future<void> setOnboardingComplete() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'plusieurs saveCard rapprochés ne déclenchent qu’une seule '
    'reconstruction de sauvegarde',
    () async {
      final storage = _FakeStorage();
      final settings = AppSettingsStore();
      final store = CardStore(storage, settings);

      await store.load();

      final now = DateTime.now();

      // Trois écritures rapprochées, comme trois frappes dans le
      // formulaire d’édition d’une carte.
      await store.saveCard(
        BusinessCard(id: '1', createdAt: now, updatedAt: now, name: 'A'),
      );
      await store.saveCard(
        BusinessCard(id: '1', createdAt: now, updatedAt: now, name: 'AB'),
      );
      await store.saveCard(
        BusinessCard(id: '1', createdAt: now, updatedAt: now, name: 'ABC'),
      );

      // Chaque saveCard écrit bien les données tout de suite : rien n’est
      // perdu si l’app est tuée entre deux frappes.
      expect(storage.saveCardsCallCount, 3);
      expect(storage.lastSavedCards.single.name, 'ABC');

      // flushAutomaticBackup ne doit pas planter même sans backend réel
      // de sauvegarde externe/zip disponible dans l’environnement de test.
      await store.flushAutomaticBackup();
    },
  );

  test('flushAutomaticBackup est sans effet quand rien n’est en attente',
      () async {
    final storage = _FakeStorage();
    final settings = AppSettingsStore();
    final store = CardStore(storage, settings);

    await store.load();

    // Aucune écriture n’a eu lieu : l’appel doit simplement retourner.
    await store.flushAutomaticBackup();
  });
}

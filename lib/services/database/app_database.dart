import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('CardEntity')
class Cards extends Table {
  TextColumn get id => text()();
  TextColumn get company => text().withDefault(const Constant(''))();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get folderId => text().withDefault(const Constant('personal'))();
  TextColumn get frontImagePath => text().nullable()();
  TextColumn get backImagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Ajoutés en version 3 du schéma, pour les cartes de type abonnement ou
  /// remise/promo. Restent `null` pour toute carte de visite classique.
  DateTimeColumn get expirationDate => dateTime().nullable()();
  TextColumn get barcodeValue => text().nullable()();
  TextColumn get barcodeFormat => text().nullable()();
  TextColumn get merchantPhone => text().nullable()();
  TextColumn get merchantEmail => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FolderEntity')
class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  /// Couleur choisie par l'utilisateur (ARGB), nullable : ajoutée en
  /// version 2 du schéma. `null` signifie qu'aucune couleur explicite n'a
  /// été choisie, l'interface en attribue une par défaut.
  IntColumn get colorValue => integer().nullable()();

  /// Ajouté en version 3 du schéma : détermine si ce classeur contient des
  /// cartes de visite, des abonnements, ou des remises/promos — fixé à la
  /// création, jamais modifié ensuite. Les classeurs déjà en base avant
  /// cette version sont tous des classeurs de cartes de visite classiques.
  TextColumn get kindValue =>
      text().withDefault(const Constant('businessCard'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Cards, Folders])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Permet d'injecter une base en mémoire dans les tests, sans toucher au
  /// disque.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        // Version 1 → 2 : ajout de la couleur de classeur. Les classeurs
        // déjà en base gardent colorValue à null, ce qui revient à la
        // couleur par défaut attribuée côté interface — rien à recopier.
        if (from < 2) {
          await migrator.addColumn(folders, folders.colorValue);
        }

        // Version 2 → 3 : classeurs typés (carte de visite / abonnement /
        // remise-promo) et champs associés sur les cartes. Les classeurs
        // déjà en base reçoivent 'businessCard' via la valeur par défaut de
        // la colonne — cohérent, puisqu'ils ne contenaient jusqu'ici que
        // des cartes de visite. Les nouveaux champs de carte restent null.
        if (from < 3) {
          await migrator.addColumn(folders, folders.kindValue);
          await migrator.addColumn(cards, cards.expirationDate);
          await migrator.addColumn(cards, cards.barcodeValue);
          await migrator.addColumn(cards, cards.barcodeFormat);
          await migrator.addColumn(cards, cards.merchantPhone);
          await migrator.addColumn(cards, cards.merchantEmail);
        }
      },
    );
  }
}

QueryExecutor _openConnection() {
  // drift_flutter choisit automatiquement le bon emplacement de fichier
  // selon la plateforme (Android, iOS, desktop) ; rien à configurer ici.
  return driftDatabase(name: 'oz_carte2visite');
}

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

import '../../test_util/builders/model_source_builder.dart';
import '../../test_util/database_definition_helpers.dart';

List<DatabaseMigrationVersionModel> _sqliteModules(DatabaseDefinition def) =>
    def.installedModules.isNotEmpty
    ? def.installedModules
    : [
        DatabaseMigrationVersionModel(
          module: def.moduleName,
          version: '00000000000000',
        ),
      ];

void main() {
  test(
    'Given a table being renamed that is referenced by another one, '
    'when generating SQL for SQLite, '
    'then the SQLite migration drops tables and recreates them in a working order.',
    () {
      var sourceModels = [
        ModelSourceBuilder().withFileName('target').withYaml(
          '''
class: Target
table: target
fields:
  name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('source').withYaml(
          '''
class: Source
table: source
fields:
  target: Target?, relation
          ''',
        ).build(),
      ];

      var targetModels = [
        ModelSourceBuilder().withFileName('target').withYaml(
          '''
class: Target
table: target_new
fields:
  name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('source').withYaml(
          '''
class: Source
table: source
fields:
  target: Target?, relation
          ''',
        ).build(),
      ];

      var (
        :sourceDefinition,
        :targetDefinition,
      ) = databaseDefinitionsFromModels(
        sourceModels,
        targetModels,
      );

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var sqlite = migration.toSqliteSql(
        databaseDefinition: targetDefinition,
        installedModules: _sqliteModules(targetDefinition),
        removedModules: [],
      );

      var dropTableSourceIndex = sqlite.indexOf('DROP TABLE "source"');
      var dropTableTargetIndex = sqlite.indexOf('DROP TABLE "target"');
      var createTableSourceIndex = sqlite.indexOf('CREATE TABLE "source"');
      var createTableTargetIndex = sqlite.indexOf('CREATE TABLE "target_new"');
      var referencesTargetNew = sqlite.indexOf('REFERENCES "target_new"');

      expect(dropTableSourceIndex, greaterThanOrEqualTo(0));
      expect(dropTableTargetIndex, greaterThanOrEqualTo(0));
      expect(createTableSourceIndex, greaterThanOrEqualTo(0));
      expect(createTableTargetIndex, greaterThanOrEqualTo(0));
      expect(referencesTargetNew, greaterThanOrEqualTo(0));

      expect(dropTableSourceIndex, lessThan(dropTableTargetIndex));
      expect(dropTableTargetIndex, lessThan(createTableSourceIndex));
      expect(createTableSourceIndex, lessThan(createTableTargetIndex));
      expect(sqlite, isNot(contains('ALTER TABLE ONLY')));
    },
  );

  test(
    'Given a table being renamed that is optionally referenced by another one, '
    'when generating SQL for SQLite, '
    'then the SQLite migration drops tables and recreates them in a working order.',
    () {
      var sourceModels = [
        ModelSourceBuilder().withFileName('target').withYaml(
          '''
class: Target
table: target
fields:
  name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('source').withYaml(
          '''
class: Source
table: source
fields:
  target: Target?, relation(optional)
          ''',
        ).build(),
      ];

      var targetModels = [
        ModelSourceBuilder().withFileName('target').withYaml(
          '''
class: Target
table: target_new
fields:
  name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('source').withYaml(
          '''
class: Source
table: source
fields:
  target: Target?, relation(optional)
          ''',
        ).build(),
      ];

      var (
        :sourceDefinition,
        :targetDefinition,
      ) = databaseDefinitionsFromModels(
        sourceModels,
        targetModels,
      );

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var sqlite = migration.toSqliteSql(
        databaseDefinition: targetDefinition,
        installedModules: _sqliteModules(targetDefinition),
        removedModules: [],
      );

      var dropTableSourceIndex = sqlite.indexOf('DROP TABLE "source"');
      var dropTableTargetIndex = sqlite.indexOf('DROP TABLE "target"');
      var createTableSourceIndex = sqlite.indexOf('CREATE TABLE "source"');
      var createTableTargetIndex = sqlite.indexOf('CREATE TABLE "target_new"');

      expect(dropTableSourceIndex, greaterThanOrEqualTo(0));
      expect(dropTableTargetIndex, greaterThanOrEqualTo(0));
      expect(createTableSourceIndex, greaterThanOrEqualTo(0));
      expect(createTableTargetIndex, greaterThanOrEqualTo(0));

      expect(dropTableSourceIndex, lessThan(dropTableTargetIndex));
      expect(dropTableTargetIndex, lessThan(createTableSourceIndex));
      expect(createTableSourceIndex, lessThan(createTableTargetIndex));
    },
  );

  test(
    'Given two tables being renamed that reference each other, '
    'when generating SQL for SQLite, '
    'then the SQLite migration drops both tables and recreates them in a working order.',
    () {
      var sourceModels = [
        ModelSourceBuilder().withFileName('a').withYaml(
          '''
class: A
table: a
fields:
  b: B?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('b').withYaml(
          '''
class: B
table: b
fields:
  a: A?, relation
          ''',
        ).build(),
      ];

      var targetModels = [
        ModelSourceBuilder().withFileName('a').withYaml(
          '''
class: A
table: a_new
fields:
  b: B?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('b').withYaml(
          '''
class: B
table: b
fields:
  a: A?, relation
          ''',
        ).build(),
      ];

      var (
        :sourceDefinition,
        :targetDefinition,
      ) = databaseDefinitionsFromModels(
        sourceModels,
        targetModels,
      );

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var sqlite = migration.toSqliteSql(
        databaseDefinition: targetDefinition,
        installedModules: _sqliteModules(targetDefinition),
        removedModules: [],
      );

      var dropTableSourceIndex = sqlite.indexOf('DROP TABLE "b"');
      var dropTableTargetIndex = sqlite.indexOf('DROP TABLE "a"');
      var createTableTargetIndex = sqlite.indexOf('CREATE TABLE "a_new"');
      var createTableSourceIndex = sqlite.indexOf('CREATE TABLE "b"');

      expect(dropTableSourceIndex, greaterThanOrEqualTo(0));
      expect(dropTableTargetIndex, greaterThanOrEqualTo(0));
      expect(createTableSourceIndex, greaterThanOrEqualTo(0));
      expect(createTableTargetIndex, greaterThanOrEqualTo(0));

      expect(dropTableSourceIndex, lessThan(dropTableTargetIndex));
      expect(dropTableTargetIndex, lessThan(createTableSourceIndex));
      expect(createTableTargetIndex, lessThan(createTableSourceIndex));
    },
  );

  test(
    'Given two tables being renamed that reference each other, '
    'when generating SQL for SQLite, '
    'then the SQLite migration should not mention an unrelated table.',
    () {
      var sourceModels = [
        ModelSourceBuilder().withFileName('a').withYaml(
          '''
class: A
table: a
fields:
  b: B?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('b').withYaml(
          '''
class: B
table: b
fields:
  a: A?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('c').withYaml(
          '''
class: C
table: c
fields:
  name: String?
          ''',
        ).build(),
      ];

      var targetModels = [
        ModelSourceBuilder().withFileName('a').withYaml(
          '''
class: A
table: a_new
fields:
  b: B?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('b').withYaml(
          '''
class: B
table: b
fields:
  a: A?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('c').withYaml(
          '''
class: C
table: c
fields:
  name: String?
          ''',
        ).build(),
      ];

      var (
        :sourceDefinition,
        :targetDefinition,
      ) = databaseDefinitionsFromModels(
        sourceModels,
        targetModels,
      );

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var sqlite = migration.toSqliteSql(
        databaseDefinition: targetDefinition,
        installedModules: _sqliteModules(targetDefinition),
        removedModules: [],
      );

      expect(sqlite, isNot(contains('"c"')));
    },
  );

  test(
    'Given a table being renamed and dropping a reference column that is referenced by another one, '
    'when generating SQL for SQLite, '
    'then the SQLite migration drops target, drops the column on source, and creates target_new.',
    () {
      var sourceModels = [
        ModelSourceBuilder().withFileName('target').withYaml(
          '''
class: Target
table: target
fields:
  name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('source').withYaml(
          '''
class: Source
table: source
fields:
  name: String
  target: Target?, relation
          ''',
        ).build(),
      ];

      var targetModels = [
        ModelSourceBuilder().withFileName('target').withYaml(
          '''
class: Target
table: target_new
fields:
  name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('source').withYaml(
          '''
class: Source
table: source
fields:
  name: String
          ''',
        ).build(),
      ];

      var (
        :sourceDefinition,
        :targetDefinition,
      ) = databaseDefinitionsFromModels(
        sourceModels,
        targetModels,
      );

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var sqlite = migration.toSqliteSql(
        databaseDefinition: targetDefinition,
        installedModules: _sqliteModules(targetDefinition),
        removedModules: [],
      );

      var dropTableSourceIndex = sqlite.indexOf(
        'DROP TABLE "source"',
      );
      var dropTableTargetIndex = sqlite.indexOf('DROP TABLE "target"');
      var dropSourceConstraint = sqlite.indexOf(
        'ALTER TABLE "source" DROP CONSTRAINT "source_fk_0"',
      );
      var dropSourceColumnPointingToTarget = sqlite.indexOf(
        'ALTER TABLE "source" DROP COLUMN "targetId"',
      );
      var createNewTargetTable = sqlite.indexOf('CREATE TABLE "target_new"');

      expect(dropTableSourceIndex, greaterThanOrEqualTo(0));
      expect(dropTableTargetIndex, greaterThanOrEqualTo(0));
      expect(dropSourceConstraint, -1);
      // Table rebuild removes the FK column without a separate DROP COLUMN.
      expect(dropSourceColumnPointingToTarget, -1);
      expect(createNewTargetTable, greaterThanOrEqualTo(0));

      expect(dropTableTargetIndex, lessThan(dropTableSourceIndex));
      expect(dropTableSourceIndex, lessThan(createNewTargetTable));
    },
  );
}

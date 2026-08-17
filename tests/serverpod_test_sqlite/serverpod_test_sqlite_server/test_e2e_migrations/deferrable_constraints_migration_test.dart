@Timeout(Duration(minutes: 5))
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_sqlite_server/test_util/service_client.dart';
import 'package:test/test.dart';

const _parentTable = 'defer_fk_parent';
const _childTable = 'defer_fk_child';

extension on TableDefinition {
  ForeignKeyDefinition foreignKeyOn(String column) =>
      foreignKeys.singleWhere((key) => key.columns.contains(column));
}

void main() {
  const resetSql =
      'DROP TABLE IF EXISTS $_childTable;'
      'DROP TABLE IF EXISTS $_parentTable;';

  tearDown(() async {
    await MigrationTestUtils.migrationTestCleanup(
      resetSql: resetSql,
      serviceClient: serviceClient,
    );
  });

  test(
    'Given a relation marked as deferrable, '
    'when creating and applying a migration with a foreign key, '
    'then the live SQLite database has an initially immediate constraint.',
    () async {
      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: {
              'defer_fk_parent':
                  '''
class: DeferFkParent
table: $_parentTable
fields:
  name: String
''',
              'defer_fk_child':
                  '''
class: DeferFkChild
table: $_childTable
fields:
  parent: DeferFkParent?, relation(deferrable)
''',
            },
            tag: 'defer-fk-deferrable',
          );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode =
          await MigrationTestUtils.runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition = await serviceClient.insights
          .getLiveDatabaseDefinition();
      var childTable = liveDefinition.tables.firstWhere(
        (table) => table.name == _childTable,
      );

      expect(childTable.foreignKeys, hasLength(1));
      expect(
        childTable.foreignKeyOn('parentId').deferrable,
        DeferrableConstraint.initiallyImmediate,
      );
    },
  );

  test(
    'Given a relation marked as deferred, '
    'when creating and applying a migration with a foreign key, '
    'then the live SQLite database has an initially deferred constraint.',
    () async {
      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: {
              'defer_fk_parent':
                  '''
class: DeferFkParent
table: $_parentTable
fields:
  name: String
''',
              'defer_fk_child':
                  '''
class: DeferFkChild
table: $_childTable
fields:
  parent: DeferFkParent?, relation(deferred)
''',
            },
            tag: 'defer-fk-deferred',
          );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode =
          await MigrationTestUtils.runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition = await serviceClient.insights
          .getLiveDatabaseDefinition();
      var childTable = liveDefinition.tables.firstWhere(
        (table) => table.name == _childTable,
      );

      expect(childTable.foreignKeys, hasLength(1));
      expect(
        childTable.foreignKeyOn('parentId').deferrable,
        DeferrableConstraint.initiallyDeferred,
      );
    },
  );

  test(
    'Given a relation with no declared deferrability, '
    'when creating and applying a migration with a foreign key, '
    'then the live SQLite database has a non-deferrable constraint.',
    () async {
      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: {
              'defer_fk_parent':
                  '''
class: DeferFkParent
table: $_parentTable
fields:
  name: String
''',
              'defer_fk_child':
                  '''
class: DeferFkChild
table: $_childTable
fields:
  otherParent: DeferFkParent?, relation
''',
            },
            tag: 'defer-fk-not-deferrable',
          );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode =
          await MigrationTestUtils.runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition = await serviceClient.insights
          .getLiveDatabaseDefinition();
      var childTable = liveDefinition.tables.firstWhere(
        (table) => table.name == _childTable,
      );

      expect(childTable.foreignKeys, hasLength(1));
      expect(childTable.foreignKeyOn('otherParentId').deferrable, isNull);
    },
  );

  test(
    'Given an existing non-deferrable foreign key, '
    'when applying a migration that marks its relation as deferrable, '
    'then SQLite replaces it with an initially immediate constraint.',
    () async {
      await MigrationTestUtils.createInitialState(
        migrationProtocols: [
          {
            'defer_fk_parent':
                '''
class: DeferFkParent
table: $_parentTable
fields:
  name: String
''',
            'defer_fk_child':
                '''
class: DeferFkChild
table: $_childTable
fields:
  parent: DeferFkParent?, relation
''',
          },
        ],
        tag: 'defer-fk-non-deferrable',
      );

      var initialDefinition = await serviceClient.insights
          .getLiveDatabaseDefinition();
      var initialChildTable = initialDefinition.tables.firstWhere(
        (table) => table.name == _childTable,
      );
      expect(
        initialChildTable.foreignKeyOn('parentId').deferrable,
        isNull,
        reason: 'Initial foreign key should not be deferrable.',
      );

      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: {
              'defer_fk_parent':
                  '''
class: DeferFkParent
table: $_parentTable
fields:
  name: String
''',
              'defer_fk_child':
                  '''
class: DeferFkChild
table: $_childTable
fields:
  parent: DeferFkParent?, relation(deferrable)
''',
            },
            tag: 'defer-fk-upgrade',
          );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode =
          await MigrationTestUtils.runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition = await serviceClient.insights
          .getLiveDatabaseDefinition();
      var childTable = liveDefinition.tables.firstWhere(
        (table) => table.name == _childTable,
      );

      expect(
        childTable.foreignKeyOn('parentId').deferrable,
        DeferrableConstraint.initiallyImmediate,
      );
    },
  );

  test(
    'Given a foreign key manually declared as NOT DEFERRABLE, '
    'when reading the live database definition, '
    'then the foreign key is not deferrable.',
    () async {
      await serviceClient.insights.executeSql(
        'CREATE TABLE "$_parentTable" ("id" INTEGER PRIMARY KEY);',
      );
      await serviceClient.insights.executeSql('''
CREATE TABLE "$_childTable" (
  "id" INTEGER PRIMARY KEY,
  "parentId" INTEGER,
  CONSTRAINT "${_childTable}_fk_0" FOREIGN KEY ("parentId") REFERENCES "$_parentTable" ("id") NOT DEFERRABLE
);
''');

      var liveDefinition = await serviceClient.insights
          .getLiveDatabaseDefinition();
      var childTable = liveDefinition.tables.firstWhere(
        (table) => table.name == _childTable,
      );

      expect(childTable.foreignKeys, hasLength(1));
      expect(childTable.foreignKeyOn('parentId').deferrable, isNull);
    },
  );
}

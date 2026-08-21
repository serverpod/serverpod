@Timeout(Duration(minutes: 5))
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_server/test_util/migration_database_client.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given protocol model with added index', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetQueries: ['DROP TABLE IF EXISTS migrated_table;'],
        runQueries: runQueries,
      );
    });

    test(
      'when creating and applying migration then contains new index.',
      () async {
        var tag = 'add-index';
        var table = 'migrated_table';
        var initialStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
  ''',
        };
        await MigrationTestUtils.createInitialState(
          migrationProtocols: [initialStateProtocols],
          tag: tag,
        );

        var addedIndex = 'migrated_table_index';
        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
  indexes:
    $addedIndex:
      fields: anInt
      unique: false

  ''',
        };
        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
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
        var databaseTables = liveDefinition.tables.map((t) => t.name);
        expect(
          databaseTables,
          contains(table),
          reason: 'Could not find migration table in live table definitions.',
        );

        var migratedTable = liveDefinition.tables.firstWhere(
          (t) => t.name == table,
        );
        var tableIndexes = migratedTable.indexes.map((i) => i.indexName);
        expect(
          tableIndexes,
          contains(addedIndex),
          reason: 'Could not find added index for migrated table.',
        );
      },
    );
  });

  group('Given protocol model with index that is removed', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetQueries: ['DROP TABLE IF EXISTS migrated_table;'],
        runQueries: runQueries,
      );
    });

    test(
      'when creating and applying migration then index is removed from database.',
      () async {
        var tag = 'drop-index';
        var table = 'migrated_table';
        var indexToRemove = 'migrated_table_index';
        var initialStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
  indexes:
    $indexToRemove:
      fields: anInt
      unique: false
  ''',
        };
        await MigrationTestUtils.createInitialState(
          migrationProtocols: [initialStateProtocols],
          tag: tag,
        );

        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int

  ''',
        };
        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
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
        var databaseTables = liveDefinition.tables.map((t) => t.name);
        expect(
          databaseTables,
          contains(table),
          reason: 'Could not find migration table in live table definitions.',
        );

        var migratedTable = liveDefinition.tables.firstWhere(
          (t) => t.name == table,
        );
        var tableIndexes = migratedTable.indexes.map((i) => i.indexName);
        expect(
          tableIndexes,
          isNot(contains(indexToRemove)),
          reason: 'Could still find removed index for migrated table.',
        );
      },
    );
  });

  group('Given protocol model with added relation', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetQueries: ['DROP TABLE IF EXISTS migrated_table;'],
        runQueries: runQueries,
      );
    });

    test(
      'when creating and applying migration then database contains new relation.',
      () async {
        var tag = 'add-relation';
        var table = 'migrated_table';
        var initialStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
  ''',
        };
        await MigrationTestUtils.createInitialState(
          migrationProtocols: [initialStateProtocols],
          tag: tag,
        );

        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int, relation(parent=migrated_table)
  ''',
        };
        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
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
        var databaseTables = liveDefinition.tables.map((t) => t.name);
        expect(
          databaseTables,
          contains(table),
          reason: 'Could not find migration table in live table definitions.',
        );

        var migratedTable = liveDefinition.tables.firstWhere(
          (t) => t.name == table,
        );
        var relations = migratedTable.foreignKeys;
        expect(
          relations,
          isNotEmpty,
          reason: 'Could not find added relation for migrated table.',
        );
      },
    );
  });

  group('Given protocol model with relation that is removed', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetQueries: ['DROP TABLE IF EXISTS migrated_table;'],
        runQueries: runQueries,
      );
    });

    test(
      'when creating and applying migration then relation is removed from database.',
      () async {
        var tag = 'drop-relation';
        var table = 'migrated_table';
        var initialStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int, relation(parent=migrated_table)
  ''',
        };
        await MigrationTestUtils.createInitialState(
          migrationProtocols: [initialStateProtocols],
          tag: tag,
        );

        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
  ''',
        };
        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
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
        var databaseTables = liveDefinition.tables.map((t) => t.name);
        expect(
          databaseTables,
          contains(table),
          reason: 'Could not find migration table in live table definitions.',
        );

        var migratedTable = liveDefinition.tables.firstWhere(
          (t) => t.name == table,
        );
        var relations = migratedTable.foreignKeys;
        expect(
          relations,
          isEmpty,
          reason: 'Could still find relation for migrated table.',
        );
      },
    );
  });

  group('Given a protocol model referenced by a relation from another model,', () {
    var parentTable = 'migrated_table_parent';
    var childTable = 'migrated_table_child';

    late String tag;
    late String childProtocol;

    setUp(() async {
      tag = 'recreate-referenced-table';
      childProtocol =
          '''
  class: MigratedTableChild
  table: $childTable
  fields:
    parent: MigratedTableParent?, relation(onDelete=Cascade)
  ''';

      await MigrationTestUtils.createInitialState(
        migrationProtocols: [
          {
            'migrated_table_parent':
                '''
  class: MigratedTableParent
  table: $parentTable
  fields:
    anInt: int
  ''',
            'migrated_table_child': childProtocol,
          },
        ],
        tag: tag,
      );
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetQueries: [
          'DROP TABLE IF EXISTS $childTable, $parentTable CASCADE;',
        ],
        runQueries: runQueries,
      );
    });

    group(
      'when the referenced model is changed so that its table has to be deleted and recreated,',
      () {
        late DatabaseDefinition liveDefinition;

        setUp(() async {
          // The added non-nullable field without a default cannot be added to an
          // existing table, so the parent table is deleted and recreated.
          var createMigrationExitCode =
              await MigrationTestUtils.createMigrationFromProtocols(
                protocols: {
                  'migrated_table_parent':
                      '''
  class: MigratedTableParent
  table: $parentTable
  fields:
    anInt: int
    aRequiredString: String
  ''',
                  'migrated_table_child': childProtocol,
                },
                tag: tag,
                force: true,
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

          liveDefinition = await serviceClient.insights
              .getLiveDatabaseDefinition();
        });

        test(
          'then the relation of the referencing table is still in the database, with its delete action.',
          () {
            var liveChildTable = liveDefinition.tables.firstWhere(
              (t) => t.name == childTable,
            );

            expect(
              liveChildTable.foreignKeys.map(
                (key) => (key.referenceTable, key.onDelete),
              ),
              [(parentTable, ForeignKeyAction.cascade)],
              reason:
                  'The referencing table lost its relation when the referenced '
                  'table was dropped and recreated.',
            );
          },
        );
      },
    );
  });
}

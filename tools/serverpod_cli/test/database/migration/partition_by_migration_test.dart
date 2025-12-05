import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given a table without partition configuration',
    () {
      test(
        'when partition configuration is added then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').withPartitionBy([
                  'name',
                ]).build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.actions, hasLength(2));
          expect(
            migration.actions[0].type,
            DatabaseMigrationActionType.deleteTable,
          );
          expect(migration.actions[0].deleteTable, 'example');
          expect(
            migration.actions[1].type,
            DatabaseMigrationActionType.createTable,
          );
        },
      );

      test(
        'when partition configuration is added then a warning about table being dropped is generated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').withPartitionBy([
                  'name',
                ]).build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.warnings, isNotEmpty);
          var warning = migration.warnings.first;
          expect(
            warning.message,
            'Partition configuration of table "example" has changed. '
            'The table will be dropped and recreated as PostgreSQL does not '
            'support altering partition configuration.',
          );
          expect(warning.destrucive, isTrue);
        },
      );
    },
  );

  group(
    'Given a table with partition configuration',
    () {
      test(
        'when partition configuration is removed then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').withPartitionBy([
                  'name',
                ]).build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.actions, hasLength(2));
          expect(
            migration.actions[0].type,
            DatabaseMigrationActionType.deleteTable,
          );
          expect(
            migration.actions[1].type,
            DatabaseMigrationActionType.createTable,
          );
        },
      );

      test(
        'when partition columns are changed then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').withPartitionBy([
                  'name',
                ]).build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').withPartitionBy([
                  'category',
                ]).build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.actions, hasLength(2));
          expect(
            migration.actions[0].type,
            DatabaseMigrationActionType.deleteTable,
          );
          expect(
            migration.actions[1].type,
            DatabaseMigrationActionType.createTable,
          );
        },
      );

      test(
        'when partition column count is changed then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').withPartitionBy([
                  'name',
                ]).build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').withPartitionBy([
                  'name',
                  'category',
                ]).build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.actions, hasLength(2));
          expect(
            migration.actions[0].type,
            DatabaseMigrationActionType.deleteTable,
          );
          expect(
            migration.actions[1].type,
            DatabaseMigrationActionType.createTable,
          );
        },
      );

      test(
        'when partition configuration is unchanged then no migration action is generated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').withPartitionBy([
                  'name',
                ]).build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').withPartitionBy([
                  'name',
                ]).build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.actions, isEmpty);
        },
      );

      test(
        'when partition method is changed from list to range then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .withPartitionMethod(PartitionMethod.list)
                    .build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .withPartitionMethod(PartitionMethod.range)
                    .build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.actions, hasLength(2));
          expect(
            migration.actions[0].type,
            DatabaseMigrationActionType.deleteTable,
          );
          expect(
            migration.actions[1].type,
            DatabaseMigrationActionType.createTable,
          );
        },
      );

      test(
        'when partition method is changed from list to hash then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .withPartitionMethod(PartitionMethod.list)
                    .build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .withPartitionMethod(PartitionMethod.hash)
                    .build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.actions, hasLength(2));
          expect(
            migration.actions[0].type,
            DatabaseMigrationActionType.deleteTable,
          );
          expect(
            migration.actions[1].type,
            DatabaseMigrationActionType.createTable,
          );
        },
      );

      test(
        'when partition configuration is unchanged with same method then no migration is generated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .withPartitionMethod(PartitionMethod.list)
                    .build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .withPartitionMethod(PartitionMethod.list)
                    .build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.actions, isEmpty);
        },
      );
    },
  );

  group(
    'Given two tables without partition configuration',
    () {
      test(
        'when neither has partition then no migration action is generated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: srcDatabase,
            databaseTarget: dstDatabase,
          );

          expect(migration.actions, isEmpty);
        },
      );
    },
  );
}

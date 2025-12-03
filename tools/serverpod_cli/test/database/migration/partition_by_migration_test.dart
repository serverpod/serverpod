import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given source and target database definitions', () {
    group('when partition configuration is added to a table', () {
      test(
        'then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
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
          expect(migration.actions[0].deleteTable, 'example');
          expect(
            migration.actions[1].type,
            DatabaseMigrationActionType.createTable,
          );
        },
      );

      test(
        'then a warning about table being dropped is generated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder().withName('example').build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .build(),
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
            contains('Partition configuration'),
          );
          expect(warning.destrucive, isTrue);
        },
      );
    });

    group('when partition configuration is removed from a table', () {
      test(
        'then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .build(),
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
    });

    group('when partition configuration is changed', () {
      test(
        'with different columns then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['category'])
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
        'with different number of columns then the table is dropped and recreated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name', 'category'])
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
    });

    group('when partition configuration is unchanged', () {
      test(
        'with same columns then no migration action is generated.',
        () {
          var srcDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
                    .build(),
              )
              .build();

          var dstDatabase = DatabaseDefinitionBuilder()
              .withTable(
                TableDefinitionBuilder()
                    .withName('example')
                    .withPartitionBy(['name'])
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

      test(
        'with no partition on both then no migration action is generated.',
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

      test(
        'with same fields and same method then no migration is generated.',
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
    });

    group('when partition method is changed', () {
      test(
        'from list to range then the table is dropped and recreated.',
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
        'from list to hash then the table is dropped and recreated.',
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
    });
  });
}

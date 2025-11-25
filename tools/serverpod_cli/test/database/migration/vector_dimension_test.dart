import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given table with vector column with dimension 1536 as source and dimension 768 as target',
    () {
      var sourceDefinition = _singleVectorColumnDatabaseDefinition(1536);
      var targetDefinition = _singleVectorColumnDatabaseDefinition(768);

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('when migration is generated then one action is created.', () {
        expect(migration.actions, hasLength(1));
      });

      test(
        'when migration is generated then action is to alter the table with drop and add column.',
        () {
          var action = migration.actions.first;
          expect(action.type, DatabaseMigrationActionType.alterTable);

          var alterTable = action.alterTable!;
          expect(alterTable.deleteColumns, contains('embedding'));
          expect(
            alterTable.addColumns.any(
              (col) =>
                  col.name == 'embedding' &&
                  col.columnType == ColumnType.vector &&
                  col.vectorDimension == 768,
            ),
            isTrue,
          );
        },
      );

      test(
        'when migration is generated then warning is created for destructive change.',
        () {
          expect(migration.warnings, hasLength(1));
          expect(
            migration.warnings.first.type,
            DatabaseMigrationWarningType.columnDropped,
          );
          expect(migration.warnings.first.destrucive, isTrue);
        },
      );

      group('when SQL is generated', () {
        test(
          'then it contains DROP COLUMN statement.',
          () {
            var sql = migration.toPgSql(
              installedModules: [],
              removedModules: [],
            );

            expect(sql, contains('DROP COLUMN "embedding"'));
          },
        );

        test(
          'then it contains ADD COLUMN statement with new dimension.',
          () {
            var sql = migration.toPgSql(
              installedModules: [],
              removedModules: [],
            );

            expect(sql, contains('ADD COLUMN "embedding" vector(768)'));
          },
        );
      });
    },
  );

  group(
    'Given table with vector column with dimension 768 as source and dimension 1536 as target',
    () {
      var sourceDefinition = _singleVectorColumnDatabaseDefinition(768);
      var targetDefinition = _singleVectorColumnDatabaseDefinition(1536);

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('when migration is generated then one action is created.', () {
        expect(migration.actions, hasLength(1));
      });

      test(
        'when migration is generated then action is to alter the table with drop and add column.',
        () {
          var action = migration.actions.first;
          expect(action.type, DatabaseMigrationActionType.alterTable);

          var alterTable = action.alterTable!;
          expect(alterTable.deleteColumns, contains('embedding'));
          expect(
            alterTable.addColumns.any(
              (col) =>
                  col.name == 'embedding' &&
                  col.columnType == ColumnType.vector &&
                  col.vectorDimension == 1536,
            ),
            isTrue,
          );
        },
      );

      test(
        'when migration is generated then warning is created for destructive change.',
        () {
          expect(migration.warnings, hasLength(1));
          expect(
            migration.warnings.first.type,
            DatabaseMigrationWarningType.columnDropped,
          );
          expect(migration.warnings.first.destrucive, isTrue);
        },
      );
    },
  );

  group(
    'Given table with vector column with same dimension in source and target',
    () {
      var sourceDefinition = _singleVectorColumnDatabaseDefinition(768);
      var targetDefinition = _singleVectorColumnDatabaseDefinition(768);

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('when migration is generated then no actions are created.', () {
        expect(migration.actions, hasLength(0));
      });

      test('when migration is generated then no warnings are created.', () {
        expect(migration.warnings, hasLength(0));
      });
    },
  );

  group(
    'Given table with halfvec column with dimension 512 as source and dimension 256 as target',
    () {
      var sourceDefinition = _singleVectorColumnDatabaseDefinition(
        512,
        columnType: ColumnType.halfvec,
      );
      var targetDefinition = _singleVectorColumnDatabaseDefinition(
        256,
        columnType: ColumnType.halfvec,
      );

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('when migration is generated then one action is created.', () {
        expect(migration.actions, hasLength(1));
      });

      test(
        'when migration is generated then action is to alter the table with drop and add column.',
        () {
          var action = migration.actions.first;
          expect(action.type, DatabaseMigrationActionType.alterTable);

          var alterTable = action.alterTable!;
          expect(alterTable.deleteColumns, contains('embedding'));
          expect(
            alterTable.addColumns.any(
              (col) =>
                  col.name == 'embedding' &&
                  col.columnType == ColumnType.halfvec &&
                  col.vectorDimension == 256,
            ),
            isTrue,
          );
        },
      );
    },
  );
}

DatabaseDefinition _singleVectorColumnDatabaseDefinition(
  int dimension, {
  ColumnType columnType = ColumnType.vector,
}) {
  return DatabaseDefinitionBuilder()
      .withTable(
        TableDefinitionBuilder()
            .withName('rag_document')
            .withColumn(
              ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(columnType)
                  .withVectorDimension(dimension)
                  .withIsNullable(true)
                  .withDartType('List<double>?')
                  .build(),
            )
            .build(),
      )
      .build();
}

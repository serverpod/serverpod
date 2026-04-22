import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given table with Decimal column with precision 19 scale 4 as source and precision 10 scale 2 as target',
    () {
      var sourceDefinition = _singleDecimalColumnDatabaseDefinition(19, 4);
      var targetDefinition = _singleDecimalColumnDatabaseDefinition(10, 2);

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
          expect(alterTable.deleteColumns, contains('price'));
          expect(
            alterTable.addColumns.any(
              (col) =>
                  col.name == 'price' &&
                  col.columnType == ColumnType.decimal &&
                  col.decimalPrecision == 10 &&
                  col.decimalScale == 2,
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
          expect(migration.warnings.first.destructive, isTrue);
        },
      );

      group('when SQL is generated', () {
        late var sql = migration.toPgSql(
          databaseDefinition: targetDefinition,
          installedModules: [],
          removedModules: [],
        );

        test('then it contains DROP COLUMN statement.', () {
          expect(sql, contains('DROP COLUMN "price"'));
        });

        test(
          'then it contains ADD COLUMN statement with new precision and scale.',
          () {
            expect(sql, contains('ADD COLUMN "price" decimal(10,2)'));
          },
        );
      });
    },
  );

  group(
    'Given table with Decimal column with precision 10 scale 2 as source and precision 19 scale 4 as target',
    () {
      var sourceDefinition = _singleDecimalColumnDatabaseDefinition(10, 2);
      var targetDefinition = _singleDecimalColumnDatabaseDefinition(19, 4);

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
          expect(alterTable.deleteColumns, contains('price'));
          expect(
            alterTable.addColumns.any(
              (col) =>
                  col.name == 'price' &&
                  col.columnType == ColumnType.decimal &&
                  col.decimalPrecision == 19 &&
                  col.decimalScale == 4,
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
          expect(migration.warnings.first.destructive, isTrue);
        },
      );
    },
  );

  group(
    'Given table with Decimal column with same precision and scale only changed (10,2 to 10,4)',
    () {
      var sourceDefinition = _singleDecimalColumnDatabaseDefinition(10, 2);
      var targetDefinition = _singleDecimalColumnDatabaseDefinition(10, 4);

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
          expect(alterTable.deleteColumns, contains('price'));
          expect(
            alterTable.addColumns.any(
              (col) =>
                  col.name == 'price' &&
                  col.columnType == ColumnType.decimal &&
                  col.decimalPrecision == 10 &&
                  col.decimalScale == 4,
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
          expect(migration.warnings.first.destructive, isTrue);
        },
      );
    },
  );

  group(
    'Given table with Decimal column with same precision and scale in source and target',
    () {
      var sourceDefinition = _singleDecimalColumnDatabaseDefinition(10, 2);
      var targetDefinition = _singleDecimalColumnDatabaseDefinition(10, 2);

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
    'Given table with unbounded Decimal column as source and Decimal(10,2) as target',
    () {
      var sourceDefinition = _singleDecimalColumnDatabaseDefinition(null, null);
      var targetDefinition = _singleDecimalColumnDatabaseDefinition(10, 2);

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
          expect(alterTable.deleteColumns, contains('price'));
          expect(
            alterTable.addColumns.any(
              (col) =>
                  col.name == 'price' &&
                  col.columnType == ColumnType.decimal &&
                  col.decimalPrecision == 10 &&
                  col.decimalScale == 2,
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
          expect(migration.warnings.first.destructive, isTrue);
        },
      );
    },
  );

  group(
    'Given table with Decimal(10,2) column as source and unbounded Decimal as target',
    () {
      var sourceDefinition = _singleDecimalColumnDatabaseDefinition(10, 2);
      var targetDefinition = _singleDecimalColumnDatabaseDefinition(null, null);

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
          expect(alterTable.deleteColumns, contains('price'));
          expect(
            alterTable.addColumns.any(
              (col) =>
                  col.name == 'price' &&
                  col.columnType == ColumnType.decimal &&
                  col.decimalPrecision == null &&
                  col.decimalScale == null,
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
          expect(migration.warnings.first.destructive, isTrue);
        },
      );
    },
  );

  group(
    'Given table with unbounded Decimal column with same type in source and target',
    () {
      var sourceDefinition = _singleDecimalColumnDatabaseDefinition(null, null);
      var targetDefinition = _singleDecimalColumnDatabaseDefinition(null, null);

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
}

DatabaseDefinition _singleDecimalColumnDatabaseDefinition(
  int? precision,
  int? scale,
) {
  var dartType = precision != null ? 'Decimal($precision,$scale)' : 'Decimal';
  return DatabaseDefinitionBuilder()
      .withTable(
        TableDefinitionBuilder()
            .withName('product')
            .withColumn(
              ColumnDefinitionBuilder()
                  .withName('price')
                  .withColumnType(ColumnType.decimal)
                  .withDecimalPrecision(precision)
                  .withDecimalScale(scale)
                  .withIsNullable(true)
                  .withDartType('$dartType?')
                  .build(),
            )
            .build(),
      )
      .build();
}

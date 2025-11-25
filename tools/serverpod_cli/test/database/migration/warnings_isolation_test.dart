import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given multiple tables where one table has a warning that requires recreation '
    'when generating migration',
    () {
      // Create a source database with three tables
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('table_one')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('column_a')
                      .withIsNullable(true)
                      .build(),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_two')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('column_b')
                      .withIsNullable(true)
                      .build(),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_three')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('column_c')
                      .withIsNullable(true)
                      .build(),
                )
                .build(),
          )
          .build();

      // Create a target database where:
      // - table_one gets a new nullable column (simple alter)
      // - table_two gets a new non-nullable column without default (requires recreation)
      // - table_three gets a modified column (simple alter)
      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('table_one')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('column_a')
                      .withIsNullable(true)
                      .build(),
                )
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('new_column_a')
                      .withIsNullable(true)
                      .build(),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_two')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('column_b')
                      .withIsNullable(true)
                      .build(),
                )
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('new_column_b')
                      .withIsNullable(false)
                      .build(),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_three')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('column_c')
                      .withIsNullable(false)
                      .withColumnDefault('\'default_value\'')
                      .build(),
                )
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test(
        'then migration contains correct number of actions.',
        () {
          // Should have 3 actions:
          // 1. alterTable for table_one
          // 2. deleteTable for table_two
          // 3. createTable for table_two
          // 4. alterTable for table_three
          expect(migration.actions, hasLength(4));
        },
      );

      test('then top-level warnings contain correct number of warnings.', () {
        expect(migration.warnings, hasLength(2));
      });

      test(
        'then table_one alterTable has no warnings.',
        () {
          var tableOneAction = migration.actions.firstWhere(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'table_one',
          );

          expect(tableOneAction.alterTable?.warnings, isEmpty);
        },
      );

      test(
        'then table_three alterTable has only table_three warnings.',
        () {
          var tableThreeAction = migration.actions.firstWhere(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'table_three',
          );

          expect(tableThreeAction.alterTable?.warnings, hasLength(1));
          expect(
            tableThreeAction.alterTable?.warnings.first.table,
            equals('table_three'),
          );
        },
      );

      test(
        'then top-level warnings contain table_two warning.',
        () {
          expect(
            migration.warnings
                .where((warning) => warning.table == 'table_two')
                .length,
            equals(1),
          );
        },
      );

      test(
        'then top-level warnings contain table_three warning.',
        () {
          expect(
            migration.warnings
                .where((warning) => warning.table == 'table_three')
                .length,
            equals(1),
          );
        },
      );

      test(
        'then top-level warnings do not contain warnings for table_one.',
        () {
          expect(
            migration.warnings.any((warning) => warning.table == 'table_one'),
            isFalse,
          );
        },
      );
    },
  );

  group(
    'Given two tables where both have warnings but only one requires recreation '
    'when generating migration',
    () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('table_alpha')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('existing_column')
                      .withIsNullable(true)
                      .build(),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_beta')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('existing_column')
                      .withIsNullable(true)
                      .build(),
                )
                .build(),
          )
          .build();

      // table_alpha: adding a non-nullable column without default (recreation)
      // table_beta: making an existing column non-nullable (warning but no recreation)
      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('table_alpha')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('existing_column')
                      .withIsNullable(true)
                      .build(),
                )
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('new_required_column')
                      .withIsNullable(false)
                      .build(),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_beta')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('existing_column')
                      .withIsNullable(false)
                      .withColumnDefault('\'default\'')
                      .build(),
                )
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then top-level warnings contain both table warnings.', () {
        expect(migration.warnings, hasLength(2));
      });

      test('then table_beta alterTable has only table_beta warnings.', () {
        var tableBetaAction = migration.actions.firstWhere(
          (action) =>
              action.type == DatabaseMigrationActionType.alterTable &&
              action.alterTable?.name == 'table_beta',
        );

        final tableBetaWarnings = tableBetaAction.alterTable?.warnings;
        expect(tableBetaWarnings, hasLength(1));
        expect(tableBetaWarnings?.first.table, equals('table_beta'));
      });
    },
  );
}

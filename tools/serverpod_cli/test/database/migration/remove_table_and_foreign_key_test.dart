import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given two tables with a foreign key relation '
    'when the referenced table and the foreign key pointing to it are removed',
    () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('grant_allowance')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('granteeOwnerId')
                      .withColumnType(ColumnType.uuid)
                      .withIsNullable(false)
                      .build(),
                )
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('grantBundleId')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(true)
                      .build(),
                )
                .withForeignKey(
                  ForeignKeyDefinition(
                    constraintName: 'grant_bundle_allowances_fk',
                    columns: ['grantBundleId'],
                    referenceTable: 'grant_bundle',
                    referenceTableSchema: 'public',
                    referenceColumns: ['id'],
                    onUpdate: ForeignKeyAction.noAction,
                    onDelete: ForeignKeyAction.cascade,
                    matchType: null,
                  ),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('grant_bundle')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('productId')
                      .withColumnType(ColumnType.text)
                      .withIsNullable(false)
                      .build(),
                )
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('grant_allowance')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('granteeOwnerId')
                      .withColumnType(ColumnType.uuid)
                      .withIsNullable(false)
                      .build(),
                )
                // grantBundleId column removed, foreign key removed
                .build(),
          )
          // grant_bundle table removed
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test(
        'then grant_allowance table should only be altered to drop the foreign key and column, not deleted and recreated.',
        () {
          var grantAllowanceDeleteActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.deleteTable &&
                action.deleteTable == 'grant_allowance',
          );

          var grantAllowanceCreateActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.createTable &&
                action.createTable?.name == 'grant_allowance',
          );

          var grantAllowanceAlterActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'grant_allowance',
          );

          expect(
            grantAllowanceDeleteActions,
            isEmpty,
            reason: 'grant_allowance should not be deleted',
          );
          expect(
            grantAllowanceCreateActions,
            isEmpty,
            reason: 'grant_allowance should not be recreated',
          );
          expect(
            grantAllowanceAlterActions,
            hasLength(1),
            reason:
                'grant_allowance should be altered to drop the foreign key and column',
          );
        },
      );

      test(
        'then grant_bundle table should be deleted.',
        () {
          var grantBundleDeleteActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.deleteTable &&
                action.deleteTable == 'grant_bundle',
          );

          expect(grantBundleDeleteActions, hasLength(1));
        },
      );

      test(
        'then the alter action for grant_allowance should drop the column but not explicitly drop the FK.',
        () {
          var alterAction = migration.actions.firstWhere(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'grant_allowance',
            orElse: () => DatabaseMigrationAction(
              type: DatabaseMigrationActionType.createTable,
            ),
          );

          expect(
            alterAction.alterTable?.deleteColumns,
            contains('grantBundleId'),
            reason: 'Column should be dropped',
          );

          // The FK should NOT be explicitly dropped because dropping the column
          // automatically drops the FK
          expect(
            alterAction.alterTable?.deleteForeignKeys,
            isEmpty,
            reason: 'FK should not be explicitly dropped when its column is dropped',
          );
        },
      );
    },
  );

  group(
    'Given two tables with a foreign key relation '
    'when only the referenced table is removed but the foreign key pointing to it remains',
    () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('table_a')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('table_b_id')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(true)
                      .build(),
                )
                .withForeignKey(
                  ForeignKeyDefinition(
                    constraintName: 'table_a_table_b_fk',
                    columns: ['table_b_id'],
                    referenceTable: 'table_b',
                    referenceTableSchema: 'public',
                    referenceColumns: ['id'],
                    onUpdate: ForeignKeyAction.noAction,
                    onDelete: ForeignKeyAction.noAction,
                    matchType: null,
                  ),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_b')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('data')
                      .withColumnType(ColumnType.text)
                      .withIsNullable(false)
                      .build(),
                )
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('table_a')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('table_b_id')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(true)
                      .build(),
                )
                .withForeignKey(
                  ForeignKeyDefinition(
                    constraintName: 'table_a_table_b_fk',
                    columns: ['table_b_id'],
                    referenceTable: 'table_b',
                    referenceTableSchema: 'public',
                    referenceColumns: ['id'],
                    onUpdate: ForeignKeyAction.noAction,
                    onDelete: ForeignKeyAction.noAction,
                    matchType: null,
                  ),
                )
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test(
        'then table_a should be deleted and recreated because the foreign key '
        'would point to a non-existent table.',
        () {
          var tableADeleteActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.deleteTable &&
                action.deleteTable == 'table_a',
          );

          var tableACreateActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.createTable &&
                action.createTable?.name == 'table_a',
          );

          expect(tableADeleteActions, hasLength(1));
          expect(tableACreateActions, hasLength(1));
        },
      );
    },
  );

  group(
    'Given a table with multiple foreign keys with sequential constraint names (_fk_0, _fk_1, etc.) '
    'when the first foreign key and its referenced table are removed',
    () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('main_table')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('table_b_id')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(true)
                      .build(),
                )
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('table_c_id')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(true)
                      .build(),
                )
                .withForeignKey(
                  ForeignKeyDefinition(
                    constraintName: 'main_table_fk_0', // Points to table_b
                    columns: ['table_b_id'],
                    referenceTable: 'table_b',
                    referenceTableSchema: 'public',
                    referenceColumns: ['id'],
                    onUpdate: ForeignKeyAction.noAction,
                    onDelete: ForeignKeyAction.noAction,
                    matchType: null,
                  ),
                )
                .withForeignKey(
                  ForeignKeyDefinition(
                    constraintName: 'main_table_fk_1', // Points to table_c
                    columns: ['table_c_id'],
                    referenceTable: 'table_c',
                    referenceTableSchema: 'public',
                    referenceColumns: ['id'],
                    onUpdate: ForeignKeyAction.noAction,
                    onDelete: ForeignKeyAction.noAction,
                    matchType: null,
                  ),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_b')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('data')
                      .withColumnType(ColumnType.text)
                      .withIsNullable(false)
                      .build(),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_c')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('data')
                      .withColumnType(ColumnType.text)
                      .withIsNullable(false)
                      .build(),
                )
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('main_table')
                // table_b_id column removed
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('table_c_id')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(true)
                      .build(),
                )
                // Foreign key to table_b removed
                // Foreign key to table_c is renumbered to _fk_0
                .withForeignKey(
                  ForeignKeyDefinition(
                    constraintName: 'main_table_fk_0', // Renumbered to table_c
                    columns: ['table_c_id'],
                    referenceTable: 'table_c',
                    referenceTableSchema: 'public',
                    referenceColumns: ['id'],
                    onUpdate: ForeignKeyAction.noAction,
                    onDelete: ForeignKeyAction.noAction,
                    matchType: null,
                  ),
                )
                .build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('table_c')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('data')
                      .withColumnType(ColumnType.text)
                      .withIsNullable(false)
                      .build(),
                )
                .build(),
          )
          // table_b is removed
          .build();

      late var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );
      late var mainTableDeleteActions = migration.actions.where(
        (action) =>
            action.type == DatabaseMigrationActionType.deleteTable &&
            action.deleteTable == 'main_table',
      );

      late var mainTableCreateActions = migration.actions.where(
        (action) =>
            action.type == DatabaseMigrationActionType.createTable &&
            action.createTable?.name == 'main_table',
      );

      late var mainTableAlterActions = migration.actions.where(
        (action) =>
            action.type == DatabaseMigrationActionType.alterTable &&
            action.alterTable?.name == 'main_table',
      );

      test(
        'then main_table should only be altered, not dropped and recreated.',
        () {
          expect(
            mainTableDeleteActions,
            isEmpty,
            reason: 'main_table should not be deleted',
          );
          expect(
            mainTableCreateActions,
            isEmpty,
            reason: 'main_table should not be recreated',
          );
          expect(
            mainTableAlterActions,
            hasLength(1),
            reason:
                'main_table should be altered to remove the foreign key to table_b',
          );
        },
      );

      test(
        'then the alter action for main_table should drop FK to table_b (fk_1) and add FK to table_c (renumbered to fk_0).',
        () {
          var alterAction = mainTableAlterActions.first;
          var alterTable = alterAction.alterTable;

          expect(
            alterTable?.deleteColumns,
            contains('table_b_id'),
            reason: 'alterTable should delete the table_b_id column',
          );

          // Should delete main_table_fk_1 (the FK for table_c in the source)
          // Should NOT delete main_table_fk_0 (the FK for table_b) because its column is being dropped
          expect(
            alterTable?.deleteForeignKeys,
            contains('main_table_fk_1'),
            reason:
                'alterTable should delete the foreign key with constraintName main_table_fk_1 (will be renumbered)',
          );

          expect(
            alterTable?.deleteForeignKeys,
            isNot(contains('main_table_fk_0')),
            reason:
                'alterTable should NOT delete main_table_fk_0 because its column (table_b_id) is being dropped',
          );

          expect(
            alterTable?.addForeignKeys,
            isNotEmpty,
            reason: 'alterTable should add a foreign key',
          );

          expect(
            alterTable?.addForeignKeys.any(
              (fk) =>
                  fk.constraintName == 'main_table_fk_0' &&
                  fk.referenceTable == 'table_c',
            ),
            isTrue,
            reason:
                'alterTable should add a foreign key with constraintName main_table_fk_0 referencing table_c',
          );
        },
      );
    },
  );
}

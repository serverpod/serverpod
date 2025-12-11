import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given two tables with a foreign key relation when the referenced table '
    'and the foreign key are removed',
    () {
      // Simulate the scenario from the bug report:
      // 1. GrantAllowance (table A) has a foreign key to GrantBundle (table B)
      // 2. Both the GrantBundle table and the foreign key from GrantAllowance are removed
      // Expected: Only the foreign key column should be dropped from GrantAllowance
      // Bug: The entire GrantAllowance table is dropped and recreated

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

      // Target: GrantBundle table is removed, and the foreign key + column
      // are removed from GrantAllowance
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
        'then grant_allowance table should be altered, not deleted and recreated.',
        () {
          // Should have:
          // 1. Delete grant_bundle table
          // 2. Alter grant_allowance table (drop foreign key and column)
          
          // Filter out actions related to grant_allowance
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

          // grant_allowance should only be altered
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
            reason: 'grant_allowance should be altered to drop the foreign key and column',
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
        'then the alter action for grant_allowance should drop the foreign key.',
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
            alterAction.alterTable?.deleteForeignKeys,
            contains('grant_bundle_allowances_fk'),
          );
        },
      );

      test(
        'then the alter action for grant_allowance should drop the column.',
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
          );
        },
      );
    },
  );

  group(
    'Given two tables with a foreign key relation when only the referenced '
    'table is removed but the foreign key remains',
    () {
      // This is the scenario where the table SHOULD be dropped and recreated
      // because we cannot have a foreign key pointing to a non-existent table

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

      // Target: table_b is removed, but table_a STILL has the foreign key
      // (This is an invalid state, but we need to handle it)
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
    'Given a table with multiple foreign keys when the first foreign key '
    'and its referenced table are removed',
    () {
      // This tests a potential bug where foreign key constraint names are
      // numbered sequentially (_fk_0, _fk_1, etc.), and removing one might
      // cause the remaining ones to be renumbered, leading to incorrect
      // detection of "retained" foreign keys.

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

      // Target: table_b is removed, and the foreign key to it is removed.
      // However, the foreign key to table_c might get renumbered from _fk_1 to _fk_0
      // which could confuse the logic.
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
                    constraintName: 'main_table_fk_0', // NOW points to table_c (renumbered)
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

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test(
        'then main_table should only be altered, not dropped and recreated.',
        () {
          // After the fix, main_table should only be altered, not dropped
          // even though there's a constraint name collision (_fk_0 exists in both
          // source and target), because we now also check that the foreign key
          // references the same table.

          var mainTableDeleteActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.deleteTable &&
                action.deleteTable == 'main_table',
          );

          var mainTableCreateActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.createTable &&
                action.createTable?.name == 'main_table',
          );

          var mainTableAlterActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'main_table',
          );

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
            reason: 'main_table should be altered to remove the foreign key to table_b',
          );
        },
      );
    },
  );
}

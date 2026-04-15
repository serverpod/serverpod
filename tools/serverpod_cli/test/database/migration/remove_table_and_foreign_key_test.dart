import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given two tables with a foreign key relation '
    'when the referenced table is dropped and the foreign key column is removed from the other table',
    () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder().withName('child_entity').build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('parent_entity')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('childEntityId')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(true)
                      .build(),
                )
                .withForeignKey(
                  ForeignKeyDefinition(
                    constraintName: 'parent_entity_fk_0',
                    columns: ['childEntityId'],
                    referenceTable: 'child_entity',
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

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName('parent_entity')
                // childEntityId column and foreign key removed
                .build(),
          )
          // child_entity table removed
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var psql = migration.toPgSql(
        databaseDefinition: targetDefinition,
        installedModules: [],
        removedModules: [],
      );

      test(
        'then the generated SQL should contain DROP TABLE child_entity CASCADE.',
        () {
          expect(psql, contains('DROP TABLE "child_entity" CASCADE'));
        },
      );

      test(
        'then the generated SQL uses DROP CONSTRAINT IF EXISTS to avoid a hard '
        'failure for already removed constraints after DROP TABLE CASCADE.',
        () {
          expect(
            psql,
            contains(
              'ALTER TABLE "parent_entity" DROP CONSTRAINT IF EXISTS "parent_entity_fk_0"',
            ),
            reason:
                'DROP CONSTRAINT IF EXISTS is used to avoid a hard failure '
                'for already removed constraints after DROP TABLE CASCADE.',
          );
        },
      );

      test(
        'then the generated SQL should still DROP COLUMN for the foreign key column.',
        () {
          expect(psql, contains('DROP COLUMN "childEntityId"'));
        },
      );

      test(
        'then DROP TABLE CASCADE should appear before DROP COLUMN in the generated SQL.',
        () {
          var dropTableIndex = psql.indexOf(
            'DROP TABLE "child_entity" CASCADE',
          );
          var dropColumnIndex = psql.indexOf('DROP COLUMN "childEntityId"');

          expect(dropTableIndex, greaterThanOrEqualTo(0));
          expect(dropColumnIndex, greaterThanOrEqualTo(0));
          expect(
            dropTableIndex,
            lessThan(dropColumnIndex),
            reason:
                'DROP TABLE CASCADE must precede DROP COLUMN so that the column '
                'can be safely dropped after the FK constraint is removed.',
          );
        },
      );
    },
  );

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
        'then the alter action for grant_allowance should list the foreign key '
        'to drop so each dialect can react accordingly.',
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
        'then the alter action for main_table should drop the foreign key to table_b and add a foreign key to table_c.',
        () {
          var alterAction = mainTableAlterActions.first;
          var alterTable = alterAction.alterTable;

          expect(
            alterTable?.deleteColumns,
            contains('table_b_id'),
            reason: 'alterTable should delete the table_b_id column',
          );

          expect(
            alterTable?.deleteForeignKeys,
            contains('main_table_fk_0'),
            reason:
                'alterTable should delete the foreign key with constraintName main_table_fk_0 that referenced table_b',
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

      test(
        'then the generated SQL should use IF EXISTS when dropping main_table_fk_0 '
        'after DROP TABLE table_b CASCADE.',
        () {
          var psql = migration.toPgSql(
            databaseDefinition: targetDefinition,
            installedModules: [],
            removedModules: [],
          );

          expect(
            psql,
            contains(
              'ALTER TABLE "main_table" DROP CONSTRAINT IF EXISTS "main_table_fk_0"',
            ),
          );
          expect(psql, contains('DROP TABLE "table_b" CASCADE'));
        },
      );
    },
  );

  group(
    'Given a table that references another table by foreign key, '
    'when the referenced table is dropped and replaced by a new table and the '
    'referencing table uses a new column while reusing the same constraint name,',
    () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder().withName('old_server_settings').build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('global_settings')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('jdfServerSettingsId')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(true)
                      .build(),
                )
                .withForeignKey(
                  ForeignKeyDefinition(
                    constraintName: 'global_settings_fk_0',
                    columns: ['jdfServerSettingsId'],
                    referenceTable: 'old_server_settings',
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

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder().withName('new_server_settings').build(),
          )
          .withTable(
            TableDefinitionBuilder()
                .withName('global_settings')
                .withColumn(
                  ColumnDefinitionBuilder()
                      .withName('globalServerSettingsId')
                      .withColumnType(ColumnType.bigint)
                      .withIsNullable(true)
                      .build(),
                )
                .withForeignKey(
                  ForeignKeyDefinition(
                    constraintName: 'global_settings_fk_0',
                    columns: ['globalServerSettingsId'],
                    referenceTable: 'new_server_settings',
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

      late var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test(
        'then the alter action for global_settings lists the old foreign key '
        'so SQLite can apply the schema change.',
        () {
          var alterAction = migration.actions.firstWhere(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'global_settings',
            orElse: () => DatabaseMigrationAction(
              type: DatabaseMigrationActionType.createTable,
            ),
          );

          expect(
            alterAction.alterTable?.deleteForeignKeys,
            contains('global_settings_fk_0'),
          );
        },
      );

      test(
        'then the generated SQL uses DROP CONSTRAINT IF EXISTS for '
        'global_settings_fk_0 after DROP TABLE old_server_settings CASCADE.',
        () {
          var psql = migration.toPgSql(
            databaseDefinition: targetDefinition,
            installedModules: [],
            removedModules: [],
          );

          expect(
            psql,
            contains(
              'ALTER TABLE "global_settings" DROP CONSTRAINT IF EXISTS '
              '"global_settings_fk_0"',
            ),
          );
          expect(psql, contains('DROP TABLE "old_server_settings" CASCADE'));
          expect(psql, contains('CREATE TABLE "new_server_settings"'));
          expect(
            psql,
            contains(
              'ADD CONSTRAINT "global_settings_fk_0"',
            ),
          );
          expect(
            psql,
            contains('REFERENCES "new_server_settings"("id")'),
          );
        },
      );

      test(
        'then DROP TABLE old_server_settings CASCADE must appear before '
        'ALTER TABLE global_settings.',
        () {
          var psql = migration.toPgSql(
            databaseDefinition: targetDefinition,
            installedModules: [],
            removedModules: [],
          );

          var dropOldIndex = psql.indexOf(
            'DROP TABLE "old_server_settings" CASCADE',
          );
          var alterGlobalIndex = psql.indexOf('ALTER TABLE "global_settings"');

          expect(dropOldIndex, greaterThanOrEqualTo(0));
          expect(alterGlobalIndex, greaterThanOrEqualTo(0));
          expect(dropOldIndex, lessThan(alterGlobalIndex));
        },
      );
    },
  );
}

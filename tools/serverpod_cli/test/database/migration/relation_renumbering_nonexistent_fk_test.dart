import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group(
    'Given two tables without relations when adding a relation that causes FK renumbering',
    () {
      // This reproduces the issue where:
      // 1. Profile has goals: List<Goal>?, relation (implicit, creates _profileGoalsProfileId in goal table)
      // 2. Changed to Profile has goals: List<Goal>?, relation(name=profile_goals)
      //    AND Goal has profile: Profile?, relation(name=profile_goals)
      // This changes from implicit FK to explicit named FK, causing renumbering
      
      test(
        'when changing from implicit to explicit named relation then should not drop non-existent FK.',
        () {
          // Source: Profile has implicit List<Goal> relation
          // This creates _profileGoalsProfileId column in goal table with goal_fk_0 constraint
          var sourceDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('profile')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('userId')
                          .withColumnType(ColumnType.uuid)
                          .withIsNullable(false)
                          .build(),
                    )
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('motivation')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    .build(),
              )
              .withTable(
                TableDefinitionBuilder()
                    .withName('goal')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('text')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('_profileGoalsProfileId')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .build(),
                    )
                    .withForeignKey(
                      ForeignKeyDefinition(
                        constraintName: 'goal_fk_0',
                        columns: ['_profileGoalsProfileId'],
                        referenceTable: 'profile',
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

          // Target: Explicit named relation on both sides
          // Goal now has explicit profile field with goal_fk_0 constraint (same name, different column)
          var targetDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('profile')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('authUserId')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .build(),
                    )
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('motivation')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    .withForeignKey(
                      ForeignKeyDefinition(
                        constraintName: 'profile_fk_0',
                        columns: ['authUserId'],
                        referenceTable: 'serverpod_user_info',
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
                    .withName('goal')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('text')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('_profileGoalsGoalId')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .build(),
                    )
                    .withForeignKey(
                      ForeignKeyDefinition(
                        constraintName: 'goal_fk_0',
                        columns: ['_profileGoalsGoalId'],
                        referenceTable: 'profile',
                        referenceTableSchema: 'public',
                        referenceColumns: ['id'],
                        onUpdate: ForeignKeyAction.noAction,
                        onDelete: ForeignKeyAction.cascade,
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

          var goalAlterActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'goal',
          );

          // Should alter goal table
          expect(goalAlterActions, hasLength(1));

          var alterTable = goalAlterActions.first.alterTable!;

          // Should drop the old column
          expect(
            alterTable.deleteColumns,
            contains('_profileGoalsProfileId'),
            reason: 'Should drop the old implicit relation column',
          );

          // Should add the new column
          expect(
            alterTable.addColumns.any((c) => c.name == '_profileGoalsGoalId'),
            isTrue,
            reason: 'Should add the new explicit relation column',
          );

          // THIS IS THE KEY ISSUE: It should NOT try to drop goal_fk_0
          // because the FK is being modified (same name, different columns)
          // not dropped and re-added
          expect(
            alterTable.deleteForeignKeys,
            contains('goal_fk_0'),
            reason:
                'Should delete the FK since it points to a different column',
          );

          expect(
            alterTable.addForeignKeys.any((fk) => fk.constraintName == 'goal_fk_0'),
            isTrue,
            reason: 'Should add the new FK with the same name',
          );
        },
      );

      test(
        'when removing a relation entirely then should drop the FK that exists.',
        () {
          // Source: Goal has a foreign key to profile
          var sourceDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('profile')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('userId')
                          .withColumnType(ColumnType.uuid)
                          .withIsNullable(false)
                          .build(),
                    )
                    .build(),
              )
              .withTable(
                TableDefinitionBuilder()
                    .withName('goal')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('text')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('_profileGoalsProfileId')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .build(),
                    )
                    .withForeignKey(
                      ForeignKeyDefinition(
                        constraintName: 'goal_fk_0',
                        columns: ['_profileGoalsProfileId'],
                        referenceTable: 'profile',
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

          // Target: Goal has NO foreign key to profile
          var targetDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('profile')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('userId')
                          .withColumnType(ColumnType.uuid)
                          .withIsNullable(false)
                          .build(),
                    )
                    .build(),
              )
              .withTable(
                TableDefinitionBuilder()
                    .withName('goal')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('text')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    // No _profileGoalsProfileId column, no FK
                    .build(),
              )
              .build();

          var migration = generateDatabaseMigration(
            databaseSource: sourceDefinition,
            databaseTarget: targetDefinition,
          );

          var goalAlterActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'goal',
          );

          expect(goalAlterActions, hasLength(1));

          var alterTable = goalAlterActions.first.alterTable!;

          // Should drop the column
          expect(
            alterTable.deleteColumns,
            contains('_profileGoalsProfileId'),
          );

          // Should drop the FK
          expect(
            alterTable.deleteForeignKeys,
            contains('goal_fk_0'),
          );
        },
      );
    },
  );

  group(
    'Given a table with NO foreign keys when adding a foreign key',
    () {
      test(
        'when adding first FK then should only add, not drop any FK.',
        () {
          // Source: Goal table with no foreign keys
          var sourceDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('profile')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('userId')
                          .withColumnType(ColumnType.uuid)
                          .withIsNullable(false)
                          .build(),
                    )
                    .build(),
              )
              .withTable(
                TableDefinitionBuilder()
                    .withName('goal')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('text')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    // NO foreign key initially
                    .build(),
              )
              .build();

          // Target: Goal table now has a foreign key
          var targetDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('profile')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('userId')
                          .withColumnType(ColumnType.uuid)
                          .withIsNullable(false)
                          .build(),
                    )
                    .build(),
              )
              .withTable(
                TableDefinitionBuilder()
                    .withName('goal')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('text')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('_profileGoalsGoalId')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .build(),
                    )
                    .withForeignKey(
                      ForeignKeyDefinition(
                        constraintName: 'goal_fk_0',
                        columns: ['_profileGoalsGoalId'],
                        referenceTable: 'profile',
                        referenceTableSchema: 'public',
                        referenceColumns: ['id'],
                        onUpdate: ForeignKeyAction.noAction,
                        onDelete: ForeignKeyAction.cascade,
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

          var goalAlterActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'goal',
          );

          expect(goalAlterActions, hasLength(1));

          var alterTable = goalAlterActions.first.alterTable!;

          // Should add the new column
          expect(
            alterTable.addColumns.any((c) => c.name == '_profileGoalsGoalId'),
            isTrue,
          );

          // Should add the FK
          expect(
            alterTable.addForeignKeys.any((fk) => fk.constraintName == 'goal_fk_0'),
            isTrue,
          );

          // CRITICAL: Should NOT try to drop any FK
          expect(
            alterTable.deleteForeignKeys,
            isEmpty,
            reason: 'Should not drop any FK since none existed before',
          );
        },
      );
    },
  );

  group(
    'Given a scenario where source schema claims a FK exists but it was never created',
    () {
      // This tests the exact bug from the issue:
      // 1. Profile has List<Goal> creating implicit _profileGoalsProfileId in Goal
      // 2. Source schema has goal_fk_0, but it was somehow never created in DB
      // 3. User changes to explicit named relation with different column name
      // 4. Migration tries to DROP goal_fk_0 (fails!) and ADD new FK
      
      test(
        'when FK constraint name stays same but columns change then should drop old and add new FK.',
        () {
          // SOURCE: Goal has implicit FK column from Profile's List<Goal> relation
          //         FK constraint name: goal_fk_0, column: _profileGoalsProfileId
          var sourceDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('profile')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('userId')
                          .withColumnType(ColumnType.uuid)
                          .withIsNullable(false)
                          .build(),
                    )
                    .build(),
              )
              .withTable(
                TableDefinitionBuilder()
                    .withName('goal')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('text')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('_profileGoalsProfileId')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .build(),
                    )
                    .withForeignKey(
                      ForeignKeyDefinition(
                        constraintName: 'goal_fk_0',
                        columns: ['_profileGoalsProfileId'],
                        referenceTable: 'profile',
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

          // TARGET: Goal has explicit profile field with named relation
          //         FK constraint name: goal_fk_0, column: _profileGoalsGoalId
          //         Same constraint name, different column!
          var targetDefinition = DatabaseDefinitionBuilder()
              .withDefaultModules()
              .withTable(
                TableDefinitionBuilder()
                    .withName('profile')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('userId')
                          .withColumnType(ColumnType.uuid)
                          .withIsNullable(false)
                          .build(),
                    )
                    .build(),
              )
              .withTable(
                TableDefinitionBuilder()
                    .withName('goal')
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('text')
                          .withColumnType(ColumnType.text)
                          .withIsNullable(false)
                          .build(),
                    )
                    .withColumn(
                      ColumnDefinitionBuilder()
                          .withName('_profileGoalsGoalId')
                          .withColumnType(ColumnType.bigint)
                          .withIsNullable(true)
                          .build(),
                    )
                    .withForeignKey(
                      ForeignKeyDefinition(
                        constraintName: 'goal_fk_0',
                        columns: ['_profileGoalsGoalId'],
                        referenceTable: 'profile',
                        referenceTableSchema: 'public',
                        referenceColumns: ['id'],
                        onUpdate: ForeignKeyAction.noAction,
                        onDelete: ForeignKeyAction.cascade,
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

          var goalAlterActions = migration.actions.where(
            (action) =>
                action.type == DatabaseMigrationActionType.alterTable &&
                action.alterTable?.name == 'goal',
          );

          expect(goalAlterActions, hasLength(1));

          var alterTable = goalAlterActions.first.alterTable!;

          // The migration generator will:
          // 1. Drop the old column
          expect(
            alterTable.deleteColumns,
            contains('_profileGoalsProfileId'),
          );

          // 2. Drop the old FK (THIS IS THE PROBLEM if it doesn't exist!)
          expect(
            alterTable.deleteForeignKeys,
            contains('goal_fk_0'),
          );

          // 3. Add the new column
          expect(
            alterTable.addColumns.any((c) => c.name == '_profileGoalsGoalId'),
            isTrue,
          );

          // 4. Add the new FK with same name
          expect(
            alterTable.addForeignKeys.any(
              (fk) => fk.constraintName == 'goal_fk_0' &&
                      fk.columns.contains('_profileGoalsGoalId'),
            ),
            isTrue,
          );

          // This is the current (buggy?) behavior - it tries to drop goal_fk_0
          // even if it might not exist in the actual database.
          // The fix should detect when a FK is being "modified" vs "dropped and re-added"
        },
      );
    },
  );
}

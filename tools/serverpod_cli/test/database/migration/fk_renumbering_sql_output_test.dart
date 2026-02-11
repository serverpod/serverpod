import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  test(
    'Given FK renumbering scenario when generating SQL then verify DROP CONSTRAINT is NOT generated when column is dropped',
    () {
      // SOURCE: goal_fk_0 on column _profileGoalsProfileId
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

      // TARGET: goal_fk_0 on column _profileGoalsGoalId (different column!)
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

      var sql = migration.toPgSql(
        installedModules: [],
        removedModules: [],
      );

      print('Generated SQL:');
      print(sql);

      // Verify the problematic DROP CONSTRAINT is NOT in the SQL
      // This is the fix - we should not drop the FK when its column is being dropped
      expect(
        sql,
        isNot(contains('ALTER TABLE "goal" DROP CONSTRAINT "goal_fk_0";')),
        reason: 'Should NOT generate DROP CONSTRAINT when column is being dropped',
      );

      expect(
        sql,
        contains('ALTER TABLE "goal" DROP COLUMN "_profileGoalsProfileId";'),
        reason: 'Should generate DROP COLUMN for the old column',
      );

      expect(
        sql,
        contains('ALTER TABLE "goal" ADD COLUMN "_profileGoalsGoalId" bigint;'),
        reason: 'Should generate ADD COLUMN for the new column',
      );

      // The FK should be added later (in the foreign key section)
      expect(
        sql,
        contains('ADD CONSTRAINT "goal_fk_0"'),
        reason: 'Should generate ADD CONSTRAINT for the new FK',
      );
    },
  );
}

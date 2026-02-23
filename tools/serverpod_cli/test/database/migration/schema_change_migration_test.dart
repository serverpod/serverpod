import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  group('Given a table with schema "public" in source', () {
    var tableName = 'example_table';

    group('when target has the same table with schema "custom_schema"', () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withSchema('public')
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withSchema('custom_schema')
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then a migration action is created.', () {
        expect(migration.actions, hasLength(1));
      });

      test(
        'then the database migration will alter the table.',
        () {
          var action = migration.actions.first;
          expect(action.type, DatabaseMigrationActionType.alterTable);
        },
        skip: migration.actions.length != 1,
      );

      test(
        'then the alter table property is set with newSchema.',
        () {
          var alterTable = migration.actions.first.alterTable;
          expect(alterTable, isNotNull);
          expect(alterTable!.name, tableName);
          expect(alterTable.schema, 'public');
          expect(alterTable.newSchema, 'custom_schema');
        },
        skip: migration.actions.length != 1,
      );

      test(
        'then a warning is generated about the schema change.',
        () {
          expect(migration.warnings, hasLength(1));
          expect(
            migration.warnings.first.message,
            contains('moved from schema "public" to schema "custom_schema"'),
          );
        },
        skip: migration.actions.length != 1,
      );

      test(
        'then the generated SQL contains ALTER TABLE SET SCHEMA statement.',
        () {
          var sql = migration.toPgSql(
            installedModules: [],
            removedModules: [],
          );
          expect(
            sql,
            contains(
              'ALTER TABLE "public"."$tableName" SET SCHEMA "custom_schema"',
            ),
          );
        },
        skip: migration.actions.length != 1,
      );
    });

    group('when target has the same table with the same schema', () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withSchema('public')
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withSchema('public')
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then no migration actions are created.', () {
        expect(migration.actions, isEmpty);
      });

      test('then no warnings are generated.', () {
        expect(migration.warnings, isEmpty);
      });
    });
  });

  group('Given a table with schema "schema_a" in source', () {
    var tableName = 'example_table';

    group('when target has the same table with schema "schema_b"', () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withSchema('schema_a')
                .build(),
          )
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(
            TableDefinitionBuilder()
                .withName(tableName)
                .withSchema('schema_b')
                .build(),
          )
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      test('then a migration action is created.', () {
        expect(migration.actions, hasLength(1));
      });

      test(
        'then the alter table has correct schema and newSchema values.',
        () {
          var alterTable = migration.actions.first.alterTable;
          expect(alterTable, isNotNull);
          expect(alterTable!.schema, 'schema_a');
          expect(alterTable.newSchema, 'schema_b');
        },
        skip: migration.actions.length != 1,
      );

      test(
        'then the generated SQL contains correct schema names.',
        () {
          var sql = migration.toPgSql(
            installedModules: [],
            removedModules: [],
          );
          expect(
            sql,
            contains(
              'ALTER TABLE "schema_a"."$tableName" SET SCHEMA "schema_b"',
            ),
          );
        },
        skip: migration.actions.length != 1,
      );
    });
  });

  group('Given a new table in target with custom schema', () {
    var tableName = 'new_table';
    var customSchema = 'custom_schema';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(
          TableDefinitionBuilder()
              .withName(tableName)
              .withSchema(customSchema)
              .build(),
        )
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    test('then a create table action is generated.', () {
      expect(migration.actions, hasLength(1));
      expect(
        migration.actions.first.type,
        DatabaseMigrationActionType.createTable,
      );
    });

    test('then the table has the correct schema.', () {
      var createTable = migration.actions.first.createTable;
      expect(createTable, isNotNull);
      expect(createTable!.schema, customSchema);
    });
  });
}

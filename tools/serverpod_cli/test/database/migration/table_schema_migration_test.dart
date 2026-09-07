import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  TableDefinition userTable({String schema = 'public'}) =>
      TableDefinitionBuilder().withName('user').withSchema(schema).build();

  ForeignKeyDefinition userReference({String schema = 'public'}) =>
      ForeignKeyDefinition(
        constraintName: 'post_fk_0',
        columns: ['userId'],
        referenceTable: 'user',
        referenceTableSchema: schema,
        referenceColumns: ['id'],
        onUpdate: ForeignKeyAction.noAction,
        onDelete: ForeignKeyAction.cascade,
      );

  TableDefinition postTable({required String referenceSchema}) =>
      TableDefinitionBuilder()
          .withName('post')
          .withColumn(
            ColumnDefinitionBuilder()
                .withName('userId')
                .withColumnType(ColumnType.bigint)
                .withIsNullable(false)
                .build(),
          )
          .withForeignKey(userReference(schema: referenceSchema))
          .build();

  DatabaseDefinition database(List<TableDefinition> tables) =>
      DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTables(tables)
          .build();

  group(
    'Given a target that adds a table with the same name as an existing table '
    'in another schema, when generating the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([userTable()]),
        databaseTarget: database([userTable(), userTable(schema: 'auth')]),
      );

      test('then only a create action is generated.', () {
        expect(
          migration.actions.map((a) => a.type),
          [DatabaseMigrationActionType.createTable],
        );
      });

      test('then the created table is in the new schema.', () {
        expect(migration.actions.single.createTable?.schema, 'auth');
      });

      test('then no warning is generated.', () {
        expect(migration.warnings, isEmpty);
      });
    },
  );

  group(
    'Given a table that only changes schema, when generating the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([userTable()]),
        databaseTarget: database([userTable(schema: 'auth')]),
      );

      test('then only an alter action is generated.', () {
        expect(
          migration.actions.map((a) => a.type),
          [DatabaseMigrationActionType.alterTable],
        );
      });

      test('then the alter action moves the table to the new schema.', () {
        var alterTable = migration.actions.single.alterTable!;
        expect(alterTable.name, 'user');
        expect(alterTable.schema, 'public');
        expect(alterTable.newSchema, 'auth');
      });

      test('then no warning is generated.', () {
        expect(migration.warnings, isEmpty);
      });
    },
  );

  group(
    'Given a table that changes schema and gains a nullable column, when '
    'generating the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([userTable(schema: 'auth')]),
        databaseTarget: database([
          TableDefinitionBuilder()
              .withName('user')
              .withSchema('core')
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName('email')
                    .withColumnType(ColumnType.text)
                    .withIsNullable(true)
                    .build(),
              )
              .build(),
        ]),
      );

      test(
        'then a single alter action moves the table and adds the column.',
        () {
          var alterTable = migration.actions.single.alterTable!;
          expect(alterTable.schema, 'auth');
          expect(alterTable.newSchema, 'core');
          expect(alterTable.addColumns.map((c) => c.name), ['email']);
        },
      );
    },
  );

  group(
    'Given a table whose name exists in two target schemas and neither '
    'matches the source, when generating the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([userTable()]),
        databaseTarget: database([
          userTable(schema: 'auth'),
          userTable(schema: 'core'),
        ]),
      );

      test('then the source table is dropped and both targets created.', () {
        expect(migration.actions.map((a) => a.type), [
          DatabaseMigrationActionType.deleteTable,
          DatabaseMigrationActionType.createTable,
          DatabaseMigrationActionType.createTable,
        ]);
      });

      test('then the delete action has no schema for the default schema.', () {
        var deleteAction = migration.actions.first;
        expect(deleteAction.deleteTable, 'user');
        expect(deleteAction.deleteTableSchema, isNull);
      });

      test('then the drop warning explains the ambiguity.', () {
        expect(migration.warnings, hasLength(1));
        expect(
          migration.warnings.single.message,
          'Table "user" will be dropped. Tables named "user" exist in several '
          'schemas, so it cannot be moved with SET SCHEMA.',
        );
      });
    },
  );

  group(
    'Given two source tables with the same name in different schemas and a '
    'single target with that name elsewhere, when generating the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([
          userTable(schema: 'auth'),
          userTable(schema: 'core'),
        ]),
        databaseTarget: database([userTable()]),
      );

      test('then both source tables are dropped and the target created.', () {
        expect(migration.actions.map((a) => a.type), [
          DatabaseMigrationActionType.deleteTable,
          DatabaseMigrationActionType.deleteTable,
          DatabaseMigrationActionType.createTable,
        ]);
      });

      test('then the delete actions carry their schemas.', () {
        expect(
          migration.actions
              .where((a) => a.deleteTable != null)
              .map((a) => a.deleteTableSchema),
          unorderedEquals(['auth', 'core']),
        );
      });

      test('then both drop warnings explain the ambiguity.', () {
        expect(
          migration.warnings.map((w) => w.table),
          unorderedEquals(['auth.user', 'core.user']),
        );
        expect(
          migration.warnings.map((w) => w.message),
          everyElement(contains('cannot be moved with SET SCHEMA')),
        );
      });
    },
  );

  group(
    'Given a table in a non-default schema that is removed, when generating '
    'the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([userTable(schema: 'auth')]),
        databaseTarget: database([]),
      );

      test('then the delete action carries the schema.', () {
        var deleteAction = migration.actions.single;
        expect(deleteAction.type, DatabaseMigrationActionType.deleteTable);
        expect(deleteAction.deleteTable, 'user');
        expect(deleteAction.deleteTableSchema, 'auth');
      });

      test('then the warning names the qualified table.', () {
        expect(migration.warnings.single.table, 'auth.user');
        expect(
          migration.warnings.single.message,
          'Table "auth.user" will be dropped.',
        );
      });
    },
  );

  group(
    'Given a dependent table referencing one of two same-named tables and '
    'the other one is removed, when generating the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([
          userTable(schema: 'auth'),
          userTable(schema: 'app'),
          postTable(referenceSchema: 'app'),
        ]),
        databaseTarget: database([
          userTable(schema: 'app'),
          postTable(referenceSchema: 'app'),
        ]),
      );

      test('then only the removed table is dropped.', () {
        expect(migration.actions, hasLength(1));
        var deleteAction = migration.actions.single;
        expect(deleteAction.deleteTable, 'user');
        expect(deleteAction.deleteTableSchema, 'auth');
      });
    },
  );

  group(
    'Given a dependent table referencing a table in a schema that is '
    'removed while the reference is kept, when generating the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([
          userTable(schema: 'auth'),
          postTable(referenceSchema: 'auth'),
        ]),
        databaseTarget: database([postTable(referenceSchema: 'auth')]),
      );

      test(
        'then the dependent table is dropped before the referenced one.',
        () {
          expect(
            migration.actions
                .where((a) => a.deleteTable != null)
                .map((a) => '${a.deleteTableSchema}.${a.deleteTable}'),
            ['null.post', 'auth.user'],
          );
        },
      );

      test('then the dependent table is recreated.', () {
        expect(migration.actions.last.createTable?.name, 'post');
      });
    },
  );

  group(
    'Given a table that moves to another schema and a dependent table whose '
    'reference follows it, when generating the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([
          userTable(),
          postTable(referenceSchema: 'public'),
        ]),
        databaseTarget: database([
          userTable(schema: 'auth'),
          postTable(referenceSchema: 'auth'),
        ]),
      );

      test('then only the moved table is altered.', () {
        expect(migration.actions, hasLength(1));
        var alterTable = migration.actions.single.alterTable!;
        expect(alterTable.name, 'user');
        expect(alterTable.newSchema, 'auth');
      });
    },
  );

  group(
    'Given a table that moves to another schema and gains a column that '
    'cannot be added in place, when generating the migration',
    () {
      var migration = generateDatabaseMigration(
        databaseSource: database([userTable()]),
        databaseTarget: database([
          TableDefinitionBuilder()
              .withName('user')
              .withSchema('auth')
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName('email')
                    .withColumnType(ColumnType.text)
                    .withIsNullable(false)
                    .build(),
              )
              .build(),
        ]),
      );

      test('then the table is dropped from the source schema.', () {
        var deleteAction = migration.actions.first;
        expect(deleteAction.type, DatabaseMigrationActionType.deleteTable);
        expect(deleteAction.deleteTable, 'user');
        expect(deleteAction.deleteTableSchema, isNull);
      });

      test('then the table is created in the target schema.', () {
        var createAction = migration.actions.last;
        expect(createAction.type, DatabaseMigrationActionType.createTable);
        expect(createAction.createTable?.schema, 'auth');
      });
    },
  );
}

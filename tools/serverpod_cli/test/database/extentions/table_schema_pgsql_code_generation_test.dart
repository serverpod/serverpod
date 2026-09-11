import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/index_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  TableDefinition userTable({String schema = 'public'}) =>
      TableDefinitionBuilder().withName('user').withSchema(schema).build();

  TableDefinition postTable({
    required String schema,
    required String referenceSchema,
  }) => TableDefinitionBuilder()
      .withName('post')
      .withSchema(schema)
      .withColumn(
        ColumnDefinitionBuilder()
            .withName('userId')
            .withColumnType(ColumnType.bigint)
            .withIsNullable(false)
            .build(),
      )
      .withIndex(
        IndexDefinitionBuilder().withIndexName('post_user_idx').withElements([
          IndexElementDefinition(
            type: IndexElementDefinitionType.column,
            definition: 'userId',
          ),
        ]).build(),
      )
      .withForeignKey(
        ForeignKeyDefinition(
          constraintName: 'post_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: referenceSchema,
          referenceColumns: ['id'],
          onUpdate: ForeignKeyAction.noAction,
          onDelete: ForeignKeyAction.cascade,
        ),
      )
      .build();

  DatabaseDefinition database(List<TableDefinition> tables) =>
      DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTables(tables)
          .build();

  String migrationSql(DatabaseDefinition source, DatabaseDefinition target) {
    var migration = generateDatabaseMigration(
      databaseSource: source,
      databaseTarget: target,
    );
    return migration.toPgSql(
      databaseDefinition: target,
      installedModules: [],
      removedModules: [],
    );
  }

  group(
    'Given a definition with a table in another schema referencing a public '
    'table, when generating the definition sql',
    () {
      var sql = database([
        userTable(),
        postTable(schema: 'blog', referenceSchema: 'public'),
      ]).toPgSql(installedModules: []);

      test('then the schema is created before the tables.', () {
        expect(sql, contains('CREATE SCHEMA IF NOT EXISTS "blog";'));
        expect(
          sql.indexOf('CREATE SCHEMA IF NOT EXISTS "blog";'),
          lessThan(sql.indexOf('CREATE TABLE')),
        );
      });

      test('then the table is created with a qualified name.', () {
        expect(sql, contains('CREATE TABLE "blog"."post" ('));
      });

      test('then the index is created on the qualified table.', () {
        expect(
          sql,
          contains('CREATE INDEX "post_user_idx" ON "blog"."post"'),
        );
      });

      test('then the foreign key qualifies the table and the reference.', () {
        expect(sql, contains('ALTER TABLE ONLY "blog"."post"'));
        expect(sql, contains('REFERENCES "user"("id")'));
      });

      test('then the public table keeps unqualified identifiers.', () {
        expect(sql, contains('CREATE TABLE "user" ('));
      });
    },
  );

  test(
    'Given a definition with only public tables when generating the '
    'definition sql then no schema is created.',
    () {
      var sql = database([userTable()]).toPgSql(installedModules: []);

      expect(sql, isNot(contains('CREATE SCHEMA')));
    },
  );

  group(
    'Given a migration creating a table in a new schema that references a '
    'table in another schema, when generating the migration sql',
    () {
      var sql = migrationSql(
        database([userTable(schema: 'auth')]),
        database([
          userTable(schema: 'auth'),
          postTable(schema: 'blog', referenceSchema: 'auth'),
        ]),
      );

      test('then the schema is created before the table.', () {
        expect(
          sql.indexOf('CREATE SCHEMA IF NOT EXISTS "blog";'),
          lessThan(sql.indexOf('CREATE TABLE "blog"."post" (')),
        );
      });

      test('then the foreign key references the qualified table.', () {
        expect(sql, contains('REFERENCES "auth"."user"("id")'));
      });
    },
  );

  group(
    'Given a migration moving a table to another schema and adding a '
    'column, when generating the migration sql',
    () {
      var sql = migrationSql(
        database([userTable()]),
        database([
          TableDefinitionBuilder()
              .withName('user')
              .withSchema('auth')
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

      test('then the new schema is created.', () {
        expect(sql, contains('CREATE SCHEMA IF NOT EXISTS "auth";'));
      });

      test('then the table is moved with SET SCHEMA.', () {
        expect(sql, contains('ALTER TABLE "user" SET SCHEMA "auth";'));
      });

      test('then the column is added to the moved table.', () {
        var moveIndex = sql.indexOf('SET SCHEMA "auth"');
        var addIndex = sql.indexOf(
          'ALTER TABLE "auth"."user" ADD COLUMN "email" text;',
        );
        expect(addIndex, greaterThan(moveIndex));
      });
    },
  );

  group(
    'Given a migration dropping a table and an index in another schema, '
    'when generating the migration sql',
    () {
      var sql = migrationSql(
        database([
          userTable(schema: 'auth'),
          postTable(schema: 'blog', referenceSchema: 'auth'),
        ]),
        database([
          TableDefinitionBuilder()
              .withName('post')
              .withSchema('blog')
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName('userId')
                    .withColumnType(ColumnType.bigint)
                    .withIsNullable(false)
                    .build(),
              )
              .build(),
        ]),
      );

      test('then the dropped table is qualified.', () {
        expect(sql, contains('DROP TABLE "auth"."user" CASCADE;'));
      });

      test('then the dropped index is qualified.', () {
        expect(sql, contains('DROP INDEX "blog"."post_user_idx";'));
      });

      test('then the dropped constraint addresses the qualified table.', () {
        expect(
          sql,
          contains(
            'ALTER TABLE "blog"."post" DROP CONSTRAINT IF EXISTS "post_fk_0";',
          ),
        );
      });
    },
  );

  test(
    'Given a migration recreating a table in another schema that another '
    'table references, when generating the migration sql, then the inbound '
    'foreign key is restored on the qualified table.',
    () {
      var sql = migrationSql(
        database([
          userTable(schema: 'auth'),
          postTable(schema: 'blog', referenceSchema: 'auth'),
        ]),
        database([
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
          postTable(schema: 'blog', referenceSchema: 'auth'),
        ]),
      );

      expect(sql, contains('-- ACTION RESTORE FOREIGN KEY'));
      expect(sql, contains('ALTER TABLE ONLY "blog"."post"'));
      expect(sql, contains('REFERENCES "auth"."user"("id")'));
    },
  );
}

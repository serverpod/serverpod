import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  TableDefinition userTable(String schema) =>
      TableDefinitionBuilder().withName('user').withSchema(schema).build();

  TableDefinition postTable(String schema) => TableDefinitionBuilder()
      .withName('post')
      .withSchema(schema)
      .withColumn(
        ColumnDefinitionBuilder()
            .withName('userId')
            .withColumnType(ColumnType.bigint)
            .withIsNullable(false)
            .build(),
      )
      .withForeignKey(
        ForeignKeyDefinition(
          constraintName: 'post_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: schema,
          referenceColumns: ['id'],
          onUpdate: ForeignKeyAction.noAction,
          onDelete: ForeignKeyAction.cascade,
        ),
      )
      .build();

  DatabaseDefinition database(String schema) => DatabaseDefinitionBuilder()
      .withDefaultModules()
      .withTables([userTable(schema), postTable(schema)])
      .build();

  group(
    'Given a live definition reported in the sqlite "main" schema, when '
    'placing it in the default schema',
    () {
      var normalized = database('main').inDefaultSchema();

      test('then every table is in the public schema.', () {
        expect(normalized.tables.map((t) => t.schema), everyElement('public'));
      });

      test('then every foreign key references the public schema.', () {
        var foreignKey = normalized.tables
            .singleWhere((t) => t.name == 'post')
            .foreignKeys
            .single;
        expect(foreignKey.referenceTableSchema, 'public');
      });

      test('then it matches the same tables defined in the public schema.', () {
        var migration = generateDatabaseMigration(
          databaseSource: normalized,
          databaseTarget: database('public'),
        );
        expect(migration.actions, isEmpty);
      });
    },
  );
}

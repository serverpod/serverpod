import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

/// Builds the "parent_entity" table. Adding [withRequiredColumn] makes the
/// table impossible to migrate in place, forcing a delete and recreate.
TableDefinition _parentEntity({bool withRequiredColumn = false}) {
  var builder = TableDefinitionBuilder().withName('parent_entity');

  if (withRequiredColumn) {
    builder.withColumn(
      ColumnDefinitionBuilder()
          .withName('requiredValue')
          .withColumnType(ColumnType.text)
          .withIsNullable(false)
          .build(),
    );
  }

  return builder.build();
}

/// Builds the "child_entity" table, holding a foreign key into
/// "parent_entity".
TableDefinition _childEntity({
  ForeignKeyAction onDelete = ForeignKeyAction.cascade,
  bool withRequiredColumn = false,
  bool managed = true,
}) {
  var builder = TableDefinitionBuilder()
      .withName('child_entity')
      .withManaged(managed)
      .withColumn(
        ColumnDefinitionBuilder()
            .withName('parentEntityId')
            .withColumnType(ColumnType.bigint)
            .withIsNullable(true)
            .build(),
      )
      .withForeignKey(
        ForeignKeyDefinition(
          constraintName: 'child_entity_fk_0',
          columns: ['parentEntityId'],
          referenceTable: 'parent_entity',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: ForeignKeyAction.noAction,
          onDelete: onDelete,
          matchType: null,
        ),
      );

  if (withRequiredColumn) {
    builder.withColumn(
      ColumnDefinitionBuilder()
          .withName('requiredValue')
          .withColumnType(ColumnType.text)
          .withIsNullable(false)
          .build(),
    );
  }

  return builder.build();
}

String _generatePgSql({
  required DatabaseDefinition source,
  required DatabaseDefinition target,
}) {
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

void main() {
  group(
    'Given a table referenced by a foreign key from another table, '
    'when the referenced table is deleted and recreated by the migration,',
    () {
      var psql = _generatePgSql(
        source: DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(_parentEntity())
            .withTable(_childEntity())
            .build(),
        target: DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(_parentEntity(withRequiredColumn: true))
            .withTable(_childEntity())
            .build(),
      );

      test(
        'then the foreign key of the referencing table is added back.',
        () {
          expect(
            psql,
            contains(
              'ALTER TABLE ONLY "child_entity"\n'
              '    ADD CONSTRAINT "child_entity_fk_0"\n'
              '    FOREIGN KEY("parentEntityId")\n'
              '    REFERENCES "parent_entity"("id")\n'
              '    ON DELETE CASCADE\n'
              '    ON UPDATE NO ACTION;\n',
            ),
            reason:
                'DROP TABLE CASCADE also drops the foreign keys that other '
                'tables have into the recreated table.',
          );
        },
      );

      test(
        'then the foreign key of the referencing table is added back after the referenced table is recreated.',
        () {
          var createTableIndex = psql.indexOf('CREATE TABLE "parent_entity"');
          var addConstraintIndex = psql.indexOf(
            'ADD CONSTRAINT "child_entity_fk_0"',
          );

          expect(createTableIndex, greaterThanOrEqualTo(0));
          expect(addConstraintIndex, greaterThan(createTableIndex));
        },
      );

      test('then the foreign key is added back only once.', () {
        expect(
          'ADD CONSTRAINT "child_entity_fk_0"'.allMatches(psql).length,
          1,
        );
      });
    },
  );

  group(
    'Given a table referenced by a foreign key that is modified by the same migration, '
    'when the referenced table is deleted and recreated,',
    () {
      var psql = _generatePgSql(
        source: DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(_parentEntity())
            .withTable(_childEntity(onDelete: ForeignKeyAction.noAction))
            .build(),
        target: DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(_parentEntity(withRequiredColumn: true))
            .withTable(_childEntity(onDelete: ForeignKeyAction.cascade))
            .build(),
      );

      test(
        'then the foreign key is added only once, with the modified delete action.',
        () {
          expect(
            'ADD CONSTRAINT "child_entity_fk_0"'.allMatches(psql).length,
            1,
          );
          expect(
            psql,
            contains(
              'ALTER TABLE ONLY "child_entity"\n'
              '    ADD CONSTRAINT "child_entity_fk_0"\n'
              '    FOREIGN KEY("parentEntityId")\n'
              '    REFERENCES "parent_entity"("id")\n'
              '    ON DELETE CASCADE\n'
              '    ON UPDATE NO ACTION;\n',
            ),
          );
        },
      );
    },
  );

  group(
    'Given two tables with a foreign key relation that both have to be deleted and recreated, '
    'when the migration is generated,',
    () {
      var psql = _generatePgSql(
        source: DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(_parentEntity())
            .withTable(_childEntity())
            .build(),
        target: DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(_parentEntity(withRequiredColumn: true))
            .withTable(_childEntity(withRequiredColumn: true))
            .build(),
      );

      test(
        'then the foreign key is added only once.',
        () {
          expect(
            'ADD CONSTRAINT "child_entity_fk_0"'.allMatches(psql).length,
            1,
          );
        },
      );
    },
  );

  group(
    'Given an unmanaged table with a foreign key into a managed table, '
    'when the referenced table is deleted and recreated,',
    () {
      var psql = _generatePgSql(
        source: DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(_parentEntity())
            .withTable(_childEntity(managed: false))
            .build(),
        target: DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(_parentEntity(withRequiredColumn: true))
            .withTable(_childEntity(managed: false))
            .build(),
      );

      test(
        'then the foreign key of the unmanaged table is not added back.',
        () {
          expect(
            psql,
            isNot(contains('child_entity_fk_0')),
            reason:
                'Unmanaged tables are not part of the schema Serverpod '
                'creates, so the migration must not write to them.',
          );
        },
      );
    },
  );

  group(
    'Given a table referenced by a foreign key from another table, '
    'when the referenced table is deleted without being recreated,',
    () {
      var psql = _generatePgSql(
        source: DatabaseDefinitionBuilder()
            .withDefaultModules()
            .withTable(_parentEntity())
            .withTable(_childEntity())
            .build(),
        target: DatabaseDefinitionBuilder().withDefaultModules().build(),
      );

      test(
        'then no foreign key into the deleted table is added back.',
        () {
          expect(psql, isNot(contains('ADD CONSTRAINT "child_entity_fk_0"')));
        },
      );
    },
  );
}

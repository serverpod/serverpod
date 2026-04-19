import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/index_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';
import '../../test_util/builders/model_class_definition_builder.dart';

List<DatabaseMigrationVersionModel> _sqliteModules(DatabaseDefinition def) =>
    def.installedModules.isNotEmpty
    ? def.installedModules
    : [
        DatabaseMigrationVersionModel(
          module: def.moduleName,
          version: '00000000000000',
        ),
      ];

void main() {
  group('Given classes with a circular relation when generating migration, '
      'when generating SQL for SQLite, ', () {
    var citizen = 'citizen';
    var company = 'company';
    var town = 'town';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(citizen.sentenceCase)
          .withFileName(citizen)
          .withTableName(citizen)
          .withSimpleField('name', 'String')
          .withObjectRelationField(company, company.sentenceCase, company)
          .build(),
      ModelClassDefinitionBuilder()
          .withClassName(company.sentenceCase)
          .withFileName(company)
          .withTableName(company)
          .withSimpleField('name', 'String')
          .withObjectRelationField(town, town.sentenceCase, town)
          .build(),
      ModelClassDefinitionBuilder()
          .withClassName(town.sentenceCase)
          .withFileName(town)
          .withTableName(town)
          .withSimpleField('name', 'String')
          .withObjectRelationField('mayor', citizen.sentenceCase, citizen)
          .build(),
    ];

    var databaseDefinition = createDatabaseDefinitionFromModels(
      models,
      'example',
      [],
    );

    test('then all definitions are created.', () {
      expect(databaseDefinition.tables, hasLength(3));
    });

    group(
      'then SQLite file for migration',
      () {
        var sqliteFile = databaseDefinition.toSqliteSql(
          installedModules: _sqliteModules(databaseDefinition),
        );

        test(
          'has inline foreign key from citizen to company in CREATE TABLE.',
          () {
            expect(
              sqliteFile,
              contains(
                'CONSTRAINT "citizen_fk_0" FOREIGN KEY ("companyId") '
                'REFERENCES "company"',
              ),
            );
          },
        );

        test(
          'has inline foreign key from company to town in CREATE TABLE.',
          () {
            expect(
              sqliteFile,
              contains(
                'CONSTRAINT "company_fk_0" FOREIGN KEY ("townId") '
                'REFERENCES "town"',
              ),
            );
          },
        );

        test(
          'has inline foreign key from town to citizen in CREATE TABLE.',
          () {
            expect(
              sqliteFile,
              contains(
                'CONSTRAINT "town_fk_0" FOREIGN KEY ("mayorId") '
                'REFERENCES "citizen"',
              ),
            );
          },
        );

        test(
          'does not emit separate ALTER TABLE ADD CONSTRAINT for these FKs.',
          () {
            expect(sqliteFile, isNot(contains('ALTER TABLE ONLY')));
          },
        );
      },
      skip: databaseDefinition.tables.length != 3
          ? 'Unexpected number of tables were created'
          : false,
    );
  });

  test(
    'Given a database definition with only an un-managed table, '
    'when generating SQL for SQLite, '
    'then no sql definition for that table is created.',
    () {
      var databaseDefinition = DatabaseDefinitionBuilder()
          .withTable(
            TableDefinitionBuilder()
                .withName('example_table')
                .withManaged(false)
                .build(),
          )
          .build();

      var sqlite = databaseDefinition.toSqliteSql(
        installedModules: _sqliteModules(databaseDefinition),
      );

      expect(sqlite, isNot(contains('CREATE TABLE "example_table"')));
    },
  );

  test(
    'Given a database definition with UUIDv7 as id type in one of the tables, '
    'when generating SQL for SQLite, '
    'then SQLite uses inline BLOB default for the id column.',
    () {
      var citizen = 'citizen';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(citizen.sentenceCase)
            .withFileName(citizen)
            .withTableName(citizen)
            .withIdFieldType(SupportedIdType.uuidV7, nullable: false)
            .withSimpleField('name', 'String')
            .build(),
      ];

      var databaseDefinition = createDatabaseDefinitionFromModels(
        models,
        'example',
        [],
      );
      var sqlite = databaseDefinition.toSqliteSql(
        installedModules: _sqliteModules(databaseDefinition),
      );

      expect(sqlite, contains('"id" BLOB PRIMARY KEY DEFAULT'));
    },
  );

  group('Given a table definition with a vector field', () {
    var modelName = 'vectorModel';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(modelName.sentenceCase)
          .withFileName(modelName)
          .withTableName(modelName)
          .withVectorField('embedding', dimension: 1536)
          .build(),
    ];

    var databaseDefinition = createDatabaseDefinitionFromModels(
      models,
      'example',
      [],
    );
    var tableDefinition = databaseDefinition.tables.first;

    test(
      'when defining an HNSW index, then SQLite omits non-btree index SQL.',
      () {
        var indexName = '${modelName}_embedding_hnsw_idx';
        var index = IndexDefinitionBuilder()
            .withIndexName(indexName)
            .withElements([
              IndexElementDefinition(
                type: IndexElementDefinitionType.column,
                definition: 'embedding',
              ),
            ])
            .withType('hnsw')
            .withIsUnique(false)
            .withIsPrimary(false)
            .withVectorColumnType(ColumnType.vector)
            .build();

        var sql = index.toSql(tableName: tableDefinition.name);

        expect(sql, '');
      },
    );
  });
}

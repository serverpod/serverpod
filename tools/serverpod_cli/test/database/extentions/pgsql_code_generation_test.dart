import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/index_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';
import '../../test_util/builders/model_class_definition_builder.dart';

void main() {
  group('Given classes with a circular relation when generating migration', () {
    /**
     * Citizen -> Company -> Town -> Citizen
     */
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
          .build()
    ];

    var databaseDefinition = createDatabaseDefinitionFromModels(
      models,
      'example',
      [],
    );

    test('then all definitions are created.', () {
      expect(databaseDefinition.tables, hasLength(3));
    });

    group('then pgsql file for migration', () {
      var pgsqlFile = databaseDefinition.toPgSql(installedModules: []);
      test(
          'has foreign key creation for citizen after company table is created.',
          () {
        var createCompanyIndex = pgsqlFile.indexOf('CREATE TABLE "company"');
        var createForeignKeyForCitizenIndex = pgsqlFile.indexOf('''
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "company"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
''');

        expect(createCompanyIndex, isNot(-1));
        expect(createCompanyIndex, lessThan(createForeignKeyForCitizenIndex));
      });

      test('has foreign key creation for company after town table is created.',
          () {
        var createCompanyIndex = pgsqlFile.indexOf('CREATE TABLE "town"');
        var createForeignKeyForCitizenIndex = pgsqlFile.indexOf('''
ALTER TABLE ONLY "company"
    ADD CONSTRAINT "company_fk_0"
    FOREIGN KEY("townId")
    REFERENCES "town"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
''');

        expect(createCompanyIndex, isNot(-1));
        expect(createCompanyIndex, lessThan(createForeignKeyForCitizenIndex));
      });

      test('has foreign key creation for town after citizen table is created.',
          () {
        var createCompanyIndex = pgsqlFile.indexOf('CREATE TABLE "citizen"');
        var createForeignKeyForCitizenIndex = pgsqlFile.indexOf('''
ALTER TABLE ONLY "town"
    ADD CONSTRAINT "town_fk_0"
    FOREIGN KEY("mayorId")
    REFERENCES "citizen"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
''');

        expect(createCompanyIndex, isNot(-1));
        expect(createCompanyIndex, lessThan(createForeignKeyForCitizenIndex));
      });
    },
        skip: databaseDefinition.tables.length != 3
            ? 'Unexpected number of tables were created'
            : false);
  });

  test(
      'Given a database definition with only an un-managed table then no sql definition for that table is created.',
      () {
    var databaseDefinition = DatabaseDefinitionBuilder()
        .withTable(TableDefinitionBuilder()
            .withName('example_table')
            .withManaged(false)
            .build())
        .build();

    var pgsql = databaseDefinition.toPgSql(installedModules: []);

    expect(pgsql, isNot(contains('CREATE TABLE "example_table"')));
  });

  test(
      'Given a database definition with no UUIDv7 default in any of the tables, then code for generating random UUIDv7 is not added.',
      () {
    var databaseDefinition = DatabaseDefinitionBuilder().build();
    var pgsql = databaseDefinition.toPgSql(installedModules: []);

    expect(
      pgsql,
      isNot(contains('create or replace function gen_random_uuid_v7()')),
    );
  });

  test(
      'Given a database definition with UUIDv7 default value in one of the tables, then the code for generating random UUIDv7 is added.',
      () {
    var citizen = 'citizen';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(citizen.sentenceCase)
          .withFileName(citizen)
          .withTableName(citizen)
          .withSimpleField(
            'uuid',
            'UuidValue',
            defaultPersistValue: defaultUuidValueRandomV7,
          )
          .build(),
    ];

    var databaseDefinition = createDatabaseDefinitionFromModels(
      models,
      'example',
      [],
    );
    var pgsql = databaseDefinition.toPgSql(installedModules: []);

    expect(
      pgsql,
      contains('create or replace function gen_random_uuid_v7()\nreturns uuid'),
    );
  });

  test(
      'Given a database definition with UUIDv7 as id type in one of the tables, then the code for generating random UUIDv7 is added.',
      () {
    var citizen = 'citizen';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(citizen.sentenceCase)
          .withFileName(citizen)
          .withTableName(citizen)
          .withIdFieldType(SupportedIdType.uuidV7, nullable: false)
          .build(),
    ];

    var databaseDefinition = createDatabaseDefinitionFromModels(
      models,
      'example',
      [],
    );
    var pgsql = databaseDefinition.toPgSql(installedModules: []);

    expect(
      pgsql,
      contains('create or replace function gen_random_uuid_v7()\nreturns uuid'),
    );
  });

  const createVectorExtension = '''
DO \$\$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'vector') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS vector';
  ELSE
    RAISE EXCEPTION 'Required extension "vector" is not available on this instance. Please install pgvector. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-pgvector.';
  END IF;
END
\$\$;
''';

  test(
      'Given a database definition with no Vector field in any of the tables, then code for creating vector extension is not generated.',
      () {
    var databaseDefinition = DatabaseDefinitionBuilder().build();
    var pgsql = databaseDefinition.toPgSql(installedModules: []);

    expect(pgsql, isNot(contains(createVectorExtension)));
  });

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

    var databaseDefinition =
        createDatabaseDefinitionFromModels(models, 'example', []);
    var tableDefinition = databaseDefinition.tables.first;

    test('then code for creating vector extension is generated.', () {
      var pgsql = databaseDefinition.toPgSql(installedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'when defining an HNSW index with no custom parameters, then the SQL should have no parameters.',
        () {
      var indexName = '${modelName}_embedding_hnsw_idx';
      var index = IndexDefinitionBuilder()
          .withIndexName(indexName)
          .withElements([
            IndexElementDefinition(
              type: IndexElementDefinitionType.column,
              definition: 'embedding',
            )
          ])
          .withType('hnsw')
          .withIsUnique(false)
          .withIsPrimary(false)
          .withVectorColumnType(ColumnType.vector)
          .build();

      var sql = index.toPgSql(tableName: tableDefinition.name);

      expect(
        sql,
        'CREATE INDEX "$indexName" ON "${tableDefinition.name}" '
        'USING hnsw ("embedding" vector_l2_ops);\n',
      );
    });

    test(
        'when defining an IVFFlat index with custom parameters, then the SQL should have no parameters.',
        () {
      var indexName = '${modelName}_embedding_ivfflat_idx';
      var index = IndexDefinitionBuilder()
          .withIndexName(indexName)
          .withElements([
            IndexElementDefinition(
              type: IndexElementDefinitionType.column,
              definition: 'embedding',
            )
          ])
          .withType('ivfflat')
          .withIsUnique(false)
          .withIsPrimary(false)
          .withVectorColumnType(ColumnType.vector)
          .build();

      var sql = index.toPgSql(tableName: tableDefinition.name);

      expect(
        sql,
        'CREATE INDEX "$indexName" ON "${tableDefinition.name}" '
        'USING ivfflat ("embedding" vector_l2_ops);\n',
      );
    });

    test(
        'Given a table definition with an HNSW index with custom parameters on a vector field, then the SQL should include the correct HNSW parameters.',
        () {
      var indexName = '${modelName}_embedding_hnsw_idx';
      var index = IndexDefinitionBuilder()
          .withIndexName(indexName)
          .withElements([
            IndexElementDefinition(
              type: IndexElementDefinitionType.column,
              definition: 'embedding',
            )
          ])
          .withType('hnsw')
          .withIsUnique(false)
          .withIsPrimary(false)
          .withVectorDistanceFunction(VectorDistanceFunction.cosine)
          .withVectorColumnType(ColumnType.vector)
          .withParameters({'m': '16', 'ef_construction': '128'})
          .build();

      var sql = index.toPgSql(tableName: tableDefinition.name);

      expect(
        sql,
        'CREATE INDEX "$indexName" ON "${tableDefinition.name}" '
        'USING hnsw ("embedding" vector_cosine_ops) WITH (m=16, ef_construction=128);\n',
      );
    });

    test(
        'Given a table definition with an IVFFlat index with custom parameters on a vector field, then the SQL should include the correct IVFFlat parameters.',
        () {
      var indexName = '${modelName}_embedding_ivfflat_idx';
      var index = IndexDefinitionBuilder()
          .withIndexName(indexName)
          .withElements([
            IndexElementDefinition(
              type: IndexElementDefinitionType.column,
              definition: 'embedding',
            )
          ])
          .withType('ivfflat')
          .withIsUnique(false)
          .withIsPrimary(false)
          .withVectorDistanceFunction(VectorDistanceFunction.innerProduct)
          .withVectorColumnType(ColumnType.vector)
          .withParameters({'lists': '100'})
          .build();

      var sql = index.toPgSql(tableName: tableDefinition.name);

      expect(
        sql,
        'CREATE INDEX "$indexName" ON "${tableDefinition.name}" '
        'USING ivfflat ("embedding" vector_ip_ops) WITH (lists=100);\n',
      );
    });

    test(
        'when creating vector indexes with different distances, then they should generate SQL with correct ops parameters.',
        () {
      var distanceFunctions = {
        VectorDistanceFunction.l2: 'vector_l2_ops',
        VectorDistanceFunction.innerProduct: 'vector_ip_ops',
        VectorDistanceFunction.cosine: 'vector_cosine_ops',
        VectorDistanceFunction.l1: 'vector_l1_ops',
      };

      for (var entry in distanceFunctions.entries) {
        var distance = entry.key;
        var expectedOps = entry.value;
        var indexName = '${modelName}_embedding_idx_$distance';

        var index = IndexDefinitionBuilder()
            .withIndexName(indexName)
            .withElements([
              IndexElementDefinition(
                type: IndexElementDefinitionType.column,
                definition: 'embedding',
              )
            ])
            .withType('hnsw')
            .withIsUnique(false)
            .withIsPrimary(false)
            .withVectorDistanceFunction(distance)
            .withVectorColumnType(ColumnType.vector)
            .build();

        var sql = index.toPgSql(tableName: tableDefinition.name);

        expect(
          sql,
          'CREATE INDEX "$indexName" ON "${tableDefinition.name}" '
          'USING hnsw ("embedding" $expectedOps);\n',
        );
      }
    });

    test(
        'when defining a BTREE index on a vector field, then the SQL should not include any vector distance ops.',
        () {
      var indexName = '${modelName}_embedding_btree_idx';
      var index = IndexDefinitionBuilder()
          .withIndexName(indexName)
          .withElements([
            IndexElementDefinition(
              type: IndexElementDefinitionType.column,
              definition: 'embedding',
            )
          ])
          .withType('btree')
          .withIsUnique(false)
          .withIsPrimary(false)
          .build();

      var sql = index.toPgSql(tableName: tableDefinition.name);

      expect(
        sql,
        'CREATE INDEX "$indexName" ON "${tableDefinition.name}" '
        'USING btree ("embedding");\n',
      );
    });
  });

  group('Given a table definition with a half vector field', () {
    var modelName = 'halfVectorModel';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(modelName.sentenceCase)
          .withFileName(modelName)
          .withTableName(modelName)
          .withVectorField('embedding',
              dimension: 1536, vectorType: 'HalfVector')
          .build(),
    ];

    var databaseDefinition =
        createDatabaseDefinitionFromModels(models, 'example', []);
    var tableDefinition = databaseDefinition.tables.first;

    test('then code for creating vector extension is generated.', () {
      var pgsql = databaseDefinition.toPgSql(installedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'when creating half vector indexes with different distances, then they should generate SQL with correct ops parameters.',
        () {
      var distanceFunctions = {
        VectorDistanceFunction.l2: 'halfvec_l2_ops',
        VectorDistanceFunction.innerProduct: 'halfvec_ip_ops',
        VectorDistanceFunction.cosine: 'halfvec_cosine_ops',
        VectorDistanceFunction.l1: 'halfvec_l1_ops',
      };

      for (var entry in distanceFunctions.entries) {
        var distance = entry.key;
        var expectedOps = entry.value;
        var indexName = '${modelName}_embedding_idx_$distance';

        var index = IndexDefinitionBuilder()
            .withIndexName(indexName)
            .withElements([
              IndexElementDefinition(
                type: IndexElementDefinitionType.column,
                definition: 'embedding',
              )
            ])
            .withType('hnsw')
            .withIsUnique(false)
            .withIsPrimary(false)
            .withVectorDistanceFunction(distance)
            .withVectorColumnType(ColumnType.halfvec)
            .build();

        var sql = index.toPgSql(tableName: tableDefinition.name);

        expect(
          sql,
          'CREATE INDEX "$indexName" ON "${tableDefinition.name}" '
          'USING hnsw ("embedding" $expectedOps);\n',
        );
      }
    });
  });

  group('Given a table definition with a sparse vector field', () {
    var modelName = 'sparseVectorModel';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(modelName.sentenceCase)
          .withFileName(modelName)
          .withTableName(modelName)
          .withVectorField('embedding',
              dimension: 1536, vectorType: 'SparseVector')
          .build(),
    ];

    var databaseDefinition =
        createDatabaseDefinitionFromModels(models, 'example', []);
    var tableDefinition = databaseDefinition.tables.first;

    test('then code for creating vector extension is generated.', () {
      var pgsql = databaseDefinition.toPgSql(installedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'when creating sparse vector indexes with different distances, then they should generate SQL with correct ops parameters.',
        () {
      var distanceFunctions = {
        VectorDistanceFunction.l2: 'sparsevec_l2_ops',
        VectorDistanceFunction.innerProduct: 'sparsevec_ip_ops',
        VectorDistanceFunction.cosine: 'sparsevec_cosine_ops',
        VectorDistanceFunction.l1: 'sparsevec_l1_ops',
      };

      for (var entry in distanceFunctions.entries) {
        var distance = entry.key;
        var expectedOps = entry.value;
        var indexName = '${modelName}_embedding_idx_$distance';

        var index = IndexDefinitionBuilder()
            .withIndexName(indexName)
            .withElements([
              IndexElementDefinition(
                type: IndexElementDefinitionType.column,
                definition: 'embedding',
              )
            ])
            .withType('hnsw')
            .withIsUnique(false)
            .withIsPrimary(false)
            .withVectorDistanceFunction(distance)
            .withVectorColumnType(ColumnType.sparsevec)
            .build();

        var sql = index.toPgSql(tableName: tableDefinition.name);

        expect(
          sql,
          'CREATE INDEX "$indexName" ON "${tableDefinition.name}" '
          'USING hnsw ("embedding" $expectedOps);\n',
        );
      }
    });
  });

  group('Given a table definition with a bit vector field', () {
    var modelName = 'bitModel';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(modelName.sentenceCase)
          .withFileName(modelName)
          .withTableName(modelName)
          .withVectorField('embedding', dimension: 1536, vectorType: 'Bit')
          .build(),
    ];

    var databaseDefinition =
        createDatabaseDefinitionFromModels(models, 'example', []);
    var tableDefinition = databaseDefinition.tables.first;

    test('then code for creating vector extension is generated.', () {
      var pgsql = databaseDefinition.toPgSql(installedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'when creating bit vector indexes with different distances, then they should generate SQL with correct ops parameters.',
        () {
      var distanceFunctions = {
        VectorDistanceFunction.hamming: 'bit_hamming_ops',
        VectorDistanceFunction.jaccard: 'bit_jaccard_ops',
      };

      for (var entry in distanceFunctions.entries) {
        var distance = entry.key;
        var expectedOps = entry.value;
        var indexName = '${modelName}_embedding_idx_$distance';

        var index = IndexDefinitionBuilder()
            .withIndexName(indexName)
            .withElements([
              IndexElementDefinition(
                type: IndexElementDefinitionType.column,
                definition: 'embedding',
              )
            ])
            .withType('hnsw')
            .withIsUnique(false)
            .withIsPrimary(false)
            .withVectorDistanceFunction(distance)
            .withVectorColumnType(ColumnType.bit)
            .build();

        var sql = index.toPgSql(tableName: tableDefinition.name);

        expect(
          sql,
          'CREATE INDEX "$indexName" ON "${tableDefinition.name}" '
          'USING hnsw ("embedding" $expectedOps);\n',
        );
      }
    });
  });
}

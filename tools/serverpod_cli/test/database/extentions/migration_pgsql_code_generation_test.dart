import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';
import '../../test_util/builders/model_source_builder.dart';
import '../../test_util/database_definition_helpers.dart';

void main() {
  group(
      'Given a table that is not managed by serverpod that changes to be managed',
      () {
    var tableName = 'example_table';

    var sourceDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withManaged(false)
            .build())
        .build();

    var targetDefinition = DatabaseDefinitionBuilder()
        .withDefaultModules()
        .withTable(TableDefinitionBuilder()
            .withName(tableName)
            .withManaged(true)
            .build())
        .build();

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    test(
        'Given a table transitioning from none manage to manage then the psql code contains a create table if not exists.',
        () {
      expect(psql, contains('CREATE TABLE IF NOT EXISTS "example_table"'));
    });
  });

  group('pgvector extension creation in migrations', () {
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
        'Given a migration with no vector field changes, then the code for creating vector extension is not generated.',
        () {
      var migration = DatabaseMigration(
        actions: [],
        warnings: [],
        migrationApiVersion: 1,
      );
      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, isNot(contains(createVectorExtension)));
    });

    test(
        'Given a migration that adds a table with a vector field, then the code for creating vector extension is generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder().build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('vector_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.vector)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'Given a migration that adds a vector column to existing table, then the code for creating vector extension is generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withTable(
              TableDefinitionBuilder().withName('existing_table').build())
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('existing_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.vector)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'Given a migration that removes a table with a vector field, then the code for creating vector extension is not generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('vector_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.vector)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var targetDefinition = DatabaseDefinitionBuilder().build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, isNot(contains(createVectorExtension)));
    });

    test(
        'Given a migration that adds a table with a half vector field, then the code for creating vector extension is generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder().build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('half_vector_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.halfvec)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'Given a migration that adds a half vector column to existing table, then the code for creating vector extension is generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withTable(
              TableDefinitionBuilder().withName('existing_table').build())
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('existing_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.halfvec)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'Given a migration that removes a table with a half vector field, then the code for creating vector extension is not generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('half_vector_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.halfvec)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var targetDefinition = DatabaseDefinitionBuilder().build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, isNot(contains(createVectorExtension)));
    });

    test(
        'Given a migration that adds a table with a sparse vector field, then the code for creating vector extension is generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder().build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('sparse_vector_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.sparsevec)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'Given a migration that adds a sparse vector column to existing table, then the code for creating vector extension is generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withTable(
              TableDefinitionBuilder().withName('existing_table').build())
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('existing_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.sparsevec)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'Given a migration that removes a table with a sparse vector field, then the code for creating vector extension is not generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('sparse_vector_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.sparsevec)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var targetDefinition = DatabaseDefinitionBuilder().build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, isNot(contains(createVectorExtension)));
    });

    test(
        'Given a migration that adds a table with a bit vector field, then the code for creating vector extension is generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder().build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('bit_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.bit)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'Given a migration that adds a bit vector column to existing table, then the code for creating vector extension is generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withTable(
              TableDefinitionBuilder().withName('existing_table').build())
          .build();

      var targetDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('existing_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.bit)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, contains(createVectorExtension));
    });

    test(
        'Given a migration that removes a table with a bit vector field, then the code for creating vector extension is not generated.',
        () {
      var sourceDefinition = DatabaseDefinitionBuilder()
          .withTable(TableDefinitionBuilder()
              .withName('bit_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('embedding')
                  .withColumnType(ColumnType.bit)
                  .withVectorDimension(512)
                  .build())
              .build())
          .build();

      var targetDefinition = DatabaseDefinitionBuilder().build();

      var migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      var pgsql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(pgsql, isNot(contains(createVectorExtension)));
    });
  });

  /// Issue: https://github.com/serverpod/serverpod/issues/3503
  test(
      'Given an existing table that that references a new table with a name lexically sorted before the existing one, when creating migraion sql then the migration code should create the table before defining the foreign key',
      () {
    var sourceModels = [
      ModelSourceBuilder().withFileName('existing_table').withYaml(
        '''
class: ExistingModel
table: a_existing_table
fields:
  name: String
          ''',
      ).build(),
    ];

    var targetModels = [
      ModelSourceBuilder().withFileName('new_model').withYaml(
        '''
class: NewModel
table: z_new_model
fields:
  name: String
          ''',
      ).build(),
      ModelSourceBuilder().withFileName('existing_table').withYaml(
        '''
class: ExistingModel
table: a_existing_table
fields:
  name: String
  newModel: NewModel?, relation(optional)
          ''',
      ).build(),
    ];

    var (:sourceDefinition, :targetDefinition) = databaseDefinitionsFromModels(
      sourceModels,
      targetModels,
    );

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    var createNewModelTable = psql.indexOf('CREATE TABLE "z_new_model"');
    var addForeignKeyToExistingTable =
        psql.indexOf('ADD CONSTRAINT "a_existing_table_fk_0"');

    expect(createNewModelTable, greaterThanOrEqualTo(0));
    expect(addForeignKeyToExistingTable, greaterThanOrEqualTo(0));

    expect(createNewModelTable, lessThan(addForeignKeyToExistingTable));
  });

  group('UUID v7 function generation in migrations', () {
    const v7functionHeader = 'create or replace function gen_random_uuid_v7()';

    test(
        'Given no tables with UUID v7 default columns when generating migration SQL then the UUID v7 function declaration is not included.',
        () {
      final sourceDefinition =
          DatabaseDefinitionBuilder().withDefaultModules().build();

      final targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(TableDefinitionBuilder()
              .withName('table_without_uuid')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('id')
                  .withColumnType(ColumnType.integer)
                  .build())
              .build())
          .build();

      final migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      final psql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(psql, isNot(contains(v7functionHeader)));
    });

    test(
        'Given a new table with UUID v7 default column when generating migration SQL then the UUID v7 function declaration is included.',
        () {
      final sourceDefinition =
          DatabaseDefinitionBuilder().withDefaultModules().build();

      final targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(TableDefinitionBuilder()
              .withName('table_with_uuid')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('id')
                  .withColumnType(ColumnType.uuid)
                  .withColumnDefault(pgsqlFunctionRandomUuidV7)
                  .build())
              .build())
          .build();

      final migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      final psql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(psql, contains(v7functionHeader));
    });

    test(
        'Given an existing table when adding a column with UUID v7 default then the UUID v7 function declaration is included.',
        () {
      final sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(TableDefinitionBuilder()
              .withName('existing_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('id')
                  .withColumnType(ColumnType.integer)
                  .build())
              .build())
          .build();

      final targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(TableDefinitionBuilder()
              .withName('existing_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('id')
                  .withColumnType(ColumnType.integer)
                  .build())
              .withColumn(ColumnDefinitionBuilder()
                  .withName('uuid_column')
                  .withColumnType(ColumnType.uuid)
                  .withColumnDefault(pgsqlFunctionRandomUuidV7)
                  .build())
              .build())
          .build();

      final migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      final psql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(psql, contains(v7functionHeader));
    });

    test(
        'Given a table with a UUID column when modifying it to use UUID v7 default then the UUID v7 function declaration is included.',
        () {
      final sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(TableDefinitionBuilder()
              .withName('modify_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('id')
                  .withColumnType(ColumnType.integer)
                  .build())
              .withColumn(ColumnDefinitionBuilder()
                  .withName('uuid_column')
                  .withColumnType(ColumnType.uuid)
                  .build())
              .build())
          .build();

      final targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(TableDefinitionBuilder()
              .withName('modify_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('id')
                  .withColumnType(ColumnType.integer)
                  .build())
              .withColumn(ColumnDefinitionBuilder()
                  .withName('uuid_column')
                  .withColumnType(ColumnType.uuid)
                  .withColumnDefault(pgsqlFunctionRandomUuidV7)
                  .build())
              .build())
          .build();

      final migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      final psql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(psql, contains(v7functionHeader));
    });

    test(
        'Given a table with UUID v7 default when changing to UUID v4 default then the UUID v7 function declaration is not included.',
        () {
      final sourceDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(TableDefinitionBuilder()
              .withName('uuid_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('uuid_column')
                  .withColumnType(ColumnType.uuid)
                  .withColumnDefault(pgsqlFunctionRandomUuidV7)
                  .build())
              .build())
          .build();

      final targetDefinition = DatabaseDefinitionBuilder()
          .withDefaultModules()
          .withTable(TableDefinitionBuilder()
              .withName('uuid_table')
              .withColumn(ColumnDefinitionBuilder()
                  .withName('uuid_column')
                  .withColumnType(ColumnType.uuid)
                  .withColumnDefault('gen_random_uuid()')
                  .build())
              .build())
          .build();

      final migration = generateDatabaseMigration(
        databaseSource: sourceDefinition,
        databaseTarget: targetDefinition,
      );

      final psql = migration.toPgSql(installedModules: [], removedModules: []);

      expect(psql, isNot(contains(v7functionHeader)));
    });
  });
}

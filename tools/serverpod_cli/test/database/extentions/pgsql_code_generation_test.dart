import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/database_definition_builder.dart';
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
    RAISE NOTICE 'Extension "vector" not available on this instance';
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

  test(
      'Given a database definition with Vector field in one of the tables, then code for creating vector extension is not generated.',
      () {
    var citizen = 'citizen';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(citizen.sentenceCase)
          .withFileName(citizen)
          .withTableName(citizen)
          .withVectorField('vector')
          .build(),
    ];

    var databaseDefinition = createDatabaseDefinitionFromModels(
      models,
      'example',
      [],
    );
    var pgsql = databaseDefinition.toPgSql(installedModules: []);

    expect(pgsql, contains(createVectorExtension));
  });
}

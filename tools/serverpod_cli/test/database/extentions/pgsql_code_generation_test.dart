import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/database_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/database/table_definition_builder.dart';
import 'package:test/test.dart';

void main() {
  group('Given classes with a circular relation when generating migration', () {
    /**
     * Citizen -> Company -> Town -> Citizen
     */
    var citizen = 'citizen';
    var company = 'company';
    var town = 'town';
    var models = [
      ClassDefinitionBuilder()
          .withClassName(citizen.sentenceCase)
          .withFileName(citizen)
          .withTableName(citizen)
          .withSimpleField('name', 'String')
          .withObjectRelationField(company, company.sentenceCase, company)
          .build(),
      ClassDefinitionBuilder()
          .withClassName(company.sentenceCase)
          .withFileName(company)
          .withTableName(company)
          .withSimpleField('name', 'String')
          .withObjectRelationField(town, town.sentenceCase, town)
          .build(),
      ClassDefinitionBuilder()
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
        var createCompanyIndex =
            pgsqlFile.indexOf('CREATE TABLE IF NOT EXISTS "company"');
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
        var createCompanyIndex =
            pgsqlFile.indexOf('CREATE TABLE IF NOT EXISTS "town"');
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
        var createCompanyIndex =
            pgsqlFile.indexOf('CREATE TABLE IF NOT EXISTS "citizen"');
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

    expect(
        pgsql, isNot(contains('CREATE TABLE IF NOT EXISTS "example_table"')));
  });
}

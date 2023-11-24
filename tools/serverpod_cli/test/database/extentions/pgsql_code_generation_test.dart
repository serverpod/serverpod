import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given classes with a circular relation when generating migration', () {
    /**
     * Citizen -> Company -> Town -> Citizen
     */
    var citizen = 'citizen';
    var company = 'company';
    var town = 'town';
    var entities = [
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

    var databaseDefinition =
        createDatabaseDefinitionFromEntities(entities, config);
    databaseDefinition.priority = 1;

    test('then all definitions are created.', () {
      expect(databaseDefinition.tables, hasLength(3));
    });

    group('then pgsql file for migration', () {
      var pgsqlFile =
          databaseDefinition.toPgSql(version: '1.0,0', module: 'test_module');
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
}

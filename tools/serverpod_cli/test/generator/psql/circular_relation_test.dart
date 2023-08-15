import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/generator/psql/legacy_pgsql_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:test/test.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = LegacyPgsqlCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'generated',
    'tables.pgsql',
  );
  group('Given classes with a circular relation when generating pgsql code',
      () {
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

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );
    var maybePgsqlFile = codeMap[expectedFileName];

    test(
      'then expected file is created.',
      () {
        expect(maybePgsqlFile, isNotNull);
      },
    );

    group('then file', () {
      var pgsqlFile = maybePgsqlFile!;
      test(
          'has foreign key creation for citizen after company table is created.',
          () {
        var createCompanyIndex = pgsqlFile.indexOf('CREATE TABLE "company"');
        var createForeignKeyForCitizenIndex = pgsqlFile.indexOf('''
ALTER TABLE ONLY "citizen"
  ADD CONSTRAINT citizen_fk_0
    FOREIGN KEY("companyId")
      REFERENCES company(id)
        ON DELETE CASCADE;
''');

        expect(createCompanyIndex, lessThan(createForeignKeyForCitizenIndex));
      });

      test('has foreign key creation for company after town table is created.',
          () {
        var createCompanyIndex = pgsqlFile.indexOf('CREATE TABLE "town"');
        var createForeignKeyForCitizenIndex = pgsqlFile.indexOf('''
ALTER TABLE ONLY "company"
  ADD CONSTRAINT company_fk_0
    FOREIGN KEY("townId")
      REFERENCES town(id)
        ON DELETE CASCADE;
''');

        expect(createCompanyIndex, lessThan(createForeignKeyForCitizenIndex));
      });

      test('has foreign key creation for town after citizen table is created.',
          () {
        print(pgsqlFile);
        var createCompanyIndex = pgsqlFile.indexOf('CREATE TABLE "citizen"');
        var createForeignKeyForCitizenIndex = pgsqlFile.indexOf('''
ALTER TABLE ONLY "town"
  ADD CONSTRAINT town_fk_0
    FOREIGN KEY("mayorId")
      REFERENCES citizen(id)
        ON DELETE CASCADE;
''');

        expect(createCompanyIndex, lessThan(createForeignKeyForCitizenIndex));
      });
    },
        skip: maybePgsqlFile == null
            ? 'tables.pgsql file was not created'
            : false);
  });
}

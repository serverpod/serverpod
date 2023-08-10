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
  /**
   * Citizen -> Company -> Town
   */
  group('Given classes with relations when generating pgsql', () {
    var expectedFileName = path.join(
      'generated',
      'tables.pgsql',
    );

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
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then expected file is created.', () async {
      expect(codeMap[expectedFileName], isNotNull);
    });

    test('then file content matches regression data.', () async {
      var regressionData = '''
--
-- Class Citizen as table citizen
--

CREATE TABLE "citizen" (
  "id" serial,
  "name" text NOT NULL,
  "companyId" integer NOT NULL
);

ALTER TABLE ONLY "citizen"
  ADD CONSTRAINT citizen_pkey PRIMARY KEY (id);

--
-- Class Company as table company
--

CREATE TABLE "company" (
  "id" serial,
  "name" text NOT NULL,
  "townId" integer NOT NULL
);

ALTER TABLE ONLY "company"
  ADD CONSTRAINT company_pkey PRIMARY KEY (id);

--
-- Class Town as table town
--

CREATE TABLE "town" (
  "id" serial,
  "name" text NOT NULL
);

ALTER TABLE ONLY "town"
  ADD CONSTRAINT town_pkey PRIMARY KEY (id);

--
-- Foreign relations for "citizen" table
--

ALTER TABLE ONLY "citizen"
  ADD CONSTRAINT citizen_fk_0
    FOREIGN KEY("companyId")
      REFERENCES company(id)
        ON DELETE CASCADE;

--
-- Foreign relations for "company" table
--

ALTER TABLE ONLY "company"
  ADD CONSTRAINT company_fk_0
    FOREIGN KEY("townId")
      REFERENCES town(id)
        ON DELETE CASCADE;

''';

      expect(codeMap[expectedFileName], equals(regressionData));
    });
  });
}

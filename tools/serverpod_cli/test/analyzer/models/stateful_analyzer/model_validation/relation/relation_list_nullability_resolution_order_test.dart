import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

/// The nullability of a named list relation must be determined by the foreign
/// key field on the foreign class, independently of the order in which the
/// model files are analyzed.
void main() {
  var config = GeneratorConfigBuilder().build();

  var companyYaml = '''
        class: Company
        table: company
        fields:
          employees: List<Employee>?, relation(name=company_employees)
        ''';

  ListRelationDefinition resolveListRelation(
    List<({String fileName, String yaml})> orderedModels,
  ) {
    var models = orderedModels
        .map(
          (model) => ModelSourceBuilder()
              .withFileName(model.fileName)
              .withYaml(model.yaml)
              .build(),
        )
        .toList();

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    expect(collector.errors, isEmpty);

    var company = definitions.whereType<ClassDefinition>().firstWhere(
      (definition) => definition.className == 'Company',
    );

    return company.findField('employees')!.relation as ListRelationDefinition;
  }

  group('Given a named one to many relation with a required foreign key,', () {
    var employeeYaml = '''
        class: Employee
        table: employee
        fields:
          company: Company?, relation(name=company_employees)
        ''';

    test('when the foreign class is analyzed before the list owner, '
        'then the nullableRelation is set to false.', () {
      var relation = resolveListRelation([
        (fileName: 'employee', yaml: employeeYaml),
        (fileName: 'company', yaml: companyYaml),
      ]);

      expect(relation.nullableRelation, isFalse);
    });

    test('when the list owner is analyzed before the foreign class, '
        'then the nullableRelation is set to false.', () {
      var relation = resolveListRelation([
        (fileName: 'company', yaml: companyYaml),
        (fileName: 'employee', yaml: employeeYaml),
      ]);

      expect(relation.nullableRelation, isFalse);
    });
  });

  group('Given a named one to many relation with an optional foreign key,', () {
    var employeeYaml = '''
        class: Employee
        table: employee
        fields:
          company: Company?, relation(name=company_employees, optional)
        ''';

    test('when the foreign class is analyzed before the list owner, '
        'then the nullableRelation is set to true.', () {
      var relation = resolveListRelation([
        (fileName: 'employee', yaml: employeeYaml),
        (fileName: 'company', yaml: companyYaml),
      ]);

      expect(relation.nullableRelation, isTrue);
    });

    test('when the list owner is analyzed before the foreign class, '
        'then the nullableRelation is set to true.', () {
      var relation = resolveListRelation([
        (fileName: 'company', yaml: companyYaml),
        (fileName: 'employee', yaml: employeeYaml),
      ]);

      expect(relation.nullableRelation, isTrue);
    });
  });

  group('Given a named one to many relation with an explicit nullable '
      'foreign key field,', () {
    var employeeYaml = '''
        class: Employee
        table: employee
        fields:
          companyId: int?
          company: Company?, relation(name=company_employees, field=companyId)
        ''';

    test('when the foreign class is analyzed before the list owner, '
        'then the nullableRelation is set to true.', () {
      var relation = resolveListRelation([
        (fileName: 'employee', yaml: employeeYaml),
        (fileName: 'company', yaml: companyYaml),
      ]);

      expect(relation.nullableRelation, isTrue);
    });

    test('when the list owner is analyzed before the foreign class, '
        'then the nullableRelation is set to true.', () {
      var relation = resolveListRelation([
        (fileName: 'company', yaml: companyYaml),
        (fileName: 'employee', yaml: employeeYaml),
      ]);

      expect(relation.nullableRelation, isTrue);
    });
  });

  group('Given a named one to many relation with an explicit non-nullable '
      'foreign key field,', () {
    var employeeYaml = '''
        class: Employee
        table: employee
        fields:
          companyId: int
          company: Company?, relation(name=company_employees, field=companyId)
        ''';

    test('when the foreign class is analyzed before the list owner, '
        'then the nullableRelation is set to false.', () {
      var relation = resolveListRelation([
        (fileName: 'employee', yaml: employeeYaml),
        (fileName: 'company', yaml: companyYaml),
      ]);

      expect(relation.nullableRelation, isFalse);
    });

    test('when the list owner is analyzed before the foreign class, '
        'then the nullableRelation is set to false.', () {
      var relation = resolveListRelation([
        (fileName: 'company', yaml: companyYaml),
        (fileName: 'employee', yaml: employeeYaml),
      ]);

      expect(relation.nullableRelation, isFalse);
    });
  });
}

import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with a one to many relation', () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  company: Company?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  employees: List<Employee>?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      entities,
    );

    var classDefinition = definition2 as ClassDefinition;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then no id field was created for the many side.', () {
      expect(
        classDefinition.findField('employeesId'),
        isNull,
        reason: 'Expected employeesId to not exist as a field, but it did.',
      );
    });

    test('then the reference field is set on the list relation.', () {
      expect(
        classDefinition.findField('employees')?.referenceFieldName,
        'companyId',
        reason: "Expected employees's referenceFieldName to be companyId, but "
            "it was ${classDefinition.findField('employees')?.referenceFieldName}.",
      );
    });
  });

  test(
      'Given a class with a one to many relation but the one side has no relation defined but has an id field then an error is collected that the reference class could not be found.',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  companyId: int
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  employees: List<Employee>?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      entities,
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error but none was found.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'The class "Employee" does not have a relation to this protocol.',
    );
  });

  test(
      'Given a class with a one to many relation where the relation ship is ambiguous then an error is collected that the reference cannot be resolved.',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  company: Company?, relation
  myCompany: Company?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  employees: List<Employee>?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      entities,
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error but none was found.',
    );

    var error = collector.errors.first;

    // Todo improve error message when we support named relations.
    expect(
      error.message,
      'The class "Employee" has several reference fields, unable to resolve ambiguous relation.',
    );
  });
}

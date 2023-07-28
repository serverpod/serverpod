void main() {

}

/*import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with a self relation on a field with the class datatype',
      () {
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

    test('Given a class with a List relation, then no id field was created',
        () {
      expect(
        classDefinition.findField('employeesId'),
        isNull,
      );
    });

    test('Given a class with a List relation, then the join on field is set',
        () {
      expect(
        classDefinition.findField('employees')?.referenceFieldName,
        'companyId',
      );
    });
  });
}
*/
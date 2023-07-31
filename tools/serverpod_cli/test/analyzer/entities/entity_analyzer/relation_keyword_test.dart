import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with a field with a self relation, then the parent table is set to the specified table name.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(collector.errors, isEmpty);

    expect((definition as ClassDefinition).fields.last.parentTable, 'example');
  });

  test(
      'Given a class with a field with a relation, but the parent keyword defined twice, then an error is collected that there is a duplicated key.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example, parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The field option "parent" is defined more than once.',
    );
  });

  test(
      'Given a class with a field with a relation and parent keyword, then an error is collected that they are mutually exclusive key.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example), parent=example
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The "parent" property is mutually exclusive with the "relation" property.',
    );
  });

  test(
      'Given a class with a field with a relation, but the parent keyword defined twice, then an error is collected that locates the second parent key.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example, parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    var error = collector.errors.first;

    expect(error.span, isNotNull,
        reason: 'Expected error to have a source span.');

    var startSpan = error.span!.start;
    expect(startSpan.line, 3);
    expect(startSpan.column, 42);

    var endSpan = error.span!.end;
    expect(endSpan.line, 3);
    expect(endSpan.column, 48);
  });

  test('Given a class .', () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
fields:
  parentId: int, relation(parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The "table" property must be defined in the class to set a relation on a field.',
    );
  });
}

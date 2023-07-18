import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given two protocols with the same class name, then an error is collected that there is a collision in the class names.',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var protocol2 = ProtocolSource(
      '''
class: Example
fields:
  differentName: String
''',
      Uri(path: 'lib/src/protocol/example2.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      [definition1!, definition2!],
    );

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      [definition1, definition2],
    );

    expect(collector.errors.length, greaterThan(0));

    expect(collector.errors.first.message,
        'The class name "Example" is already used by another protocol class.');
  });

  test(
      'Given a single valid protocol, then there is no error collected for the class name.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
fields:
  name: String
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
  });
}

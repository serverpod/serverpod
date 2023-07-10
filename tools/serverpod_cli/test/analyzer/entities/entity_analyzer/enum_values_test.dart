import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given an enum without a values property, then collect an error that the values property is required.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
enum: ExampleEnum
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'No "values" property is defined.');
  });

  test(
      'Given an enum with an empty values property, then collect an error that values must be defined.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
enum: ExampleEnum
values:
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'The "values" property must be a list of strings.');
  });

  test(
      'Given an enum with the values property defined as a map, then collect an error that values must be a list.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
enum: ExampleEnum
values:
  value1: 1
  value2: 2
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'The "values" property must be a list of strings.');
  });

  test(
      'Given an enum with the values with none string values, then collect an error that values must be a list of strings.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
enum: ExampleEnum
values:
  - 1
  - 2
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'The "values" property must be a list of strings.');
  });

  test(
      'Given an enum with an invalid enum string structure, then collect an error that the string must follow the required syntax.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
enum: ExampleEnum
values:
  - InvalidValue
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'Enum values must be lowerCamelCase.');
  });

  test(
      'Given a valid enum with two values, then the enum definition should contain two values.',
      () {
    var protocol = ProtocolSource(
      '''
enum: ExampleEnum
values:
  - first
  - second
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol)
            as EnumDefinition;

    expect(definition.values.first.name, 'first');
    expect(definition.values.last.name, 'second');
  });
}

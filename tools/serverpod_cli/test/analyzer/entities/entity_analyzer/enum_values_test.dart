import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given an enum without a values property, then collect an error that the values property is required.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
enum: ExampleEnum
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'No "values" property is defined.');
  });

  test(
      'Given an enum with an empty values property, then collect an error that values must be defined.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
enum: ExampleEnum
values:
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'The "values" property must be a list of strings.');
  });

  test(
      'Given an enum with the values property defined as a map, then collect an error that values must be a list.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
enum: ExampleEnum
values:
  value1: 1
  value2: 2
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'The "values" property must be a list of strings.');
  });

  test(
      'Given an enum with the values with none string values, then collect an error that values must be a list of strings.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
enum: ExampleEnum
values:
  - 1
  - 2
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'The "values" property must be a list of strings.');
  });

  test(
      'Given an enum with an invalid enum string structure, then collect an error that the string must follow the required syntax.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
enum: ExampleEnum
values:
  - InvalidValue
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'Enum values must be lowerCamelCase.');
  });

  test(
      'Given a valid enum with two values, then the enum definition should contain two values.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
enum: ExampleEnum
values:
  - first
  - second
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    EnumDefinition enumDefinition = analyzer.analyze() as EnumDefinition;

    expect(enumDefinition.values.first.name, 'first');
    expect(enumDefinition.values.last.name, 'second');
  });
}

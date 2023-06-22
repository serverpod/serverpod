import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with the fields key defined but without any field, then collect an error that at least one field has to be added.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
fields:
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(
        error.message, 'The "fields" property must have at least one field.');
  });

  test(
      'Given an exception with the fields key defined but without any field, then collect an error that at least one field has to be added.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
exception: Example
fields:
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(
        error.message, 'The "fields" property must have at least one field.');
  });

  test(
      'Given an class with the fields key defined as a primitive datatype instead of a Map, then collect an error that at least one field has to be added.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
fields: int
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(
        error.message, 'The "fields" property must have at least one field.');
  });

  test(
      'Given an enum with the fields key defined, then collect an error that fields are not allowed.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
enum: Example
fields:
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The "fields" property is not allowed for enums. Valid keys are {enum, serverOnly, values}.');
  });
}

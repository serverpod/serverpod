import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a PascalCASEString class name with several uppercase letters, then no errors are collected.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
exception: PascalCASEString
fields:
  name: String
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, 0);
  });
  test(
      'Given a camelCase class name, then give an error indicating that PascalCase is required.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: exampleClass
fields:
  name: String
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
        'The "class" type must be a valid class name (e.g. PascalCaseString).');
  });

  test(
      'Given a snake_case exception name, then give an error indicating that PascalCase is required.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
exception: example_class
fields:
  name: String
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
        'The "exception" type must be a valid class name (e.g. PascalCaseString).');
  });

  test(
      'Given an enum name with a leading number, then give an error indicating that PascalCase is required.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
enum: 1ExampleType
values:
  - yes
  - no
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
        'The "enum" type must be a valid class name (e.g. PascalCaseString).');
  });
}

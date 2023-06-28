import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

void main() {
  group('serverOnly property tests', () {
    test(
        'Given a class defined to serverOnly, then the serverOnly property is set to true.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
serverOnly: true
fields:
  name: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.serverOnly, true);
    });

    test(
        'Given a class explicitly setting serverOnly to false, then the serverOnly property is set to false.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
serverOnly: false
fields:
  name: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.serverOnly, false);
    });

    test(
        'Given a class without the serverOnly property, then the default "false" value is used.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.serverOnly, false);
    });

    test(
        'Given a class with the serverOnly property set to another datatype than bool, then an error is collected notifying that the serverOnly must be a bool.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
serverOnly: Yes
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

      expect(error.message, 'The property value must be a bool.');
    });

    test(
        'Given an exception with the serverOnly property set to another datatype than bool, then an error is collected notifying that the serverOnly must be a bool.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
exception: Example
serverOnly: Yes
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

      expect(error.message, 'The property value must be a bool.');
    });
  });

  group('table property tests', () {
    test(
        'Given a class with a table defined, then the tableName is set in the definition.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: example
fields:
  name: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.tableName, 'example');
    });

    test(
        'Given a class with a table name in a none snake_case_format, then collect an error that snake_case must be used.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: camelCaseTable
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

      expect(
          error.message, 'The "table" property must be a snake_case_string.');
    });

    test(
        'Given a class with a table name is not a string, then collect an error that snake_case must be used.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: true
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

      expect(
          error.message, 'The "table" property must be a snake_case_string.');
    });

    test(
        'Given an exception with a table defined, then collect an error that table cannot be used together with exceptions.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
exception: Example
table: example
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

      expect(error.message, 'The "table" property is not allowed for exception type. Valid keys are {exception, serverOnly, fields}.');
    });
  });

  group('Invalid properties', () {
    test(
        'Given a class with an invalid property, then collect an error that such a property is not allowed.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
invalidProperty: true
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
          'The "invalidProperty" property is not allowed for class type. Valid keys are {class, table, serverOnly, fields, indexes}.');
    });

    test(
        'Given a class with an invalid property, then collect an error that such a property is not allowed.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
invalidProperty: true
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
          'The "invalidProperty" property is not allowed for class type. Valid keys are {class, table, serverOnly, fields, indexes}.');
    });

    test(
        'Given an exception with an indexes defined, then collect an error that indexes cannot be used together with exceptions.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
exception: ExampleException
fields:
  name: String
indexes:
  example_exception_idx: 
    fields: name
    unique: true
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
          'The "indexes" property is not allowed for exception type. Valid keys are {exception, serverOnly, fields}.');
    });

    test(
        'Given an enum with a table defined, then collect an error that table cannot be used together with enums.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
enum: Example
table: example
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
          'The "table" property is not allowed for enums. Valid keys are {enum, serverOnly, values}.');
    });
  });
}

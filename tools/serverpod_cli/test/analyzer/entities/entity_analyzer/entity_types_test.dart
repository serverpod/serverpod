import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  test('Given a class with a null value as name, then collect an error ....',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
class:
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [],
    );

    expect(collector.errors.length, greaterThan(0), reason: 'No errors found');

    var error = collector.errors.first;

    expect(error.message, 'The "class" type must be a String.');
  });

  test(
      'Given a PascalCASEString class name with several uppercase letters, then no errors are collected.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
exception: PascalCASEString
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);
    SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml, protocol.yamlSourceUri.path, collector, definition, []);

    expect(collector.errors.length, 0);
  });

  test(
      'Given a PascalCASEString class name with several uppercase letters, then an exception with that name is generated.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
exception: PascalCASEString
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);
    SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml, protocol.yamlSourceUri.path, collector, definition, []);

    expect((definition as ClassDefinition).className, 'PascalCASEString');
  });

  test(
      'Given a camelCase class name, then give an error indicating that PascalCase is required.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
class: exampleClass
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);
    SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml, protocol.yamlSourceUri.path, collector, definition, []);

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The "class" type must be a valid class name (e.g. PascalCaseString).');
  });

  test(
      'Given a snake_case exception name, then give an error indicating that PascalCase is required.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
exception: example_class
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);
    SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml, protocol.yamlSourceUri.path, collector, definition, []);

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The "exception" type must be a valid class name (e.g. PascalCaseString).');
  });

  test(
      'Given an enum name with a leading number, then give an error indicating that PascalCase is required.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
enum: 1ExampleType
values:
  - yes
  - no
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);
    SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml, protocol.yamlSourceUri.path, collector, definition, []);

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The "enum" type must be a valid class name (e.g. PascalCaseString).');
  });

  group('Given a protocol without any defined entity type', () {
    test(
        'Then return a human readable error message informing the user that the entity type is missing.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
invalid: Type 
fields:
  name: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;
      expect(error.message, 'No {class, exception, enum} type is defined.');
    });
  });

  group('Given a protocol with class and exception type defined.', () {
    test('Then return a human readable error message when analyzing.', () {
      var collector = CodeGenerationCollector();

      var protocol = ProtocolSource(
        '''
class: Example
exception: ExampleException
fields:
  name: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, []);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;
      expect(error.message,
          'Multiple entity types ("class", "exception") found for a single entity. Only one type per entity allowed.');
    });

    test('Then the second type is highlighted.', () {
      var collector = CodeGenerationCollector();

      var protocol = ProtocolSource(
        '''
class: Example
exception: ExampleException
fields:
  name: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, []);

      expect(collector.errors.length, greaterThan(0));
      var span = collector.errors.first.span;

      expect(span?.start.line, 1);
      expect(span?.start.column, 0);

      expect(span?.end.line, 1);
      expect(span?.end.column, 'exception'.length);
    });
  });

  group('Given a protocol with exception and enum type defined.', () {
    test('Then return a human readable error message when analyzing.', () {
      var collector = CodeGenerationCollector();

      var protocol = ProtocolSource(
        '''
exception: ExampleException
enum: ExampleType
fields:
  name: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, []);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;
      expect(error.message,
          'Multiple entity types ("exception", "enum") found for a single entity. Only one type per entity allowed.');
    });
  });

  group('Given a protocol with three different types defined.', () {
    test('Then return a human readable error message when analyzing.', () {
      var collector = CodeGenerationCollector();

      var protocol = ProtocolSource(
        '''
class: Example
exception: ExampleException
enum: ExampleType
fields:
  name: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, []);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;
      expect(error.message,
          'Multiple entity types ("class", "exception", "enum") found for a single entity. Only one type per entity allowed.');
    });

    test('Then the second and third type is highlighted.', () {
      var collector = CodeGenerationCollector();

      var protocol = ProtocolSource(
        '''
class: Example
exception: ExampleException
enum: ExampleType
fields:
  name: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, []);

      expect(collector.errors.length, greaterThan(1));

      var span = collector.errors[0].span;

      expect(span?.start.line, 1);
      expect(span?.start.column, 0);
      expect(span?.end.line, 1);
      expect(span?.end.column, 'exception'.length);

      var span2 = collector.errors[1].span;

      expect(span2?.start.line, 2);
      expect(span2?.start.column, 0);
      expect(span2?.end.line, 2);
      expect(span2?.end.column, 'enum'.length);
    });
  });
}

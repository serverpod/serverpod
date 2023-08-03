import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Source location in field values.', () {
    test(
        'Given a class with a field with an invalid key, then collect an error that locates the invalid key in the comma separated string.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  nameId: int, invalid
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

      expect(error.span, isNotNull,
          reason: 'Expected error to have a source span.');

      var startSpan = error.span!.start;
      expect(startSpan.line, 2);
      expect(startSpan.column, 15);

      var endSpan = error.span!.end;
      expect(endSpan.line, 2);
      expect(endSpan.column, 22);
    });
    test(
        'Given a class with a field with the parent keyword but without a value, then collect an error that locates the parent keyword in the comma separated string.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  nameId: int, parent=
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

      expect(error.span, isNotNull,
          reason: 'Expected error to have a source span.');

      var startSpan = error.span!.start;
      expect(
        startSpan.line,
        3,
        reason: 'Expected the start line to match.',
      );
      expect(
        startSpan.column,
        22,
        reason: 'Expected the start column to match.',
      );

      var endSpan = error.span!.end;
      expect(
        endSpan.line,
        3,
        reason: 'Expected the end line to match.',
      );
      expect(
        endSpan.column,
        22,
        reason: 'Expected the end column to match.',
      );
    });

    test(
        'Given a class with a field with the parent keyword with an invalid table name, then collect an error that locates the value in the comma separated string.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  nameId: int, parent=InvalidName_
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

      expect(
        error.span,
        isNotNull,
        reason: 'Expected error to have a source span.',
      );

      var startSpan = error.span!.start;
      expect(startSpan.line, 3);
      expect(startSpan.column, 22);

      var endSpan = error.span!.end;
      expect(endSpan.line, 3);
      expect(endSpan.column, 34);
    });

    test(
        'Given a class with a field with database and api defined, then collect an error that locates the api keyword in the comma separated string.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  nameId: int, database, api
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

      var error = collector.errors.last;

      expect(
        error.span,
        isNotNull,
        reason: 'Expected error to have a source span.',
      );

      var startSpan = error.span!.start;
      expect(startSpan.line, 3);
      expect(startSpan.column, 25);

      var endSpan = error.span!.end;
      expect(endSpan.line, 3);
      expect(endSpan.column, 28);
    });

    test(
        'Given a class with a field with an empty string entry at the end, then collect an error that locates the empty string in the comma separated string.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  nameId: int, database,
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

      var error = collector.errors.last;

      expect(
        error.span,
        isNotNull,
        reason: 'Expected error to have a source span.',
      );

      var startSpan = error.span!.start;
      expect(startSpan.line, 3);
      expect(startSpan.column, 24);

      var endSpan = error.span!.end;
      expect(endSpan.line, 3);
      expect(endSpan.column, 24);
    });

    test(
        'Given a class with a field with a duplicated key value, then collect an error that locates the duplicated key in the comma separated string.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  nameId: int, database, database, parent=example
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

      expect(
        error.span,
        isNotNull,
        reason: 'Expected error to have a source span.',
      );

      var startSpan = error.span!.start;
      expect(startSpan.line, 3);
      expect(startSpan.column, 25);

      var endSpan = error.span!.end;
      expect(endSpan.line, 3);
      expect(endSpan.column, 33);
    });

    test(
        'Given a class with a field with an invalid dart syntax for the type, then collect an error that locates the invalid type in the comma separated string.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  nameId: Invalid-Type, database
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

      var error = collector.errors.last;

      expect(
        error.span,
        isNotNull,
        reason: 'Expected error to have a source span.',
      );

      var startSpan = error.span!.start;
      expect(startSpan.line, 3);
      expect(startSpan.column, 10);

      var endSpan = error.span!.end;
      expect(endSpan.line, 3);
      expect(endSpan.column, 22);
    });
  });
}

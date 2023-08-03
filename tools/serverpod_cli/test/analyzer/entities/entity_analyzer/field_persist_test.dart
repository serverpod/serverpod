import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a class with a field with no persist set but has a table, then the generated entity should be persisted.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        table: example
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
        [definition!],
      );

      expect(
        (definition as ClassDefinition).fields.last.shouldPersist,
        isTrue,
      );
    },
  );

  group(
    'Given a class with a field with persist set.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        table: example
        fields:
          name: String, persist
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
        [definition!],
      );

      test('then no errors are collected', () {
        expect(collector.errors, isEmpty);
      });

      test('then the generated entity should be persisted', () {
        expect(
          (definition as ClassDefinition).fields.last.shouldPersist,
          isTrue,
        );
      });
    },
  );

  test(
    'Given a class with a field with persist set to true, then the generated entity should be persisted.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        table: example
        fields:
          name: String, persist=true
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
        [definition!],
      );

      expect(
        (definition as ClassDefinition).fields.last.shouldPersist,
        isTrue,
      );
    },
  );

  test(
    'Given a class with a field with persist set to false, then the generated entity should not be persisted.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        table: example
        fields:
          name: String, persist=false
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
        [definition!],
      );

      expect(
        (definition as ClassDefinition).fields.last.shouldPersist,
        isFalse,
      );
    },
  );
}

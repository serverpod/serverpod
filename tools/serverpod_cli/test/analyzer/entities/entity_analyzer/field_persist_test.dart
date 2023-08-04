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

  group(
    'Given a class with a field with persist negated',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        table: example
        fields:
          name: String, !persist
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

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test('then the generated entity should not be persisted.', () {
        expect(
          (definition as ClassDefinition).fields.last.shouldPersist,
          isFalse,
        );
      });
    },
  );

  test(
    'Given a class with a field with a negated key and a value set, then collect an error that the negation operator cannot be used together with a value.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        table: example
        fields:
          name: String, !persist=true
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

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message, 'Negating a key with a value is not allowed.');
    },
  );

  test(
    'Given a class with a field with a nested negated key and a value set, then collect an error that the negation operator cannot be used together with a value.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        table: example
        fields:
          parent: Example?, relation(!optional=true)
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

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message, 'Negating a key with a value is not allowed.');
    },
  );

  test(
    'Given a class without a table but with a field with persist set, then collect an error that the field cannot be persisted without setting table.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
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

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message,
          'The "persist" property requires a table to be set on the class.');
    },
  );

  test(
    'Given a class with a field with both the persist and api keywords, then collect an error that only one of them is allowed.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        table: example
        fields:
          name: String, persist, api
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

      expect(collector.errors.length, greaterThan(1));

      var error1 = collector.errors[0];
      var error2 = collector.errors[1];

      expect(
        error1.message,
        'The "persist" property is mutually exclusive with the "api" property.',
      );
      expect(
        error2.message,
        'The "api" property is mutually exclusive with the "persist" property.',
      );
    },
  );

  test(
    'Given a class with a field with both the persist and database keywords, then collect an error that only one of them is allowed.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        table: example
        fields:
          name: String, persist, database
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

      expect(collector.errors.length, greaterThan(1));

      var error1 = collector.errors[0];
      var error2 = collector.errors[1];

      expect(
        error1.message,
        'The "persist" property is mutually exclusive with the "database" property.',
      );
      expect(
        error2.message,
        'The "database" property is mutually exclusive with the "persist" property.',
      );
    },
  );
}

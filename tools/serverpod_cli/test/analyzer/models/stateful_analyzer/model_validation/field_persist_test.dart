import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a class with a field with no persist set but has a table, then the generated model should be persisted.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
            class: Example
            table: example
            fields:
              name: String
            ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;
      expect(definition.fields.last.shouldPersist, isTrue);
    },
  );

  group(
    'Given a class with a field with persist set.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
            class: Example
            table: example
            fields:
              name: String, persist
            ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;

      test('then the generated model should be persisted', () {
        expect(
          definition.fields.last.shouldPersist,
          isTrue,
        );
      });
    },
  );

  test(
    'Given a class with a field with persist set to true, then the generated model should be persisted.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String, persist=true
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.last.shouldPersist,
        isTrue,
      );
    },
  );

  test(
    'Given a class with a field with persist set to false, then the generated model should not be persisted.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String, persist=false
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.last.shouldPersist,
        isFalse,
      );
    },
  );

  group(
    'Given a class with a field with persist negated',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String, !persist
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test('then the generated model should not be persisted.', () {
        expect(
          definition.fields.last.shouldPersist,
          isFalse,
        );
      });
    },
  );

  test(
    'Given a class with a field with persist negated and a relation defined, then collect an error that the keys are mutually exclusive.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parent: Example?, !persist, relation
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The "persist" property is mutually exclusive with the "relation" property.',
      );
    },
  );

  test(
    'Given a class with a field with persist negated and a relation defined, then collect an error that the keys are mutually exclusive.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parent: int?, !persist, parent=example
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.last;

      expect(error.message,
          'The "persist" property is mutually exclusive with the "parent" property.');
    },
  );

  test(
    'Given a class with a field with a persist key set to true, then collect an info that the keyword is unnecessary.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parent: Example?, persist
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first as SourceSpanSeverityException;

      expect(
        error.message,
        'Fields are persisted by default, the property can be removed.',
      );
      expect(error.severity, SourceSpanSeverity.hint);
      expect(error.tags?.first, SourceSpanTag.unnecessary);
    },
  );

  test(
    'Given a class with a field with a negated key and a value set, then collect an error that the negation operator cannot be used together with a value.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String, !persist=true
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(error.message, 'Negating a key with a value is not allowed.');
    },
  );

  test(
    'Given a class with a field with a nested negated key and a value set, then collect an error that the negation operator cannot be used together with a value.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parent: Example?, relation(!optional=true)
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(error.message, 'Negating a key with a value is not allowed.');
    },
  );

  test(
    'Given a class with a field with the optional key set to an invalid value, then collect an error that value must be a boolean.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parent: Example?, relation(optional=INVALID)
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(error.message, 'The value must be a boolean.');
    },
  );

  test(
    'Given a class without a table but with a field with persist set, then collect an error that the field cannot be persisted without setting table.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String, persist
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(error.message,
          'The "persist" property requires a table to be set on the class.');
    },
  );

  test(
    'Given a class with a field with the persist key set to a none boolean value, then collect a warning that the value must be a bool.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        table: example
        fields:
          name: String, persist=INVALID
        ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.last;

      expect(error.message, 'The value must be a boolean.');
    },
  );

  test(
    'Given a class with a field with both the persist and api keywords, then collect an error that only one of them is allowed.',
    () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        table: example
        fields:
          name: String, persist, api
        ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

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
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        table: example
        fields:
          name: String, !persist, database
        ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

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

import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  test(
    'Given a class with a field with no persist set but has a table, then the generated model should be persisted.',
    () {
      var models = [
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
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));

      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;
      expect(definition.fields.last.shouldPersist, isTrue);
    },
  );

  group(
    'Given a class with a field with persist set.',
    () {
      var models = [
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
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));

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
      var models = [
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
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));

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
      var models = [
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
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));

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
      var models = [
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
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));

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
      var models = [
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
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The "persist" property is mutually exclusive with the "relation" property.',
      );
    },
  );

  test(
    'Given a class with a field with a persist key set to true, then collect an info that the keyword is unnecessary.',
    () {
      var models = [
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
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

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
      var models = [
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
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(error.message, 'Negating a key with a value is not allowed.');
    },
  );

  test(
    'Given a class with a field with a nested negated key and a value set, then collect an error that the negation operator cannot be used together with a value.',
    () {
      var models = [
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
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(error.message, 'Negating a key with a value is not allowed.');
    },
  );

  test(
    'Given a class with a field with the optional key set to an invalid value, then collect an error that value must be a boolean.',
    () {
      var models = [
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
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(error.message, 'The value must be a boolean.');
    },
  );

  test(
    'Given a class without a table but with a field with persist set, then collect an error that the field cannot be persisted without setting table.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String, persist
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(error.message,
          'The "persist" property requires a table to be set on the class.');
    },
  );

  test(
    'Given a class with a field with the persist key set to a none boolean value, then collect a warning that the value must be a bool.',
    () {
      var models = [
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
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.last;

      expect(error.message, 'The value must be a boolean.');
    },
  );
}

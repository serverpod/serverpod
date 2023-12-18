import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  group('Test invalid top level fields key values', () {
    test(
        'Given a class without the fields key, then collect an error that the fields key is required',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'No "fields" property is defined.');
    });

    test(
        'Given an exception without the fields key, then collect an error that the fields key is required',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          exception: Example
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'No "fields" property is defined.');
    });

    test(
        'Given a class with the fields key defined but without any field, then collect an error that at least one field has to be added.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The "fields" property must have at least one value.',
      );
    });

    test(
        'Given an exception with the fields key defined but without any field, then collect an error that at least one field has to be added.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          exception: Example
          fields:
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The "fields" property must have at least one value.',
      );
    });

    test(
        'Given an class with the fields key defined as a primitive datatype instead of a Map, then collect an error that at least one field has to be added.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields: int
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The "fields" property must have at least one value.',
      );
    });

    test(
        'Given an enum with the fields key defined, then collect an error that fields are not allowed.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          enum: Example
          fields:
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The "fields" property is not allowed for enum type. Valid keys are {enum, serialized, serverOnly, values}.',
      );
    });
  });

  group('Testing key of fields.', () {
    test(
      'Given a class with a field key that is not a string, then collect an error that field keys have to be of the type string.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              1: String
            ''',
          ).build()
        ];
        var collector = CodeGenerationCollector();
        StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(error.message, 'Key must be of type String.');
      },
    );

    test(
      'Given a class with a field key that is not a valid dart variable name style, collect an error that the keys needs to follow the dart convention.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              Invalid-Field-Name: String
            ''',
          ).build()
        ];
        var collector = CodeGenerationCollector();
        StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'Field names must be valid Dart variable names (e.g. camelCaseString).',
        );
      },
    );

    test(
      'Given a class with a field key that is in UPPERCASE format, collect an info that the keys needs to follow the dart convention.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              UPPERCASE: String
            ''',
          ).build()
        ];
        var collector = CodeGenerationCollector();
        StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'Field names should be valid Dart variable names (e.g. camelCaseString).',
        );
      },
    );

    test(
      'Given a class with a field key that is in PascalCase format, collect an info that the keys needs to follow the dart convention.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              PascalCase: String
            ''',
          ).build()
        ];
        var collector = CodeGenerationCollector();
        StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'Field names should be valid Dart variable names (e.g. camelCaseString).',
        );
      },
    );

    test(
      'Given a class with a field key that is in snake_case format, collect an info that the keys needs to follow the dart convention.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              snake_case: String
            ''',
          ).build()
        ];
        var collector = CodeGenerationCollector();
        StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

        expect(collector.errors, isNotEmpty,
            reason: 'Expected an error but none was generated.');

        var error = collector.errors.first;
        expect(
          error.message,
          'Field names should be valid Dart variable names (e.g. camelCaseString).',
        );
      },
    );

    test(
      'Given a class with a valid field key, then an entity with that field is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: String
            ''',
          ).build()
        ];
        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          models,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();
        var definition = definitions.first as ClassDefinition;

        expect(definition.fields.first.name, 'name');
      },
    );
  });

  test(
    'Given a class with a duplicated field name, then an error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            duplicatedField: String
            duplicatedField: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error to be collected, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'Duplicate mapping key.',
        reason:
            'Expected the error message to indicate a duplicate mapping key.',
      );
    },
  );
}

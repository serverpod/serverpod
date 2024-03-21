import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('serverOnly property tests', () {
    test(
        'Given a class defined to serverOnly, then the serverOnly property is set to true.',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        serverOnly: true
        fields:
          name: String
        ''',
        ).build()
      ];

      var models = StatefulAnalyzer(config, modelSources).validateAll();

      expect(models.first.serverOnly, isTrue);
    });

    test(
        'Given a class explicitly setting serverOnly to false, then the serverOnly property is set to false.',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        serverOnly: false
        fields:
          name: String
        ''',
        ).build()
      ];

      var models = StatefulAnalyzer(config, modelSources).validateAll();

      expect(models.first.serverOnly, isFalse);
    });

    test(
        'Given a class without the serverOnly property, then the default "false" value is used.',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          name: String
        ''',
        ).build()
      ];

      var models = StatefulAnalyzer(config, modelSources).validateAll();

      expect(models.first.serverOnly, isFalse);
    });

    test(
        'Given a class with the serverOnly property set to another datatype than bool, then an error is collected notifying that the serverOnly must be a bool.',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        serverOnly: Yes
        fields:
          name: String
        ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'The value must be a boolean.');
    });

    test(
        'Given an exception with the serverOnly property set to another datatype than bool, then an error is collected notifying that the serverOnly must be a bool.',
        () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          exception: Example
          serverOnly: Yes
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'The value must be a boolean.');
    });
  });

  group('table property tests', () {
    test(
        'Given a class with a table defined, then the tableName is set in the definition.',
        () {
      var modelSources = [
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
      var models =
          StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
              .validateAll();

      var model = models.first as ClassDefinition;
      expect(model.tableName, 'example');
    });

    test(
      'Given a class with a table name in a none snake_case_format, then collect an error that snake_case must be used.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: camelCaseTable
            fields:
              name: String
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;

        expect(
          error.message,
          'The "table" property must be a snake_case_string.',
        );
      },
    );

    test(
      'Given a class with a table name is not a string, then collect an error',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: true
            fields:
              name: String
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "table" property must be a snake_case_string.',
        );
      },
    );

    test(
      'Given an exception with a table defined, then collect an error',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            exception: Example
            table: example
            fields:
              name: String
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "table" property is not allowed for exception type. Valid keys are {exception, serverOnly, fields}.',
        );
      },
    );

    test(
      'Given two classes with the same table name defined, then collect an error',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
            ''',
          ).build(),
          ModelSourceBuilder().withFileName('example2').withYaml(
            '''
            class: Example2
            table: example
            fields:
              name: String
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The table name "example" is already in use by the class "Example2".',
        );
      },
    );

    test(
        'Given a class with a table defined but without the database feature enabled then an error is given.',
        () {
      var config = GeneratorConfigBuilder().withEnabledFeatures([]).build();
      var modelSources = [
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
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first as SourceSpanSeverityException;
      expect(
        error.message,
        contains(
            'The "table" property cannot be used when the database feature is disabled.'),
      );

      expect(error.severity, SourceSpanSeverity.warning);
    });
  });

  group('Invalid properties', () {
    test(
      'Given a class with an invalid property, then collect an error that such a property is not allowed.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            invalidProperty: true
            fields:
              name: String
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          contains(
              'The "invalidProperty" property is not allowed for class type. Valid keys are'),
        );
      },
    );

    test(
      'Given an exception with indexes defined, then collect an error that indexes cannot be used together with exceptions.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            exception: ExampleException
            fields:
              name: String
            indexes:
              example_exception_idx: 
                fields: name
                unique: true
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "indexes" property is not allowed for exception type. Valid keys are {exception, serverOnly, fields}.',
        );
      },
    );

    test(
      'Given an enum with a table defined, then collect an error that table cannot be used together with enums.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            enum: Example
            table: example
            values:
              - yes
              - no
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "table" property is not allowed for enum type. Valid keys are {enum, serialized, serverOnly, values}.',
        );
      },
    );
  });
}

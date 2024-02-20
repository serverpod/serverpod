import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test('Given a class with a null value as name, then collect an error', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class:
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, models, onErrorsCollector(collector))
        .validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error but none was generated.',
    );

    var error = collector.errors.first;
    expect(error.message, 'The "class" type must be a String.');
  });

  test(
      'Given a PascalCASEString class name with several uppercase letters, then no errors are collected.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        exception: PascalCASEString
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, models, onErrorsCollector(collector))
        .validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors but some were generated.',
    );
  });

  test(
      'Given a PascalCASEString class name with several uppercase letters, then an exception with that name is generated.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        exception: PascalCASEString
        fields:
          name: String
        ''',
      ).build()
    ];

    StatefulAnalyzer analyzer = StatefulAnalyzer(config, models);

    var definitions = analyzer.validateAll();
    expect(definitions.first.className, 'PascalCASEString');
  });

  test(
      'Given a camelCase class name, then give an error indicating that PascalCase is required.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: exampleClass
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, models, onErrorsCollector(collector))
        .validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error but none was generated.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'The "class" type must be a valid class name (e.g. PascalCaseString).',
    );
  });

  test(
    'Given a snake_case exception name, then give an error indicating that PascalCase is required.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          exception: example_class
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The "exception" type must be a valid class name (e.g. PascalCaseString).',
      );
    },
  );

  test(
    'Given an enum name with a leading number, then give an error indicating that PascalCase is required.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          enum: 1ExampleType
          values:
            - yes
            - no
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The "enum" type must be a valid class name (e.g. PascalCaseString).',
      );
    },
  );

  test(
    'Given a class name with reserved value List, then give an error that the class name is reserved.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: List
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The class name "List" is reserved and cannot be used.',
      );
    },
  );

  test(
    'Given a class name with reserved value Map, then give an error that the class name is reserved.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Map
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The class name "Map" is reserved and cannot be used.',
      );
    },
  );

  test(
    'Given a class name with reserved value String, then give an error that the class name is reserved.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: String
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The class name "String" is reserved and cannot be used.',
      );
    },
  );

  test(
    'Given a class name with reserved value DateTime, then give an error that the class name is reserved.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: DateTime
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The class name "DateTime" is reserved and cannot be used.',
      );
    },
  );

  group('Given a model without any defined model type', () {
    test(
      'Then return a human readable error message informing the user that the model type is missing.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            invalid: Type
            fields:
              name: String
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'No {class, exception, enum} type is defined.',
        );
      },
    );
  });

  group('Given a model with class and exception type defined.', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
exception: ExampleException
fields:
  name: String
''',
      ).build()
    ];
    var collector = CodeGenerationCollector();

    test('Then return a human readable error message when analyzing.', () {
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'Multiple model types ("class", "exception") found for a single model. Only one type per model allowed.',
      );
    });

    test('Then the second type is highlighted.', () {
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var span = collector.errors.first.span;

      expect(span?.start.line, 1);
      expect(span?.start.column, 0);

      expect(span?.end.line, 1);
      expect(span?.end.column, 'exception'.length);
    });
  });

  group('Given a model with exception and enum type defined', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        exception: ExampleException
        enum: ExampleType
        fields:
          name: String
        ''',
      ).build()
    ];
    var collector = CodeGenerationCollector();

    test('then return a human readable error message when analyzing.', () {
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'Multiple model types ("exception", "enum") found for a single model. Only one type per model allowed.',
      );
    });
  });

  group('Given a model with three different types defined.', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
exception: ExampleException
enum: ExampleType
fields:
  name: String
''',
      ).build()
    ];
    var collector = CodeGenerationCollector();

    test('then return a human readable error message when analyzing.', () {
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'Multiple model types ("class", "exception", "enum") found for a single model. Only one type per model allowed.',
      );
    });

    test('then the second and third type is highlighted.', () {
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        hasLength(greaterThan(1)),
        reason: 'Expected more than one error but got less.',
      );

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

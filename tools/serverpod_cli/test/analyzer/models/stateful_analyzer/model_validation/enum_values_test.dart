import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given an enum without a values property, then collect an error that the values property is required.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'No "values" property is defined.');
    },
  );

  test(
    'Given an enum with an empty values property, then collect an error that values must be defined.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          values:
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'The "values" property must be a list of strings.');
    },
  );

  test(
    'Given an enum with the values property defined as a map, then collect an error that values must be a list.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          values:
            value1: 1
            value2: 2
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'The "values" property must be a list of strings.');
    },
  );

  test(
    'Given an enum with the values with none string values, then collect an error that values must be a list of strings.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        enum: ExampleEnum
        values:
          - 1
          - 2
        ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'The "values" property must be a list of strings.');
    },
  );

  test(
    'Given an enum with an invalid enum string structure, then collect an error that the string must follow the required syntax.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          values:
            - Invalid-Value
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'Enum values must be lowerCamelCase.');
    },
  );

  test(
    'Given an enum with two duplicated entries, then collect an error that the enum values must be unique.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          values:
            - duplicated
            - duplicated
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        hasLength(greaterThan(1)),
        reason: 'Expected an error per duplicate value.',
      );

      var error1 = collector.errors.first;
      var error2 = collector.errors.last;

      expect(error1.message, 'Enum values must be unique.');
      expect(error2.message, 'Enum values must be unique.');
    },
  );

  test(
    'Given a value with multiple uppercase chars after a lowercase, no errors is given.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          values:
            - lowerCAPS
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors.',
      );
    },
  );

  test('Given a value with a single uppercase char, no errors is given.', () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        values:
          - M
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors.',
    );
  });

  test('Given a value with snake_case value, an error of info level is given.',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        values:
          - snake_case
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error with info.',
    );

    var error = collector.errors.first as SourceSpanSeverityException;
    expect(error.message, 'Enum values should be lowerCamelCase.');

    expect(error.severity, SourceSpanSeverity.info);
  });

  test('Given a value with PascalCase value, an error of info level is given.',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        values:
          - PascalCase
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error with info.',
    );

    var error = collector.errors.first as SourceSpanSeverityException;
    expect(error.message, 'Enum values should be lowerCamelCase.');

    expect(error.severity, SourceSpanSeverity.info);
  });

  test('Given a value with UPPERCASE value, an error of info level is given.',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml('''
enum: ExampleEnum
values:
  - UPPERCASE
''').build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(modelSources, onErrorsCollector(collector)).validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error with info.',
    );

    var error = collector.errors.first as SourceSpanSeverityException;
    expect(error.message, 'Enum values should be lowerCamelCase.');

    expect(error.severity, SourceSpanSeverity.info);
  });

  test(
      'Given a valid enum with two values, then the enum definition should contain two values.',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as EnumDefinition;
    expect(definition.values.first.name, 'first');
    expect(definition.values.last.name, 'second');
  });
}

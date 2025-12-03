import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class without a table when partitionBy is defined', () {
    test(
      'then collect an error that table is required.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: String
            partitionBy: name
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "partitionBy" property requires a table to be set on the class.',
        );
      },
    );
  });

  group('Given a class with a table when partitionBy is defined', () {
    test(
      'with a valid field name then no error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
            partitionBy: name
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors but found: ${collector.errors}',
        );
      },
    );

    test(
      'with multiple valid field names then no error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
              category: String
            partitionBy: name, category
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors but found: ${collector.errors}',
        );
      },
    );

    test(
      'with a field that does not exist then collect an error.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
            partitionBy: missingField
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The field name "missingField" is not added to the class or has a !persist scope.',
        );
      },
    );

    test(
      'with a field that has !persist scope then collect an error.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
              apiField: String, !persist
            partitionBy: apiField
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.last;
        expect(
          error.message,
          'The field name "apiField" is not added to the class or has a !persist scope.',
        );
      },
    );

    test(
      'with duplicated field names then collect an error.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
            partitionBy: name, name
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'Duplicated field name "name", can only reference a field once in partitionBy.',
        );
      },
    );

    test(
      'with empty value then collect an error.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
            partitionBy:
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "partitionBy" property must have at least one field (e.g. partitionBy: fieldName).',
        );
      },
    );
  });

  group(
      'Given a class with a partitioned table and a unique index that includes a partition column',
      () {
    test(
      'when the unique index includes all partition columns then no error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
              source: String
            partitionBy: source
            indexes:
              example_unique_idx:
                fields: name, source
                unique: true
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors but found: ${collector.errors}',
        );
      },
    );

    test(
      'when the unique index is missing some partition columns then collect an error.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
              source: String
              category: String
            partitionBy: source, category
            indexes:
              example_unique_idx:
                fields: name, source
                unique: true
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          contains('Unique index "example_unique_idx" includes partition column(s) but not all'),
        );
        expect(error.message, contains('category'));
      },
    );

    test(
      'when the unique index does not include any partition columns then no error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
              source: String
            partitionBy: source
            indexes:
              example_unique_idx:
                fields: name
                unique: true
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors but found: ${collector.errors}',
        );
      },
    );

    test(
      'when a non-unique index includes some partition columns then no error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
              source: String
              category: String
            partitionBy: source, category
            indexes:
              example_idx:
                fields: name, source
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors but found: ${collector.errors}',
        );
      },
    );
  });
}

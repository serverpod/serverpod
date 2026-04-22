import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with a Decimal field', () {
    test(
      'when Decimal has no parameters then no errors are generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              amount: Decimal
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when Decimal is nullable then no errors are generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              amount: Decimal?
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when Decimal has valid precision and scale (10,2) then no errors are generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              price: Decimal(10,2)
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when nullable Decimal has valid precision and scale (10,2)? then no errors are generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              price: Decimal(10,2)?
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when Decimal has valid precision only (19) then no errors are generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              value: Decimal(19)
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when precision is 0 then an error is collected.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              price: Decimal(0,2)
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error, but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'Invalid decimal precision "0". '
          'Precision must be an integer greater than 0.',
        );
      },
    );

    test(
      'when scale is negative then an error is collected.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              price: Decimal(10,-1)
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error, but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'Invalid decimal scale "-1". '
          'Scale must be an integer greater than or equal to 0.',
        );
      },
    );

    test(
      'when scale is greater than precision then an error is collected.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              price: Decimal(10,11)
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error, but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'Invalid decimal scale "11". '
          'Scale must be less than or equal to precision "10".',
        );
      },
    );

    test(
      'when scale equals precision then no errors are generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              value: Decimal(5,5)
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when precision is 1 and scale is 0 then no errors are generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              digit: Decimal(1,0)
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isEmpty);
      },
    );
  });
}

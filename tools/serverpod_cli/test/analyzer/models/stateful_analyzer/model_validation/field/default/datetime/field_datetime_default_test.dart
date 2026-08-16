import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with fields with a "default" keyword', () {
    test(
      'when the field is of type DateTime and the default is set to "now", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeType: DateTime, default=now
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, 'now');
        expect(definition.fields.last.defaultPersistValue, 'now');
      },
    );

    test(
      'when the field is of type DateTime and the default is set to UTC format string, then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeType: DateTime, default=2024-05-24T22:00:00.000Z
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;

        expect(
          definition.fields.last.defaultModelValue,
          '2024-05-24T22:00:00.000Z',
        );
        expect(
          definition.fields.last.defaultPersistValue,
          '2024-05-24T22:00:00.000Z',
        );
      },
    );

    test(
      'when the field is of type DateTime and the default is empty, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeType: DateTime, default=
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid UTC DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with an invalid default value "NOW", then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          dateTimeInvalid: DateTime?, default=NOW
        ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with an invalid default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeInvalid: DateTime?, default=test
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with Date without Time default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeNonUtc: DateTime?, default=2024-06-06
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var secondError = collector.errors.first as SourceSpanSeverityException;
        expect(
          secondError.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with non-UTC defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeNonUtc: DateTime?, default=2024-05-24T22:00:00.000
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var secondError = collector.errors.first as SourceSpanSeverityException;
        expect(
          secondError.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with an invalid day in the default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          dateTimeInvalidDay: DateTime?, default=2024-06-34
        ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with an invalid month in the default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          dateTimeInvalidMonth: DateTime?, default=2024-13-24
        ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with an invalid hour in the default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          dateTimeInvalidHour: DateTime, default=2024-05-24T25:00:00.000Z
        ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with an invalid minute in the default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          dateTimeInvalidMinute: DateTime, default=2024-05-24T22:61:00.000Z
        ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with an invalid second in the default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          dateTimeInvalidSecond: DateTime, default=2024-05-24T22:00:61.000Z
        ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with an invalid millisecond in the default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          dateTimeInvalidMillisecond: DateTime, default=2024-05-24T22:00:00.1000Z
        ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The "default" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );
  });
}

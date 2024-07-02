import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with fields with a "defaultModel" keyword', () {
    test(
      'when the field is of type DateTime and the default is set to "now", then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeType: DateTime, defaultModel=now
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, 'now');
      },
    );

    test(
      'when the field is of type DateTime and the default is set to UTC format string, then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeType: DateTime, defaultModel=2024-05-24T22:00:00.000Z
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;

        expect(
          definition.fields.last.defaultModelValue,
          '2024-05-24T22:00:00.000Z',
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
          dateTimeInvalid: DateTime?, defaultModel=NOW
        ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
            dateTimeInvalid: DateTime?, defaultModel=test
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
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
            dateTimeNonUtc: DateTime?, defaultModel=2024-06-06
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var secondError = collector.errors.first as SourceSpanSeverityException;
        expect(
          secondError.message,
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
            dateTimeNonUtc: DateTime?, defaultModel=2024-05-24T22:00:00.000
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var secondError = collector.errors.first as SourceSpanSeverityException;
        expect(
          secondError.message,
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidDay: DateTime?, defaultModel=2024-06-34
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
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidMonth: DateTime?, defaultModel=2024-13-24
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
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidHour: DateTime, defaultModel=2024-05-24T25:00:00.000Z
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
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidMinute: DateTime, defaultModel=2024-05-24T22:61:00.000Z
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
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidSecond: DateTime, defaultModel=2024-05-24T22:00:61.000Z
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
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidMillisecond: DateTime, defaultModel=2024-05-24T22:00:00.1000Z
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
          'The "defaultModel" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of an unsupported type String with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            stringType: String, defaultModel=test
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
          'The "defaultModel" key is not supported for "String" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type int with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            intType: int, defaultModel=test
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
          'The "defaultModel" key is not supported for "int" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type double with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            doubleType: double, defaultModel=test
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
          'The "defaultModel" key is not supported for "double" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type bool with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            boolType: bool, defaultModel=test
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
          'The "defaultModel" key is not supported for "bool" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type Duration with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            durationType: Duration, defaultModel=test
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
          'The "defaultModel" key is not supported for "Duration" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type ByteData with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            byteDataType: ByteData, defaultModel=test
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
          'The "defaultModel" key is not supported for "ByteData" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type UuidValue with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidValueType: UuidValue, defaultModel=test
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
          'The "defaultModel" key is not supported for "UuidValue" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type Map with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            mapType: Map<String, int>, defaultModel=test
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
          'The "defaultModel" key is not supported for "Map" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type List with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            listType: List<int>, defaultModel=test
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
          'The "defaultModel" key is not supported for "List" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type Example with a defaultModel value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            classType: Example, defaultModel=test
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
          'The "defaultModel" key is not supported for "Example" types',
        );
      },
    );
  });
}

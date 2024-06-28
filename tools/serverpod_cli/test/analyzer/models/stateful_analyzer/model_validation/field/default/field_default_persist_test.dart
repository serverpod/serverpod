import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  group('Given a class with fields with a "defaultPersist" keyword', () {
    test(
      'when the field is of type DateTime and the default is set to "now", then the field should have a "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeType: DateTime?, defaultPersist=now
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultPersistValue, 'now');
      },
    );

    test(
      'when the field is of type DateTime and the default is set to UTC format string, then the field should have a "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeType: DateTime?, defaultPersist=2024-05-24T22:00:00.000Z
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
          definition.fields.last.defaultPersistValue,
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
          dateTimeInvalid: DateTime?, defaultPersist=NOW
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime with an invalid defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeInvalid: DateTime?, defaultPersist=test
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
            dateTimeNonUtc: DateTime?, defaultPersist=2024-06-06
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
            dateTimeNonUtc: DateTime?, defaultPersist=2024-05-24T22:00:00.000
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidDay: DateTime?, defaultPersist=2024-06-34
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidMonth: DateTime?, defaultPersist=2024-13-24
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidHour: DateTime?,  defaultPersist=2024-05-24T25:00:00.000Z
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidMinute: DateTime?, defaultPersist=2024-05-24T22:61:00.000Z
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidSecond: DateTime?, defaultPersist=2024-05-24T22:00:61.000Z
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
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
          dateTimeInvalidMillisecond: DateTime?, defaultPersist=2024-05-24T22:00:00.1000Z
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
          'The "defaultPersist" value must be a valid UTC (yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\') DateTime String or "now"',
        );
      },
    );

    test(
      'when the field is of type DateTime non-nullable type, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeType: DateTime, defaultPersist=now
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
          'When setting only the "defaultPersist" key, its type should be nullable',
        );
      },
    );

    test(
      'when the field has the "!persist" keyword, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            dateTimeType: DateTime?, defaultPersist=now, !persist
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
          'The "defaultPersist" property is mutually exclusive with the "!persist" property.',
        );
      },
    );

    test(
      'when the field is of an unsupported type String with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            stringType: String?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "String" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type int with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            intType: int?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "int" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type double with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            doubleType: double?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "double" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type bool with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            boolType: bool?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "bool" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type Duration with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            durationType: Duration?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "Duration" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type ByteData with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            byteDataType: ByteData?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "ByteData" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type UuidValue with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidValueType: UuidValue?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "UuidValue" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type Map with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            mapType: Map<String, int>?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "Map" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type List with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            listType: List<int>?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "List" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type Example with a defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            classType: Example?, defaultPersist=test
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
          'The "defaultPersist" key is not supported for "Example" types',
        );
      },
    );
  });
}

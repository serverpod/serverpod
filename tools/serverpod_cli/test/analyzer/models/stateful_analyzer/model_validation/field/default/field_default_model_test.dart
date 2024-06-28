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
            dateTimeType: DateTime, defaultModel=2024-05-34T22:00:00.000Z
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
          '2024-05-34T22:00:00.000Z',
        );
        expect(
          definition.fields.last.defaultPersistValue,
          '2024-05-34T22:00:00.000Z',
        );
      },
    );

    test(
      'when the field is of a supported type with an invalid value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              dateTimeInvalid: DateTime?, defaultModel=test
              dateTimeNonUtc: DateTime?, defaultModel=2024-06-06
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(firstError.message,
            'The "defaultModel" value must be a valid UTC DateTime String or "now"');

        var secondError = collector.errors.last as SourceSpanSeverityException;
        expect(secondError.message,
            'The "defaultModel" value should be a valid UTC DateTime.');
      },
    );

    test(
      'when the field is of an unsupported type, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              stingType: String, defaultModel=test
              intType: int, defaultModel=test
              doubleType: double, defaultModel=test
              boolType: bool, defaultModel=test
              durationType: Duration, defaultModel=test
              byteDataType: ByteData, defaultModel=test
              uuidValueType: UuidValue, defaultModel=test
              mapType: Map<String, int>, defaultModel=test
              listype: List<int>, defaultModel=test
              classType: Example, defaultModel=test
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        var errors = List<SourceSpanSeverityException>.from(collector.errors);

        var errorMessages = [
          'The "defaultModel" key is not supported for "String" types',
          'The "defaultModel" key is not supported for "int" types',
          'The "defaultModel" key is not supported for "double" types',
          'The "defaultModel" key is not supported for "bool" types',
          'The "defaultModel" key is not supported for "Duration" types',
          'The "defaultModel" key is not supported for "ByteData" types',
          'The "defaultModel" key is not supported for "UuidValue" types',
          'The "defaultModel" key is not supported for "Map" types',
          'The "defaultModel" key is not supported for "List" types',
          'The "defaultModel" key is not supported for "Example" types',
        ];

        expect(errors.length, errorMessages.length);

        for (var error in errors) {
          expect(error.severity, SourceSpanSeverity.error);
          expect(error.message, errorMessages[errors.indexOf(error)]);
        }
      },
    );
  });
}

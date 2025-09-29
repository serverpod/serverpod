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
      'when the field is of type BigInt and the default is set to "10", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, default="10"
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, '10');
        expect(definition.fields.last.defaultPersistValue, '10');
      },
    );

    test(
      'when the field is of type BigInt and the default is set to "10", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, default='10'
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, '10');
        expect(definition.fields.last.defaultPersistValue, '10');
      },
    );

    test(
      'when the field is of type BigInt and the default is set to 20, then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, default=20
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;

        expect(definition.fields.last.defaultModelValue, '20');
        expect(definition.fields.last.defaultPersistValue, '20');
      },
    );

    test(
      'when the field is of type BigInt and the default is set to "99999999999999999999999", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, default="99999999999999999999999"
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
          '99999999999999999999999',
        );
        expect(
          definition.fields.last.defaultPersistValue,
          '99999999999999999999999',
        );
      },
    );

    test(
      'when the field is of type BigInt and the default is set to an unquoted larger than 64 bit integer, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, default=9999999999999999999999999
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
          'The "default" value must be a valid BigInt (e.g., default="1234567890").',
        );
      },
    );

    test(
      'when the field is of type BigInt and the default is empty, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, default=
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
          'The "default" value must be a valid BigInt (e.g., default="1234567890").',
        );
      },
    );

    test(
      'when the field is of type BigInt with an invalid default value "TEN", then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          bigIntInvalid: BigInt?, default=TEN
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
          'The "default" value must be a valid BigInt (e.g., default="1234567890").',
        );
      },
    );

    test(
      'when the field is of type BigInt with an invalid default value containing decimals, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          bigIntInvalid: BigInt?, default=10.5
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
          'The "default" value must be a valid BigInt (e.g., default="1234567890").',
        );
      },
    );

    test(
      'when the field is of type BigInt with an invalid default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntInvalid: BigInt?, default=test
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
          'The "default" value must be a valid BigInt (e.g., default="1234567890").',
        );
      },
    );
  });
}

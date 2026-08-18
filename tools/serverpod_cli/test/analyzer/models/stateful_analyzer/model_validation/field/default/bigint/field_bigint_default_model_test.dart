import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with fields with a "defaultModel" keyword', () {
    test(
      'when the field is of type BigInt and the defaultModel is set to "10", then the field should have a "default model" value and not have a "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, defaultModel=10
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
        expect(definition.fields.last.defaultModelValue, '10');
        expect(definition.fields.last.defaultPersistValue, isNull);
      },
    );

    test(
      'when the field is of type BigInt and the defaultModel is set to a negative value "-10", then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, defaultModel=-10
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
        expect(definition.fields.last.defaultModelValue, '-10');
      },
    );

    test(
      'when the field is of type BigInt and the defaultModel is set to a value larger than 64 bits, then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, defaultModel=9999999999999999999999999
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
          '9999999999999999999999999',
        );
      },
    );

    test(
      'when the field is of type BigInt with a defaultModel value in single quotes, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, defaultModel='10'
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
          'The "defaultModel" value must be a valid BigInt (e.g., "defaultModel"=\'1234567890\').',
        );
      },
    );

    test(
      'when the field is of type BigInt with a defaultModel value in double quotes, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, defaultModel="10"
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
          'The "defaultModel" value must be a valid BigInt (e.g., "defaultModel"=\'1234567890\').',
        );
      },
    );

    test(
      'when the field is of type BigInt and the defaultModel is empty, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntType: BigInt, defaultModel=
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
          'The "defaultModel" value must be a valid BigInt (e.g., "defaultModel"=\'1234567890\').',
        );
      },
    );

    test(
      'when the field is of type BigInt with an invalid defaultModel value "TEN", then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntInvalid: BigInt, defaultModel=TEN
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
          'The "defaultModel" value must be a valid BigInt (e.g., "defaultModel"=\'1234567890\').',
        );
      },
    );

    test(
      'when the field is of type BigInt with an invalid defaultModel value containing decimals, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            bigIntInvalid: BigInt, defaultModel=10.5
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
          'The "defaultModel" value must be a valid BigInt (e.g., "defaultModel"=\'1234567890\').',
        );
      },
    );
  });
}

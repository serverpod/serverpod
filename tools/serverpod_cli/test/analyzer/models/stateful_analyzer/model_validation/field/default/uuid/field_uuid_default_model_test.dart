import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with fields with a "defaultModel" keyword', () {
    test(
      'when the field is of type UUID and the defaultModel is set to "random", then the field\'s default model value is "random".',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidType: UuidValue, defaultModel=random
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, 'random');
      },
    );

    test(
      'when the field is of type UUID and the defaultModel is set to a valid UUID string with single quotes, then the field\'s default model value is the provided UUID string.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidType: UuidValue, defaultModel='550e8400-e29b-41d4-a716-446655440000'
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
          '\'550e8400-e29b-41d4-a716-446655440000\'',
        );
      },
    );

    test(
      'when the field is of type UUID and the defaultModel is set to a valid UUID string with double quotes, then the field\'s default model value is the provided UUID string converted to single quotes.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidType: UuidValue, defaultModel="550e8400-e29b-41d4-a716-446655440000"
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
          '\'550e8400-e29b-41d4-a716-446655440000\'',
        );
      },
    );

    test(
      'when the field is of type UUID and the defaultModel is empty, then an error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidType: UuidValue, defaultModel=
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
          'The "defaultModel" value must be a "random" or valid UUID string (e.g., "defaultModel"=random or "defaultModel"=\'550e8400-e29b-41d4-a716-446655440000\').',
        );
      },
    );

    test(
      'when the field is of type UUID with an invalid defaultModel value, then an error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          uuidInvalid: UuidValue?, defaultModel=INVALID_UUID
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
          'The "defaultModel" value must be a "random" or valid UUID string (e.g., "defaultModel"=random or "defaultModel"=\'550e8400-e29b-41d4-a716-446655440000\').',
        );
      },
    );

    test(
      'when the field is of type UUID with a malformed UUID in single quotes, then an error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidMalformed: UuidValue?, defaultModel='550e8400-e29b-41d4-a716-INVALID'
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
          'The "defaultModel" value must be a valid UUID (e.g., \'550e8400-e29b-41d4-a716-446655440000\').',
        );
      },
    );

    test(
      'when the field is of type UUID with a malformed UUID in double quotes, then an error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidMalformed: UuidValue?, defaultModel="550e8400-e29b-41d4-a716-INVALID"
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
          'The "defaultModel" value must be a valid UUID (e.g., \'550e8400-e29b-41d4-a716-446655440000\').',
        );
      },
    );

    test(
      'when the field is of type UUID with an invalid character in the defaultModel value, then an error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          uuidInvalidChar: UuidValue?, defaultModel='550e8400-e29b-41d4-a716-44665544000G'
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
          'The "defaultModel" value must be a valid UUID (e.g., \'550e8400-e29b-41d4-a716-446655440000\').',
        );
      },
    );
  });

  test(
    'Given a class with a declared id field of type UUID with a "defaultModel" keyword, then an error is collected',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            id: UuidValue, defaultModel=random
          ''',
        ).build()
      ];

      var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
        [ExperimentalFeature.changeIdType],
      ).build();

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors.first.message,
        'The "defaultModel" key is not allowed on the "id" field. '
        'Use the "default" key instead.',
      );
    },
  );
}

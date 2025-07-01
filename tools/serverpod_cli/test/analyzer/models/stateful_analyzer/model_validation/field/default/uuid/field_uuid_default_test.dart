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
      'when the field is of type UUID and the default is set to "random", then the field\'s default model and persist values are "random".',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidType: UuidValue, default=random
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
        expect(definition.fields.last.defaultPersistValue, 'random');
      },
    );

    test(
      'when the field is of type UUID and the default is set to "random_v7", then the field\'s default model and persist values are "random_v7".',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidType: UuidValue, default=random_v7
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, 'random_v7');
        expect(definition.fields.last.defaultPersistValue, 'random_v7');
      },
    );

    test(
      'when the field is of type UUID and the default is set to a valid UUID string with single quotes, then the field\'s default model and persist values are the provided UUID string.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidType: UuidValue, default='550e8400-e29b-41d4-a716-446655440000'
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
        expect(
          definition.fields.last.defaultPersistValue,
          '\'550e8400-e29b-41d4-a716-446655440000\'',
        );
      },
    );

    test(
      'when the field is of type UUID and the default is set to a valid UUID string with double quotes, then the field\'s default model and persist values are the provided UUID string, converted to single quotes.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidType: UuidValue, default="550e8400-e29b-41d4-a716-446655440000"
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
        expect(
          definition.fields.last.defaultPersistValue,
          '\'550e8400-e29b-41d4-a716-446655440000\'',
        );
      },
    );

    test(
      'when the field is of type UUID and the default is empty, then an error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uuidType: UuidValue, default=
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
          'The "default" value must be "random", "random_v7" or valid UUID string (e.g., "default"=random or "default"=\'550e8400-e29b-41d4-a716-446655440000\').',
        );
      },
    );

    test(
      'when the field is of type UUID with an invalid default value, then an error is generated.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          uuidInvalid: UuidValue?, default=INVALID_UUID
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
          'The "default" value must be "random", "random_v7" or valid UUID string (e.g., "default"=random or "default"=\'550e8400-e29b-41d4-a716-446655440000\').',
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
            uuidMalformed: UuidValue?, default='550e8400-e29b-41d4-a716-INVALID'
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
          'The "default" value must be a valid UUID (e.g., \'550e8400-e29b-41d4-a716-446655440000\').',
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
            uuidMalformed: UuidValue?, default="550e8400-e29b-41d4-a716-INVALID"
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
          'The "default" value must be a valid UUID (e.g., \'550e8400-e29b-41d4-a716-446655440000\').',
        );
      },
    );
  });

  test(
    'Given a class with a declared id field of type UUID with a "default" keyword, then an error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            id: UuidValue?, default=random
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors.first.message,
        'The "default" key is not allowed on the "id" field. Use either '
        'the "defaultModel" key or the "defaultPersist" key instead.',
      );
    },
  );
}

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
    'Given a class with fields with a "defaultPersist" keyword for Duration type',
    () {
      test(
        'when the field is of type Duration and the defaultPersist is set to "1d 2h 10min 30s 100ms", then the field should have a "default persist" value',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          table: example
          fields:
            durationType: Duration?, defaultPersist=1d 2h 10min 30s 100ms
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
            definition.fields.last.defaultPersistValue,
            '1d 2h 10min 30s 100ms',
          );
        },
      );

      test(
        'when the field is of type Duration and the defaultPersist is empty, then an error is generated',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          table: example
          fields:
            durationType: Duration?, defaultPersist=
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

          var firstError =
              collector.errors.first as SourceSpanSeverityException;
          expect(
            firstError.message,
            'The "defaultPersist" value must be a valid duration in the format "Xd Xh Xmin Xs Xms" (e.g., "defaultPersist"=1d 2h 30min 45s 100ms).',
          );
        },
      );

      test(
        'when the field is of type Duration with an invalid defaultPersist value "INVALID_DURATION", then an error is generated',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
        class: Example
        table: example
        fields:
          durationInvalid: Duration?, defaultPersist=INVALID_DURATION
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

          var firstError =
              collector.errors.first as SourceSpanSeverityException;
          expect(
            firstError.message,
            'The "defaultPersist" value must be a valid duration in the format "Xd Xh Xmin Xs Xms" (e.g., "defaultPersist"=1d 2h 30min 45s 100ms).',
          );
        },
      );

      test(
        'when the field is of type Duration with an invalid defaultPersist value containing an incorrect format, then an error is generated',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
        class: Example
        table: example
        fields:
          durationInvalid: Duration?, defaultPersist=10 hours
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

          var firstError =
              collector.errors.first as SourceSpanSeverityException;
          expect(
            firstError.message,
            'The "defaultPersist" value must be a valid duration in the format "Xd Xh Xmin Xs Xms" (e.g., "defaultPersist"=1d 2h 30min 45s 100ms).',
          );
        },
      );

      test(
        'when the field is of type Duration non-nullable type, then an error is generated',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          table: example
          fields:
            durationType: Duration, defaultPersist=1d 2h 10min 30s 100ms
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
            durationType: Duration?, defaultPersist=1d 2h 10min 30s 100ms, !persist
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
            'The "defaultPersist" property is mutually exclusive with the "!persist" property.',
          );
        },
      );
    },
  );
}

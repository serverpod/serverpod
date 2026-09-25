import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
    'Given a class with a field of an invalid type with a "defaultPersist" keyword',
    () {
      test(
        'when the type is an unknown primitive-like name, then no "not supported" error is generated but other diagnostics are kept',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          table: example
          fields:
            intType: Int, defaultPersist=1
          ''',
            ).build(),
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(
            config,
            models,
            onErrorsCollector(collector),
          ).validateAll();

          var errorMessages = collector.errors
              .map((error) => (error as SourceSpanSeverityException).message)
              .toList();

          expect(
            errorMessages,
            isNot(
              contains(
                'The "defaultPersist" key is not supported for "Int" types',
              ),
            ),
          );
          expect(
            errorMessages,
            contains('The field has an invalid datatype "Int".'),
          );
          expect(
            errorMessages,
            contains(
              'When setting only the "defaultPersist" key, its type should be '
              'nullable',
            ),
          );
        },
      );

      test(
        'when the field also has the "!persist" keyword, then the mutually exclusive error is still generated',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          table: example
          fields:
            intType: Int, defaultPersist=1, !persist
          ''',
            ).build(),
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(
            config,
            models,
            onErrorsCollector(collector),
          ).validateAll();

          var errorMessages = collector.errors
              .map((error) => (error as SourceSpanSeverityException).message)
              .toList();

          expect(
            errorMessages,
            contains(
              'The "defaultPersist" property is mutually exclusive with the '
              '"!persist" property.',
            ),
          );
          expect(
            errorMessages,
            isNot(
              contains(
                'The "defaultPersist" key is not supported for "Int" types',
              ),
            ),
          );
        },
      );
    },
  );
}

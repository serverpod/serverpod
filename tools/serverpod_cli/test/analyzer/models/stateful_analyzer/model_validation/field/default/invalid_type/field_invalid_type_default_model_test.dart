import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
    'Given a class with a field of an invalid type with a "defaultModel" keyword',
    () {
      test(
        'when the type is an unknown primitive-like name, then only the invalid datatype error is generated',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          fields:
            intType: Int, defaultModel=1
          ''',
            ).build(),
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(
            config,
            models,
            onErrorsCollector(collector),
          ).validateAll();

          expect(collector.errors, hasLength(1));

          var error = collector.errors.first as SourceSpanSeverityException;
          expect(
            error.message,
            'The field has an invalid datatype "Int".',
          );
        },
      );

      test(
        'when the type is an unknown class name, then only the invalid datatype error is generated',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          fields:
            classType: UnknownClass, defaultModel=test
          ''',
            ).build(),
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(
            config,
            models,
            onErrorsCollector(collector),
          ).validateAll();

          expect(collector.errors, hasLength(1));

          var error = collector.errors.first as SourceSpanSeverityException;
          expect(
            error.message,
            'The field has an invalid datatype "UnknownClass".',
          );
        },
      );
    },
  );
}

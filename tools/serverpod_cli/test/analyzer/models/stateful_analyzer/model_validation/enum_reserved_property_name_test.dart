import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
    'Given an enum with a reserved keyword as property name when parsing',
    () {
      late CodeGenerationCollector collector;

      setUp(() {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          enum: ExampleEnum
          properties:
            class: int
          values:
            - first:
                class: 1
          ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then an error is collected.', () {
        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error for reserved keyword.',
        );
      });

      test('then the error message identifies the reserved keyword.', () {
        var error = collector.errors.first;
        expect(
          error.message,
          'The enum property name "class" is reserved and cannot be used.',
        );
      });
    },
  );
}

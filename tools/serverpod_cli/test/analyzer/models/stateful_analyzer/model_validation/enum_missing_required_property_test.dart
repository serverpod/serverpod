import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given an enum value missing a required property when parsing', () {
    late CodeGenerationCollector collector;

    setUp(() {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          properties:
            id: int
            name: String
          values:
            - first:
                id: 1
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
        reason: 'Expected an error for missing required property.',
      );
    });

    test('then the error message identifies the missing property and value.',
        () {
      var error = collector.errors.first;
      expect(
        error.message,
        'Required property "name" is missing for enum value "first".',
      );
    });
  });
}

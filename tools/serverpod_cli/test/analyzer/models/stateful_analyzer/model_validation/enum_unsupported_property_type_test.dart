import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given an enum with an unsupported property type when parsing', () {
    late CodeGenerationCollector collector;

    setUp(() {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          properties:
            data: List<String>
          values:
            - first:
                data: []
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
        reason: 'Expected an error for unsupported type.',
      );
    });

    test('then the error message describes the unsupported type.', () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The property type "List<String>" is not supported. '
        'Supported types are: int, double, bool, String.',
      );
    });
  });
}

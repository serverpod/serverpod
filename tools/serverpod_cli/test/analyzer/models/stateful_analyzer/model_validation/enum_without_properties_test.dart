import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given an enum without properties', () {
    test(
      'when enum definition has no properties, then isEnhanced returns false.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
            enum: ExampleEnum
            values:
              - first
              - second
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        );

        var definitions = analyzer.validateAll();

        var definition = definitions.first as EnumDefinition;
        expect(definition.isEnhanced, isFalse);
        expect(definition.properties, isEmpty);
      },
    );
  });
}

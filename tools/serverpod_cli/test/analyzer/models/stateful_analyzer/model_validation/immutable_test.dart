import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a class defined to immutable, then the immutable property is set to true.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        immutable: true
        fields:
          name: String
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      var model = models.first as ModelClassDefinition;
      expect(model.isImmutable, equals(true));
    },
  );

  test(
    'Given a class explicitly setting immutable to false, then the immutable property is set to false.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        immutable: false
        fields:
          name: String
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      var model = models.first as ModelClassDefinition;
      expect(model.isImmutable, equals(false));
    },
  );

  test(
    'Given a class without the immutable property, then the default "false" value is used.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          name: String
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      var model = models.first as ModelClassDefinition;
      expect(model.isImmutable, equals(false));
    },
  );
}

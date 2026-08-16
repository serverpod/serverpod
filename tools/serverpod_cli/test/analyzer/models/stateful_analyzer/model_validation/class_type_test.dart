import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a class is parsed from a yaml file, Then the type-class-name equals the class-name',
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

      var model = models.first as ClassDefinition;
      expect(model.type.className, model.className);
    },
  );

  test(
    'Given an enum is parsed from a yaml file, Then the type-class-name equals the class-name and the enum-definition is set',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        enum: ExampleEnum
        values:
          - value1
          - value2
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      var model = models.first as EnumDefinition;

      expect(model.type.className, model.className);
      expect(model.type.enumDefinition, model);
      expect(model.defaultValue, isNull);
      expect(model.serialized, EnumSerialization.byName);
    },
  );

  test(
    'Given an exception parsed from a yaml file, Then the type-class-name equals the class-name',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        exception: Example
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

      var model = models.first as ClassDefinition;
      expect(model.type.className, model.className);
    },
  );
}

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  group('Given `serializeAsJsonb` disabled at project-level', () {
    var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
        [ExperimentalFeature.serializeAsJsonb]).build();

    group('when a class with `serializationDataType` set', () {
      test(
        'with a field with no `serializationDataType` set, then the generated field should be serialized as defined at class level.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
                class: Example
                table: example
                serializationDataType: jsonb
                fields:
                  tags: List<String>
                ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          var analyzer =
              StatefulAnalyzer(config, models, onErrorsCollector(collector));

          var definitions = analyzer.validateAll();

          var definition = definitions.first as ModelClassDefinition;
          expect(definition.fields.last.type.serializationDataType,
              SerializationDataType.jsonb);
        },
      );

      test(
        'with a field with set `serializationDataType`, then the generated field should be serialized as defined at field level.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
                class: Example
                table: example
                serializationDataType: jsonb
                fields:
                  tags: List<String>, serializationDataType=json
                ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          var analyzer =
              StatefulAnalyzer(config, models, onErrorsCollector(collector));

          var definitions = analyzer.validateAll();

          var definition = definitions.first as ModelClassDefinition;
          expect(definition.fields.last.type.serializationDataType,
              SerializationDataType.json);
        },
      );
    });
  });
}

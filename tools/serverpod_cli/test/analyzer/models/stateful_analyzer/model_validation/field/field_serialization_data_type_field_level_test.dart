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
    var config =
        GeneratorConfigBuilder().withEnabledExperimentalFeatures([ExperimentalFeature.serializeAsJsonb]).build();

    group('when a class with no `serializationDataType` set', () {
      test(
        'with a field with no `serializationDataType` set, then the generated field shouldn\'t have `serializationDataType` set resulting in the field being serialized as json.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                tags: List<String>
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          var analyzer = StatefulAnalyzer(config, models, onErrorsCollector(collector));

          var definitions = analyzer.validateAll();

          var definition = definitions.first as ModelClassDefinition;
          expect(definition.fields.last.type.serializationDataType, isNull);
        },
      );

      test(
        'with a field with `serializationDataType` set to jsonb, then the generated field should be serialized as defined at field level.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                tags: List<String>, serializationDataType=jsonb
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          var analyzer = StatefulAnalyzer(config, models, onErrorsCollector(collector));

          var definitions = analyzer.validateAll();

          var definition = definitions.first as ModelClassDefinition;
          expect(definition.fields.last.type.serializationDataType, SerializationDataType.jsonb);
        },
      );

      test(
        'with a field with `serializationDataType` set to json, then the generated field should be serialized as defined at field level.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                tags: List<String>, serializationDataType=json
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          var analyzer = StatefulAnalyzer(config, models, onErrorsCollector(collector));

          var definitions = analyzer.validateAll();

          var definition = definitions.first as ModelClassDefinition;
          expect(definition.fields.last.type.serializationDataType, SerializationDataType.json);
        },
      );

      test(
        'with a field with the `serializationDataType` key set to an invalid value, then collect an error that the value has an invalid value.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                tags: List<String>, serializationDataType=Invalid
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(config, models, onErrorsCollector(collector)).validateAll();

          expect(collector.errors, isNotEmpty);

          var error = collector.errors.last;

          expect(error.message, '"Invalid" is not a valid property. Valid properties are (json, jsonb).');
        },
      );
    });
  });
}

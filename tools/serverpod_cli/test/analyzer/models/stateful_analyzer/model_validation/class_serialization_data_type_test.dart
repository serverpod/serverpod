import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
      [ExperimentalFeature.serializeAsJsonb]).build();

  group(
      'Given class definition with no `serializationDataType` key when validating',
      () {
    var modelSources = [
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
    var analyzer =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then `serializationDataType` is set to null.', () {
      expect(definition.serializationDataType, isNull);
    });
  });

  group(
      'Given a valid class definition with `serializationDataType` set to jsonb when validating',
      () {
    var modelSources = [
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
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then `serializationDataType` is set to jsonb.', () {
      expect(definition.serializationDataType, SerializationDataType.jsonb);
    });
  });

  group(
      'Given a valid class definition with `serializationDataType` set to json when validating',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        serializationDataType: json
        fields:
          tags: List<String>
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as ModelClassDefinition;

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then `serializationDataType` is set to json.', () {
      expect(definition.serializationDataType, SerializationDataType.json);
    });
  });

  group(
      'Given a valid class definition with `serializationDataType` set to an invalid value when validating',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        serializationDataType: Invalid
        fields:
          tags: List<String>
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector));

    analyzer.validateAll();

    test(
        'then collect an error that the `serializationDataType` value is invalid.',
        () {
      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        '"Invalid" is not a valid property. Valid properties are (json, jsonb).',
      );
    });
  });
}

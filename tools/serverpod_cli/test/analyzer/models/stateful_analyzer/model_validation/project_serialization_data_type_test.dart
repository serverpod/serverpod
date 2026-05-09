import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/serialization_data_type.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder()
      .withEnabledSerializeAsJsonbByDefault()
      .build();

  test(
    'Given `serializeAsJsonbByDefault` enabled and a class without `serializationDataType` and a field without `serializationDataType`, '
    'when validating, '
    'then the field `serializationDataType` is jsonb.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        fields:
          tags: List<String>
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();

      var definition = definitions.first as ModelClassDefinition;
      expect(collector.errors, isEmpty);
      expect(
        definition.fields.last.type.serializationDataType,
        SerializationDataType.jsonb,
      );
    },
  );

  test(
    'Given `serializeAsJsonbByDefault` enabled and a class with `serializationDataType` set to json, '
    'when validating, '
    'then the field `serializationDataType` is json.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        serializationDataType: json
        fields:
          tags: List<String>
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();

      var definition = definitions.first as ModelClassDefinition;
      expect(collector.errors, isEmpty);
      expect(
        definition.fields.last.type.serializationDataType,
        SerializationDataType.json,
      );
    },
  );

  test(
    'Given `serializeAsJsonbByDefault` enabled and multiple models where only one has `serializationDataType` set, '
    'when validating, '
    'then the project default applies to the model without override and the overriding model keeps its own value.',
    () {
      var models = [
        ModelSourceBuilder().withFileName('with_override').withYaml('''
        class: WithOverride
        table: with_override
        serializationDataType: json
        fields:
          tags: List<String>
        ''').build(),
        ModelSourceBuilder().withFileName('without_override').withYaml('''
        class: WithoutOverride
        table: without_override
        fields:
          tags: List<String>
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();

      expect(collector.errors, isEmpty);

      var withOverride =
          definitions.firstWhere(
                (m) => m.className == 'WithOverride',
              )
              as ModelClassDefinition;
      var withoutOverride =
          definitions.firstWhere(
                (m) => m.className == 'WithoutOverride',
              )
              as ModelClassDefinition;

      expect(
        withOverride.fields.last.type.serializationDataType,
        SerializationDataType.json,
      );
      expect(
        withoutOverride.fields.last.type.serializationDataType,
        SerializationDataType.jsonb,
      );
    },
  );

  test(
    'Given `serializeAsJsonbByDefault` enabled and a class without `serializationDataType` and a field with `serializationDataType` set to json, '
    'when validating, '
    'then the field `serializationDataType` is json.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        fields:
          tags: List<String>, serializationDataType=json
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();

      var definition = definitions.first as ModelClassDefinition;
      expect(collector.errors, isEmpty);
      expect(
        definition.fields.last.type.serializationDataType,
        SerializationDataType.json,
      );
    },
  );

  test(
    'Given `serializeAsJsonbByDefault` enabled and a class without `serializationDataType` and a non-serializable field, '
    'when validating, '
    'then the field has no `serializationDataType` set.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        fields:
          name: String
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();

      var definition = definitions.first as ModelClassDefinition;
      expect(collector.errors, isEmpty);
      expect(
        definition.fields.last.type.serializationDataType,
        isNull,
      );
    },
  );
}

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/serialization_data_type.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a serializable field with no `serializationDataType` key, when validating, then the field `serializationDataType` is null.',
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
      expect(definition.fields.last.type.serializationDataType, isNull);
    },
  );

  test(
    'Given a serializable field with `serializationDataType` set to jsonb, when validating, then the field `serializationDataType` is jsonb.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        fields:
          tags: List<String>, serializationDataType=jsonb
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
      expect(
        definition.fields.last.type.serializationDataType,
        SerializationDataType.jsonb,
      );
    },
  );

  test(
    'Given a serializable field with `serializationDataType` set to json, when validating, then the field `serializationDataType` is json.',
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
      expect(
        definition.fields.last.type.serializationDataType,
        SerializationDataType.json,
      );
    },
  );

  test(
    'Given a serializable field with `serializationDataType` set to an invalid value, when validating, then an error about the invalid value is reported.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        fields:
          tags: List<String>, serializationDataType=Invalid
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.last.message,
        '"Invalid" is not a valid property. Valid properties are (json, jsonb).',
      );
    },
  );

  test(
    'Given a Map field with `serializationDataType` set to jsonb, '
    'when validating, '
    'then no error is reported.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        fields:
          data: Map<String, String>, serializationDataType=jsonb
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a serializable model field with `serializationDataType` set to jsonb, '
    'when validating, '
    'then no error is reported.',
    () {
      var models = [
        ModelSourceBuilder().withFileName('example').withYaml('''
        class: Example
        table: example
        fields:
          data: CustomModel, serializationDataType=jsonb
        ''').build(),
        ModelSourceBuilder().withFileName('custom_model').withYaml('''
        class: CustomModel
        fields:
          value: String
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given the id field with `serializationDataType` set, '
    'when validating, '
    'then an error is reported.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        fields:
          id: int?, defaultPersist=serial, serializationDataType=jsonb
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The "serializationDataType" key is not allowed on the "id" field.',
      );
    },
  );

  test(
    'Given a non-serializable field with `serializationDataType` set, when validating, then an error about the invalid field type is reported.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        fields:
          name: String, serializationDataType=jsonb
        ''').build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The "serializationDataType" key is only valid on serializable '
        'field types (e.g. lists, maps, serializable models or custom classes).',
      );
    },
  );
}

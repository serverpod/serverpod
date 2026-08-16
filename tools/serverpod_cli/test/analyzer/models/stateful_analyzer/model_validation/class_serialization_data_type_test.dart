import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/serialization_data_type.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a class with no `serializationDataType` key, when validating, then the class `serializationDataType` is null.',
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
      expect(definition.serializationDataType, isNull);
    },
  );

  test(
    'Given a class with `serializationDataType` set to jsonb, when validating, then the class `serializationDataType` is jsonb.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        serializationDataType: jsonb
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
      expect(definition.serializationDataType, SerializationDataType.jsonb);
    },
  );

  test(
    'Given a class with `serializationDataType` set to json, when validating, then the class `serializationDataType` is json.',
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
      expect(definition.serializationDataType, SerializationDataType.json);
    },
  );

  test(
    'Given a class with `serializationDataType` set to an invalid value, when validating, then an error about the invalid value is reported.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        serializationDataType: Invalid
        fields:
          tags: List<String>
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
        '"Invalid" is not a valid property. Valid properties are (json, jsonb).',
      );
    },
  );

  test(
    'Given a class with `serializationDataType` set to jsonb and a field without `serializationDataType`, when validating, then the field `serializationDataType` is jsonb.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        serializationDataType: jsonb
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
    'Given a class with `serializationDataType` set to jsonb and a field with `serializationDataType` set to json, when validating, then the field `serializationDataType` is json.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        serializationDataType: jsonb
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
    'Given class with `serializationDataType` set and a non-serializable field, '
    'when validating, '
    'then the field has no `serializationDataType` set.',
    () {
      var models = [
        ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        serializationDataType: jsonb
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

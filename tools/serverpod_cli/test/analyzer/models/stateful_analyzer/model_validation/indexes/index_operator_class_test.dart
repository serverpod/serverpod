import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a class with a gin index with valid operator class, then return a definition where operatorClass is correctly set.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            tags: List<String>, serializationDataType=jsonb
          indexes:
            tags_ndx:
              fields: tags
              type: gin
              operatorClass: jsonbPathOps
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but errors were collected.',
      );

      var definition = definitions.first as ModelClassDefinition;
      var operatorClass = definition.indexes.first.ginOperatorClass;

      expect(operatorClass, isNotNull);
      expect(operatorClass!.name, 'jsonbPathOps');
    },
  );

  test(
    'Given a class with a gin index and trgmOps on a String field, '
    'when the model is validated, '
    'then return a definition where operatorClass is trgmOps.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            searchText: String
          indexes:
            search_trgm_idx:
              fields: searchText
              type: gin
              operatorClass: trgmOps
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but errors were collected.',
      );

      var definition = definitions.first as ModelClassDefinition;
      var operatorClass = definition.indexes.first.ginOperatorClass;

      expect(operatorClass, isNotNull);
      expect(operatorClass!.name, 'trgmOps');
    },
  );

  test(
    'Given a class with a gin index and trgmOps on a non-String field, '
    'when the model is validated, '
    'then an error reports that trgmOps requires String fields.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            tags: List<String>, serializationDataType=jsonb
          indexes:
            tags_ndx:
              fields: tags
              type: gin
              operatorClass: trgmOps
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was collected.',
      );
      expect(
        collector.errors.first.message,
        'The "gin" index type with operator class "trgmOps" requires '
        'all indexed fields to be of type String (fields: tags).',
      );
    },
  );

  test(
    'Given an implicit gin index with trgmOps on a JSONB field, '
    'when the model is validated, '
    'then an error reports that trgmOps requires String fields.',
    () {
      var model = ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          tags: List<String>, serializationDataType=jsonb
        indexes:
          tags_ndx:
            fields: tags
            operatorClass: trgmOps
        ''',
      ).build();
      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        [model],
        onErrorsCollector(collector),
      );

      analyzer.validateAll();

      expect(
        collector.errors.map((error) => error.message),
        [
          'The "gin" index type with operator class "trgmOps" requires '
              'all indexed fields to be of type String (fields: tags).',
        ],
      );
    },
  );

  test(
    'Given a class with a gin index without operator class, then return a definition where operatorClass defaults to jsonbOps.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            tags: List<String>, serializationDataType=jsonb
          indexes:
            tags_ndx:
              fields: tags
              type: gin
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but errors were collected.',
      );

      var definition = definitions.first as ModelClassDefinition;
      var operatorClass = definition.indexes.first.ginOperatorClass;

      expect(operatorClass, isNotNull);
      expect(operatorClass!.name, 'jsonbOps');
    },
  );

  test(
    'Given a class with a gin index with invalid operator class value, then collect an error about invalid operator class value.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            tags: List<String>, serializationDataType=jsonb
          indexes:
            tags_ndx:
              fields: tags
              type: gin
              operatorClass: invalid
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was collected.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        '"invalid" is not a valid property. Valid properties are (arrayOps, jsonbOps, jsonbPathOps, tsvectorOps, trgmOps).',
      );
    },
  );

  test(
    'Given a class with a gin index with a non-string operator class, then collect an error about the invalid value.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            tags: List<String>, serializationDataType=jsonb
          indexes:
            tags_ndx:
              fields: tags
              type: gin
              operatorClass: 1
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was collected.',
      );
      expect(
        collector.errors.first.message,
        '"1" is not a valid property. Valid properties are (arrayOps, jsonbOps, jsonbPathOps, tsvectorOps, trgmOps).',
      );
    },
  );

  test(
    'Given a class with a non-gin index with operator class, then collect an error about the operator class not being supported.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            tags: List<String>, serializationDataType=jsonb
          indexes:
            tags_ndx:
              fields: tags
              type: btree
              operatorClass: jsonbOps
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was collected.',
      );
      expect(
        collector.errors.first.message,
        'The "operatorClass" property can only be used with gin indexes.',
      );
    },
  );
}

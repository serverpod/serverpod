import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures([
    ExperimentalFeature.serializeAsJsonb,
  ]).build();

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
        '"invalid" is not a valid property. Valid properties are (arrayOps, jsonbOps, jsonbPathOps, tsvectorOps).',
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
        '"1" is not a valid property. Valid properties are (arrayOps, jsonbOps, jsonbPathOps, tsvectorOps).',
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

  test(
    'Given a class with an index on a jsonb field with no explicit type, then the index type defaults to gin.',
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
      expect(definition.indexes.first.type, 'gin');
    },
  );

  test(
    'Given a class with a gin index on a non-jsonb field, then collect an error that gin indexes require jsonb.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            tags: List<String>
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
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was collected.',
      );
      expect(
        collector.errors.first.message,
        'GIN indexes require the indexed field to use '
        '"serializationDataType: jsonb" (fields: tags).',
      );
    },
  );

  test(
    'Given a class with an index on both a jsonb field and a non-jsonb field with no explicit type, then the index type defaults to btree.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            tags: List<String>, serializationDataType=jsonb
            name: String
          indexes:
            combined_ndx:
              fields: tags,name
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
      expect(definition.indexes.first.type, 'btree');
    },
  );

  test(
    'Given a class with a gin index and the project targets SQLite, then collect an error that gin indexes are not supported in SQLite.',
    () {
      var sqliteConfig = GeneratorConfigBuilder()
          .withDatabaseDialect(DatabaseDialect.sqlite)
          .withEnabledExperimentalFeatures([
            ExperimentalFeature.serializeAsJsonb,
          ])
          .build();

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
        sqliteConfig,
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
        'GIN indexes are not supported in SQLite.',
      );
    },
  );
}

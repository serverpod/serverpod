import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
      [ExperimentalFeature.serializeAsJsonb]).build();

  test(
      'Given a class with a gin index with valid operator class, then return a definition where operatorClass is correctly set.',
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
              operatorClass: jsonbPath
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var operatorClass = definition.indexes.first.ginOperatorClass;

    expect(operatorClass, isNotNull);
    expect(operatorClass!.name, 'jsonbPath');
  });

  test(
      'Given a class with a gin index without operator class, then return a definition where operatorClass defaults to jsonb.',
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
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but errors were collected.',
    );

    var definition = definitions.first as ModelClassDefinition;
    var operatorClass = definition.indexes.first.ginOperatorClass;

    expect(operatorClass, isNotNull);
    expect(operatorClass!.name, 'jsonb');
  });

  test(
      'Given a class with a gin index with invalid operator class value, then collect an error about invalid operator class value.',
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
              operatorClass: invalid
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(error.message,
        '"invalid" is not a valid property. Valid properties are (array, jsonb, jsonbPath, tsvector).');
  });
}

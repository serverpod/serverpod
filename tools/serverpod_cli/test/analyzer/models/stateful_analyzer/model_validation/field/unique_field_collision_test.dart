import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a manual index with the same name as an auto-generated unique index when parsed then collect an error.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            email: String, unique
          indexes:
            example__email__unique_idx:
              fields: email
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
        reason: 'Expected an error for duplicate index name.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        contains('example__email__unique_idx'),
      );
      expect(
        error.message,
        anyOf([
          contains('already defined'),
          contains('already used'),
        ]),
      );
    },
  );

  test(
    'Given two fields with unique that would generate the same index name when parsed then the auto-generation works correctly.',
    () {
      // This tests that if two different fields in the same table somehow
      // would generate the same index name (edge case), only one is created
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            email: String, unique
            otherField: String
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
        reason: 'Expected no errors.',
      );

      var definition = definitions.first as ModelClassDefinition;
      expect(definition.indexes.length, 1);
    },
  );
}

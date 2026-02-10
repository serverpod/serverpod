import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a class with a field marked as unique when parsed then an index is auto-generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            email: String, unique
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
      var definition = definitions.first as ModelClassDefinition;

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors.',
      );

      expect(definition.indexes.length, 1);
      var index = definition.indexes.first;
      expect(index.name, 'example__email__unique_idx');
      expect(index.unique, true);
      expect(index.fields, ['email']);
      expect(index.type, 'btree');
    },
  );

  test(
    'Given a class with a field marked as unique=true when parsed then an index is auto-generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            email:
              type: String
              unique: true
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
      var definition = definitions.first as ModelClassDefinition;

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors.',
      );

      expect(definition.indexes.length, 1);
      var index = definition.indexes.first;
      expect(index.name, 'example__email__unique_idx');
      expect(index.unique, true);
      expect(index.fields, ['email']);
    },
  );

  test(
    'Given a class with a field marked as unique=false when parsed then no index is auto-generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            email:
              type: String
              unique: false
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
      var definition = definitions.first as ModelClassDefinition;

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors.',
      );

      expect(definition.indexes.length, 0);
    },
  );

  test(
    'Given a class with multiple fields marked as unique when parsed then multiple indexes are auto-generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            email: String, unique
            username: String, unique
            name: String
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
      var definition = definitions.first as ModelClassDefinition;

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors.',
      );

      expect(definition.indexes.length, 2);
      
      var emailIndex = definition.indexes.firstWhere((i) => i.name == 'example__email__unique_idx');
      expect(emailIndex.unique, true);
      expect(emailIndex.fields, ['email']);
      
      var usernameIndex = definition.indexes.firstWhere((i) => i.name == 'example__username__unique_idx');
      expect(usernameIndex.unique, true);
      expect(usernameIndex.fields, ['username']);
    },
  );

  test(
    'Given a class with both unique field and manual indexes when parsed then both are included.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            email: String, unique
            name: String
          indexes:
            name_index:
              fields: name
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
      var definition = definitions.first as ModelClassDefinition;

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors.',
      );

      expect(definition.indexes.length, 2);
      
      var manualIndex = definition.indexes.firstWhere((i) => i.name == 'name_index');
      expect(manualIndex.unique, false);
      expect(manualIndex.fields, ['name']);
      
      var autoIndex = definition.indexes.firstWhere((i) => i.name == 'example__email__unique_idx');
      expect(autoIndex.unique, true);
      expect(autoIndex.fields, ['email']);
    },
  );

  test(
    'Given a class with a field with column override marked as unique when parsed then index uses column name.',
    () {
      var config = GeneratorConfigBuilder()
          .withEnabledExperimentalFeatures([ExperimentalFeature.columnOverride])
          .build();
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            emailAddress:
              type: String
              column: email
              unique: true
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
      var definition = definitions.first as ModelClassDefinition;

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors.',
      );

      expect(definition.indexes.length, 1);
      var index = definition.indexes.first;
      expect(index.name, 'example__email__unique_idx');
      expect(index.fields, ['email']);
    },
  );

  test(
    'Given a class without a table when a field is marked as unique then no index is auto-generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            email: String, unique
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
      var definition = definitions.first as ModelClassDefinition;

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors.',
      );

      expect(definition.indexes.length, 0);
    },
  );
}

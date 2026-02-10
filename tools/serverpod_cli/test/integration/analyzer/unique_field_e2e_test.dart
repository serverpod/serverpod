import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('End-to-end unique field feature', () {
    test(
      'Given a model with unique field when database definition is created then unique index is included.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: User
            table: user
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

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors.',
        );

        expect(definitions.length, 1);
        var modelDefinition = definitions.first as ModelClassDefinition;

        // Verify the model has the expected indexes
        expect(modelDefinition.indexes.length, 2);
        expect(
          modelDefinition.indexes.any(
            (i) => i.name == 'user__email__unique_idx',
          ),
          true,
          reason: 'Expected auto-generated email index',
        );
        expect(
          modelDefinition.indexes.any(
            (i) => i.name == 'user__username__unique_idx',
          ),
          true,
          reason: 'Expected auto-generated username index',
        );

        // Create database definition and verify indexes are included
        var dbDefinition = createDatabaseDefinitionFromModels(
          definitions,
          'test_module',
          [],
        );

        expect(dbDefinition.tables.length, 1);
        var table = dbDefinition.tables.first;

        // Should have primary key + 2 unique indexes
        expect(table.indexes.length, 3);

        var emailIndex = table.indexes.firstWhere(
          (i) => i.indexName == 'user__email__unique_idx',
        );
        expect(emailIndex.isUnique, true);
        expect(emailIndex.type, 'btree');
        expect(emailIndex.elements.length, 1);
        expect(emailIndex.elements.first.definition, 'email');

        var usernameIndex = table.indexes.firstWhere(
          (i) => i.indexName == 'user__username__unique_idx',
        );
        expect(usernameIndex.isUnique, true);
        expect(usernameIndex.type, 'btree');
        expect(usernameIndex.elements.length, 1);
        expect(usernameIndex.elements.first.definition, 'username');
      },
    );

    test(
      'Given a model with both unique field and manual index when database definition is created then both indexes are included.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Product
            table: product
            fields:
              sku: String, unique
              name: String
            indexes:
              name_idx:
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

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors.',
        );

        var modelDefinition = definitions.first as ModelClassDefinition;
        expect(modelDefinition.indexes.length, 2);

        // Create database definition
        var dbDefinition = createDatabaseDefinitionFromModels(
          definitions,
          'test_module',
          [],
        );

        var table = dbDefinition.tables.first;
        // Primary key + 1 manual + 1 auto-generated = 3 indexes
        expect(table.indexes.length, 3);

        var manualIndex = table.indexes.firstWhere(
          (i) => i.indexName == 'name_idx',
        );
        expect(manualIndex.isUnique, false);

        var autoIndex = table.indexes.firstWhere(
          (i) => i.indexName == 'product__sku__unique_idx',
        );
        expect(autoIndex.isUnique, true);
      },
    );

    test(
      'Given equivalent manual and simplified unique definitions when database definitions are created then they are identical.',
      () {
        var simplifiedModel = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              title: String, unique
            ''',
          ).build(),
        ];

        var manualModel = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              title: String
            indexes:
              example__title__unique_idx:
                fields: title
                unique: true
            ''',
          ).build(),
        ];

        var simplifiedCollector = CodeGenerationCollector();
        var simplifiedAnalyzer = StatefulAnalyzer(
          config,
          simplifiedModel,
          onErrorsCollector(simplifiedCollector),
        );
        var simplifiedDefinitions = simplifiedAnalyzer.validateAll();

        var manualCollector = CodeGenerationCollector();
        var manualAnalyzer = StatefulAnalyzer(
          config,
          manualModel,
          onErrorsCollector(manualCollector),
        );
        var manualDefinitions = manualAnalyzer.validateAll();

        expect(simplifiedCollector.errors, isEmpty);
        expect(manualCollector.errors, isEmpty);

        // Create database definitions
        var simplifiedDb = createDatabaseDefinitionFromModels(
          simplifiedDefinitions,
          'test_module',
          [],
        );
        var manualDb = createDatabaseDefinitionFromModels(
          manualDefinitions,
          'test_module',
          [],
        );

        // Compare the indexes (excluding primary key)
        var simplifiedIndexes = simplifiedDb.tables.first.indexes
            .where((i) => !i.isPrimary)
            .toList();
        var manualIndexes = manualDb.tables.first.indexes
            .where((i) => !i.isPrimary)
            .toList();

        expect(simplifiedIndexes.length, manualIndexes.length);
        expect(
          simplifiedIndexes.first.indexName,
          manualIndexes.first.indexName,
        );
        expect(simplifiedIndexes.first.isUnique, manualIndexes.first.isUnique);
        expect(simplifiedIndexes.first.type, manualIndexes.first.type);
        expect(
          simplifiedIndexes.first.elements.first.definition,
          manualIndexes.first.elements.first.definition,
        );
      },
    );
  });
}

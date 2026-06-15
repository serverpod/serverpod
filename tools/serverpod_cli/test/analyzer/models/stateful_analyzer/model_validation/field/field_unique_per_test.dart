import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a table-backed model with a field that uses inline unique(per=category), '
    'when parsed, '
    'then a composite unique index is auto-generated with per columns first.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            category: String
            value: String, unique(per=category)
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

      expect(collector.errors, isEmpty, reason: 'Expected no errors.');
      expect(definition.indexes.length, 1);

      var index = definition.indexes.first;
      expect(index.name, 'example__category__value__unique_idx');
      expect(index.unique, true);
      expect(index.fields, ['category', 'value']);
      expect(index.type, 'btree');
    },
  );

  test(
    'Given a table-backed model with a field that uses inline unique(per=[category, tenantId]), '
    'when parsed, '
    'then a composite unique index preserves column order.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            category: String
            tenantId: int
            value: String, unique(per=[category, tenantId])
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

      expect(collector.errors, isEmpty, reason: 'Expected no errors.');
      expect(definition.indexes.length, 1);

      var index = definition.indexes.first;
      expect(index.name, 'example__category__tenantId__value__unique_idx');
      expect(index.unique, true);
      expect(index.fields, ['category', 'tenantId', 'value']);
    },
  );

  test(
    'Given a table-backed model with a field that uses expanded unique with scalar per, '
    'when parsed, '
    'then a composite unique index is auto-generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            category: String
            value:
              type: String
              unique:
                per: category
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

      expect(collector.errors, isEmpty, reason: 'Expected no errors.');
      expect(definition.indexes.length, 1);

      var index = definition.indexes.first;
      expect(index.name, 'example__category__value__unique_idx');
      expect(index.fields, ['category', 'value']);
    },
  );

  test(
    'Given a table-backed model with a field that uses expanded unique with list per, '
    'when parsed, '
    'then a composite unique index is auto-generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            category: String
            tenantId: int
            value:
              type: String
              unique:
                per: [category, tenantId]
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

      expect(collector.errors, isEmpty, reason: 'Expected no errors.');
      expect(definition.indexes.length, 1);

      var index = definition.indexes.first;
      expect(index.name, 'example__category__tenantId__value__unique_idx');
      expect(index.fields, ['category', 'tenantId', 'value']);
    },
  );

  test(
    'Given a table-backed model where per fields and the annotated field use column overrides, '
    'when parsed, '
    'then the index uses column names.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            categoryName: String, column=category
            valueName: String, column=value, unique(per=categoryName)
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

      expect(collector.errors, isEmpty, reason: 'Expected no errors.');
      expect(definition.indexes.length, 1);

      var index = definition.indexes.first;
      expect(index.name, 'example__category__value__unique_idx');
      expect(index.fields, ['category', 'value']);
    },
  );

  test(
    'Given a table-backed model where per references an unknown field, '
    'when parsed, '
    'then an error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            value: String, unique(per=missing)
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

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The field name "missing" is not added to the class or has an !persist scope.',
      );
    },
  );

  test(
    'Given a table-backed model where per references a non-persisted field, '
    'when parsed, '
    'then an error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            category: String, !persist
            value: String, unique(per=category)
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

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The field name "category" is not added to the class or has an !persist scope.',
      );
    },
  );

  test(
    'Given a table-backed model where per contains duplicate field names, '
    'when parsed, '
    'then an error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            category: String
            value: String, unique(per=[category, category])
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

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'Duplicated field name "category", can only reference a field once per index.',
      );
    },
  );

  test(
    'Given a table-backed model where the annotated field is included in its own per list, '
    'when parsed, '
    'then an error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            category: String
            value: String, unique(per=[category, value])
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

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The field "value" cannot be included in its own "unique" "per" list.',
      );
    },
  );

  test(
    'Given a table-backed model where a manual index collides with an auto-generated composite unique name, '
    'when parsed, '
    'then an error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            category: String
            value: String, unique(per=category)
          indexes:
            example__category__value__unique_idx:
              fields: category, value
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

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The index name "example__category__value__unique_idx" is reserved for the field '
        '"value" of the model "Example" marked as unique (auto-generated). '
        'Either remove the unique modifier from the field or use a different '
        'name for this index.',
      );
    },
  );

  test(
    'Given a table-backed model where the auto-generated composite index name exceeds the PostgreSQL limit, '
    'when parsed, '
    'then an error is collected.',
    () {
      var longName = 'a' * 20;
      var field1 = '${longName}1';
      var field2 = '${longName}2';
      var field3 = '${longName}3';
      var field4 = '${longName}4';
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: ${'t' * 20}
          fields:
            $field1: String
            $field2: String
            $field3: String
            $field4: String, unique(per=[$field1, $field2, $field3])
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

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.any(
          (e) => e.message.contains(
            '${DatabaseConstants.pgsqlMaxNameLimitation} character',
          ),
        ),
        true,
        reason: 'Expected error for index name length.',
      );
    },
  );

  test(
    'Given a table-backed model where two fields declare composite unique with the same per columns, '
    'when parsed, '
    'then no duplicate index name error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            category: String
            tenantId: int
            value: String, unique(per=[category, tenantId])
            altValue: String, unique(per=[category, tenantId])
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

      expect(collector.errors, isEmpty, reason: 'Expected no errors.');
      expect(definition.indexes.length, 2);
      expect(
        definition.indexes.map((i) => i.name).toSet().length,
        2,
        reason: 'Expected distinct auto-generated index names.',
      );
    },
  );

  test(
    'Given a model without a table where a field uses unique(per=category), '
    'when parsed, '
    'then no index is auto-generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            category: String
            value: String, unique(per=category)
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

      expect(collector.errors, isEmpty, reason: 'Expected no errors.');
      expect(definition.indexes.length, 0);
    },
  );
}

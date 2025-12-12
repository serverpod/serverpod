import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a parent model with an index and a child model with a table that extends it, '
    'when analyzing models '
    'then the child model inherits the index with the table name prefix.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentBase
          fields:
            indexed: int
          indexes:
            base_index:
              fields: indexed
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_table').withYaml(
          '''
          class: ChildTable
          table: child_table
          extends: ParentBase
          fields:
            ownField: String
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
        reason: 'Expected no errors but some were generated.',
      );

      var childDefinition = definitions
          .whereType<ModelClassDefinition>()
          .firstWhere((d) => d.className == 'ChildTable');

      var inheritedIndexes = childDefinition.inheritedIndexes;
      expect(inheritedIndexes, isNotEmpty);
      expect(inheritedIndexes.length, 1);

      var inheritedIndex = inheritedIndexes.first;
      expect(inheritedIndex.name, 'child_table_base_index');
      expect(inheritedIndex.fields, ['indexed']);
    },
  );

  test(
    'Given a grandchild model with a table that extends a child model that extends a parent model with an index, '
    'when analyzing models '
    'then the grandchild model inherits the index with the table name prefix.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentBase
          fields:
            indexed: int
          indexes:
            base_index:
              fields: indexed
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_table').withYaml(
          '''
          class: ChildTable
          extends: ParentBase
          fields:
            ownField: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('grandchild_table').withYaml(
          '''
          class: GrandchildTable
          table: grandchild_table
          extends: ChildTable
          fields:
            grandchildField: String
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
        reason: 'Expected no errors but some were generated.',
      );

      var grandchildDefinition = definitions
          .whereType<ModelClassDefinition>()
          .firstWhere((d) => d.className == 'GrandchildTable');

      var inheritedIndexes = grandchildDefinition.inheritedIndexes;
      expect(inheritedIndexes, isNotEmpty);
      expect(inheritedIndexes.length, 1);

      var inheritedIndex = inheritedIndexes.first;
      expect(inheritedIndex.name, 'grandchild_table_base_index');
      expect(inheritedIndex.fields, ['indexed']);
    },
  );

  group(
    'Given an inherited index whose name combined with the table name exceeds the 63 character index name limitation, then collect an error that the index name is too long.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
class: ParentBase
fields:
  indexed: int
indexes:
  base_index_that_is_very_very_long:
    fields: indexed
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_table').withYaml(
          '''
class: ChildTable
table: child_table_with_a_very_long_name
extends: ParentBase
fields:
  ownField: String
          ''',
        ).build(),
      ];

      late var collector = CodeGenerationCollector();
      late var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );

      setUpAll(() {
        analyzer.validateAll();
      });

      test('then an error is collected.', () {
        expect(collector.errors, isNotEmpty);
      });

      test(
        'then the error message indicates that the combined index name is too long.',
        () {
          var error = collector.errors.first;
          expect(
            error.message,
            'The index name "child_table_with_a_very_long_name_base_index_that_is_very_very_long" '
            'exceeds the 63 character index name limitation. Consider shortening '
            'either the base index name or the table name. Note that changing the '
            'base index name may require dropping and recreating indexes for other '
            'tables that already extend the model where it is defined.',
          );
        },
      );

      test('then the span points to the inherited table name.', () {
        var error = collector.errors.first;
        expect(error.span, isNotNull);
        expect(error.span!.start.line, 1);
        expect(error.span!.start.column, 7);
        expect(error.span!.end.line, 1);
        expect(error.span!.end.column, 40);
      });
    },
  );
}

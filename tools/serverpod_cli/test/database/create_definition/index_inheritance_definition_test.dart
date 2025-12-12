import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:test/test.dart';

import '../../test_util/builders/model_class_definition_builder.dart';

void main() {
  test(
    'Given a parent model with an index and a child model with a table that extends it, '
    'when creating database definitions '
    'then the child table gets an index based on the inherited one.',
    () {
      var parentIndex = SerializableModelIndexDefinition(
        name: 'base_index',
        type: 'btree',
        unique: false,
        fields: ['indexed'],
      );

      var parent = ModelClassDefinitionBuilder()
          .withClassName('ParentBase')
          .withSimpleField('indexed', 'int')
          .withIndexes([parentIndex])
          .build();

      var child = ModelClassDefinitionBuilder()
          .withClassName('ChildTable')
          .withTableName('child_table')
          .withExtendsClass(parent)
          .withSimpleField('ownField', 'String')
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [parent, child],
        'example',
        [],
      );

      var table = databaseDefinition.tables.singleWhere(
        (t) => t.name == 'child_table',
      );

      var inheritedIndex = table.indexes
          .where((i) => i.indexName == 'child_table_base_index')
          .firstOrNull;

      expect(inheritedIndex, isNotNull);
      expect(
        inheritedIndex!.elements.map((e) => e.definition).toList(),
        ['indexed'],
      );
    },
  );

  test(
    'Given a grandchild model with a table that extends a child model that extends a parent model with an index, '
    'when creating database definitions '
    'then the grandchild table gets an index based on the inherited one from the parent model.',
    () {
      var parentIndex = SerializableModelIndexDefinition(
        name: 'base_index',
        type: 'btree',
        unique: false,
        fields: ['indexed'],
      );

      var parent = ModelClassDefinitionBuilder()
          .withClassName('ParentBase')
          .withSimpleField('indexed', 'int')
          .withIndexes([parentIndex])
          .build();

      var child = ModelClassDefinitionBuilder()
          .withClassName('ChildTable')
          .withExtendsClass(parent)
          .withSimpleField('ownField', 'String')
          .build();

      var grandchild = ModelClassDefinitionBuilder()
          .withClassName('GrandchildTable')
          .withTableName('grandchild_table')
          .withExtendsClass(child)
          .withSimpleField('ownField', 'String')
          .build();

      var databaseDefinition = createDatabaseDefinitionFromModels(
        [parent, child, grandchild],
        'example',
        [],
      );

      var grandchildTable = databaseDefinition.tables.singleWhere(
        (t) => t.name == 'grandchild_table',
      );

      var inheritedIndex = grandchildTable.indexes
          .where((i) => i.indexName == 'grandchild_table_base_index')
          .firstOrNull;

      expect(inheritedIndex, isNotNull);
      expect(
        inheritedIndex!.elements.map((e) => e.definition).toList(),
        ['indexed'],
      );
    },
  );
}

import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a mixin with an unnamed relation(field=parentId) and a concrete child class, '
    'when creating database definitions '
    'then the child table contains the FK constraint and the mixin has no table.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Base
          tableBase: true
          fields:
            parentId: int
            parent: Parent?, relation(field=parentId)
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child').withYaml(
          '''
          class: Child
          table: child
          extends: Base
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('parent').withYaml(
          '''
          class: Parent
          table: parent
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);

      var databaseDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );

      var tableNames = databaseDefinition.tables.map((t) => t.name).toList();
      expect(tableNames, contains('child'));
      expect(tableNames, contains('parent'));
      expect(tableNames, isNot(contains('base')));

      var childTable = databaseDefinition.tables.singleWhere(
        (t) => t.name == 'child',
      );

      expect(childTable.foreignKeys, hasLength(1));

      var fk = childTable.foreignKeys.first;
      expect(fk.constraintName, 'child_fk_0');
      expect(fk.columns, ['parentId']);
      expect(fk.referenceTable, 'parent');
      expect(fk.referenceColumns, ['id']);
    },
  );

  test(
    'Given a mixin with an unnamed relation(field=parentId) and two concrete child classes, '
    'when creating database definitions '
    'then each child table has its own independent FK constraint.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Base
          tableBase: true
          fields:
            parentId: int
            parent: Parent?, relation(field=parentId)
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_one').withYaml(
          '''
          class: ChildOne
          table: child_one
          extends: Base
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_two').withYaml(
          '''
          class: ChildTwo
          table: child_two
          extends: Base
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('parent').withYaml(
          '''
          class: Parent
          table: parent
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);

      var databaseDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );

      var childOneTable = databaseDefinition.tables.singleWhere(
        (t) => t.name == 'child_one',
      );
      var childTwoTable = databaseDefinition.tables.singleWhere(
        (t) => t.name == 'child_two',
      );

      expect(childOneTable.foreignKeys, hasLength(1));
      expect(childOneTable.foreignKeys.first.constraintName, 'child_one_fk_0');
      expect(childOneTable.foreignKeys.first.columns, ['parentId']);
      expect(childOneTable.foreignKeys.first.referenceTable, 'parent');

      expect(childTwoTable.foreignKeys, hasLength(1));
      expect(childTwoTable.foreignKeys.first.constraintName, 'child_two_fk_0');
      expect(childTwoTable.foreignKeys.first.columns, ['parentId']);
      expect(childTwoTable.foreignKeys.first.referenceTable, 'parent');
    },
  );

  test(
    'Given a tableBase class with an implicit relation (no field= specified) and a concrete child class, '
    'when creating database definitions '
    'then the child table contains the FK constraint with an auto-generated column name.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Base
          tableBase: true
          fields:
            parent: Parent?, relation
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child').withYaml(
          '''
          class: Child
          table: child
          extends: Base
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('parent').withYaml(
          '''
          class: Parent
          table: parent
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);

      var databaseDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );

      var childTable = databaseDefinition.tables.singleWhere(
        (t) => t.name == 'child',
      );

      expect(childTable.foreignKeys, hasLength(1));

      var fk = childTable.foreignKeys.first;
      expect(fk.constraintName, 'child_fk_0');
      expect(fk.columns, ['parentId']);
      expect(fk.referenceTable, 'parent');
      expect(fk.referenceColumns, ['id']);
    },
  );
}

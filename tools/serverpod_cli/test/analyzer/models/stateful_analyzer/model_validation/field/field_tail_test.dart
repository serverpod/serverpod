import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with tail fields,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: String
            createdAt: DateTime, tail
            updatedAt: DateTime, tail
          ''',
      ).build(),
    ];
    var collector = CodeGenerationCollector();
    var definitions = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();

    test('then no errors are collected.', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but some were generated.',
      );
    });

    test('then tail fields are marked as tail.', () {
      var definition = definitions.first as ClassDefinition;

      expect(definition.findField('createdAt')?.isTail, isTrue);
      expect(definition.findField('updatedAt')?.isTail, isTrue);
    });

    test('then non-tail fields are not marked as tail.', () {
      var definition = definitions.first as ClassDefinition;

      expect(definition.findField('name')?.isTail, isFalse);
    });

    test('then tail fields are placed after non-tail fields.', () {
      var definition = definitions.first as ClassDefinition;

      expect(
        definition.fieldsIncludingInherited.map((field) => field.name),
        ['name', 'createdAt', 'updatedAt'],
      );
    });
  });

  group(
    'Given a class with tail fields declared between non-tail fields,',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            firstName: String
            createdAt: DateTime, tail
            lastName: String
            updatedAt: DateTime, tail
          ''',
        ).build(),
      ];
      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors but some were generated.',
        );
      });

      test('then tail fields are placed after all non-tail fields.', () {
        var definition = definitions.first as ClassDefinition;

        expect(
          definition.fieldsIncludingInherited.map((field) => field.name),
          ['firstName', 'lastName', 'createdAt', 'updatedAt'],
        );
      });
    },
  );

  group('Given a class with tail on the id field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            id: int?, tail
            name: String
          ''',
      ).build(),
    ];
    var collector = CodeGenerationCollector();

    StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();

    test('then a validation error is collected.', () {
      expect(collector.errors, isNotEmpty);
    });

    test('then the error message mentions tail and id.', () {
      expect(
        collector.errors.first.message,
        contains('tail'),
      );
      expect(
        collector.errors.first.message,
        contains('id'),
      );
    });
  });

  group(
    'Given a child table class extending a parent with tail fields, '
    'when analyzing,',
    () {
      late var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Entity
          fields:
            baseField: String
            createdAt: DateTime, tail
            updatedAt: DateTime, tail
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child').withYaml(
          '''
          class: Child
          extends: Entity
          table: child_table
          fields:
            name: String
          ''',
        ).build(),
      ];

      late var collector = CodeGenerationCollector();
      late var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      late var child = models.last as ModelClassDefinition;

      test('then tail fields from the parent appear after child fields.', () {
        expect(
          child.fieldsIncludingInherited.map((field) => field.name),
          ['id', 'baseField', 'name', 'createdAt', 'updatedAt'],
        );
      });

      test('then the generated table columns follow the same order.', () {
        var databaseDefinition = createDatabaseDefinitionFromModels(
          models.whereType<ModelClassDefinition>().toList(),
          'example',
          [],
        );

        var childTable = databaseDefinition.tables.firstWhere(
          (table) => table.name == 'child_table',
        );

        expect(
          childTable.columns.map((column) => column.fieldName),
          ['id', 'baseField', 'name', 'createdAt', 'updatedAt'],
        );
      });
    },
  );

  test(
    'Given a multi-level inheritance hierarchy with tail fields on root and parent, '
    'when analyzing, '
    'then child tail fields appear before root tail fields.',
    () {
      var modelSources = [
        ModelSourceBuilder().withFileName('entity').withYaml(
          '''
          class: Entity
          fields:
            baseField: String
            createdAt: DateTime, tail
            updatedAt: DateTime, tail
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('parent').withYaml(
          '''
          class: Parent
          extends: Entity
          fields:
            parentField: String
            archivedAt: DateTime, tail
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child').withYaml(
          '''
          class: Child
          extends: Parent
          table: child_table
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      var child = models.last as ModelClassDefinition;

      expect(
        child.fieldsIncludingInherited.map((field) => field.name).toList(),
        [
          'id',
          'baseField',
          'parentField',
          'name',
          'archivedAt',
          'createdAt',
          'updatedAt',
        ],
      );
    },
  );

  group(
    'Given an unrelated class with tail fields in the same project, '
    'when analyzing a child class without tail fields in its hierarchy,',
    () {
      late var modelSources = [
        ModelSourceBuilder().withFileName('grandparent_class').withYaml(
          '''
          class: GrandparentClass
          fields:
            grandParentField: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('parent_class').withYaml(
          '''
          class: ParentClass
          extends: GrandparentClass
          table: parent_class_table
          fields:
            parentField: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          extends: ParentClass
          fields:
            childField: int
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('parent_with_changed_id').withYaml(
          '''
          class: ParentWithChangedId
          serverOnly: true
          fields:
            id: UuidValue, defaultModel=random_v7
            createdAt: DateTime?, tail
            updatedAt: DateTime?, tail
          ''',
        ).build(),
      ];

      late var collector = CodeGenerationCollector();
      late var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test('then the child class field order is unchanged.', () {
        var childClass = models.whereType<ModelClassDefinition>().firstWhere(
          (model) => model.className == 'ChildClass',
        );

        expect(
          childClass.fieldsIncludingInherited.map((field) => field.name),
          ['id', 'grandParentField', 'parentField', 'childField'],
        );
      });
    },
  );
}

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures([
    ExperimentalFeature.inheritance,
  ]).build();

  group(
    'Given a parent table class and a child non-table class that extends it '
    'when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentClass
          table: parent_table
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          extends: ParentClass
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      late var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      late var childClass = models.last as ModelClassDefinition;

      test('then child class inherits id field from parent class.', () {
        var inheritedFields = childClass.inheritedFields;
        expect(inheritedFields.map((f) => f.name).toSet(), {'id', 'name'});
      });

      test('then child class does not have its own id field.', () {
        var ownFields = childClass.fields;
        expect(ownFields.any((f) => f.name == 'id'), false);
      });
    },
  );

  group(
    'Given a parent non-table class with id field defined and a child table class that extends it '
    'when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentClass
          fields:
            id: UuidValue?, defaultPersist=random
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      late var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      late var childClass = models.last as ModelClassDefinition;

      test(
        'then child class does not directly inherit id field from parent class.',
        () {
          var inheritedFields = childClass.inheritedFields;
          expect(inheritedFields.any((f) => f.name == 'id'), false);
        },
      );

      test(
        'then child class has its own declared id field inheriting same type as parent id field.',
        () {
          var idField = childClass.idField;

          expect(idField.name, 'id');
          expect(idField.type.className, 'UuidValue');
          expect(idField.type.nullable, true);
        },
      );
    },
  );

  group(
    'Given a parent non-table class with id field of type nullable UuidValue using defaultPersist keyword and a child table class that extends it '
    'when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentClass
          fields:
            id: UuidValue?, defaultPersist=random
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      late var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      late var childClass = models.last as ModelClassDefinition;

      test('then child class id field is nullable.', () {
        expect(childClass.idField.type.nullable, true);
      });

      test(
        'then child class id field has defaultPersist set to the parents configured value and defaultModel set to null.',
        () {
          var idField = childClass.idField;

          expect(idField.defaultPersistValue, 'random');
          expect(idField.defaultModelValue, null);
        },
      );
    },
  );

  group(
    'Given a parent non-table class with id field of type non-nullable UuidValue using defaultModel keyword and a child table class that extends it '
    'when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentClass
          fields:
            id: UuidValue, defaultModel=random
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      late var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      late var childClass = models.last as ModelClassDefinition;

      test('then child class id field is not nullable.', () {
        expect(childClass.idField.type.nullable, false);
      });

      test(
        'then child class has both defaultModel and defaultPersist set to the parents configured value.',
        () {
          var idField = childClass.idField;

          expect(idField.defaultModelValue, 'random');
          expect(idField.defaultPersistValue, 'random');
        },
      );
    },
  );

  group(
    'Given a parent non-table class with id field of type non-nullable UuidValue using default keyword and a child table class that extends it '
    'when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentClass
          fields:
            id: UuidValue, default=random
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      late var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      late var childClass = models.last as ModelClassDefinition;

      test(
        'then child class has both defaultModel and defaultPersist set to the parents configured value.',
        () {
          var idField = childClass.idField;

          expect(idField.defaultModelValue, 'random');
          expect(idField.defaultPersistValue, 'random');
        },
      );
    },
  );

  group('Given a grandparent non-table class with id defined and a grandchild table class that extends its parent '
      'when analyzing', () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
          class: GrandparentClass
          fields:
            id: UuidValue?, defaultPersist=random
            grandparentField: String
          ''',
      ).build(),
      ModelSourceBuilder().withFileName('parent_class').withYaml(
        '''
          class: ParentClass
          extends: GrandparentClass
          fields:
            parentField: String
          ''',
      ).build(),
      ModelSourceBuilder().withFileName('child_class').withYaml(
        '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            childField: int
          ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    late var models = StatefulAnalyzer(
      config,
      modelSources,
      onErrorsCollector(collector),
    ).validateAll();

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    late var childClass = models.last as ModelClassDefinition;

    test(
      'then child class does not directly inherit id field from grandparent class.',
      () {
        var inheritedFields = childClass.inheritedFields;
        expect(inheritedFields.any((f) => f.name == 'id'), false);
      },
    );

    test(
      'then child class has its own declared id field inheriting same properties as grandparent id field.',
      () {
        var idField = childClass.idField;

        expect(idField.name, 'id');
        expect(idField.type.className, 'UuidValue');
        expect(idField.type.nullable, true);
        expect(idField.defaultPersistValue, 'random');
      },
    );
  });

  group(
    'Given a parent non-table server only class with id field defined and a child server only table class that extends it '
    'when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentClass
          serverOnly: true
          fields:
            id: UuidValue?, defaultPersist=random
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          serverOnly: true
          table: child_table
          extends: ParentClass
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();

      setUpAll(() {
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });
    },
  );

  group(
    'Given a parent non-table class with id field of one type and a child table class that extends it defining a different id type '
    'when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentClass
          fields:
            id: int?
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            id: UuidValue?, defaultPersist=random
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();

      setUpAll(() {
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then an error is collected due to id field already defined.', () {
        expect(collector.errors, isNotEmpty);
        expect(
          collector.errors.first.message,
          'The field name "id" is already defined in an inherited class ("ParentClass").',
        );
      });
    },
  );

  group('Given a parent non-table class with a declared id field using a constant default value and a child table class that extends it '
      'when analyzing', () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
          class: ParentClass
          fields:
            id: UuidValue?, default='550e8400-e29b-41d4-a716-446655440000'
            name: String
          ''',
      ).build(),
      ModelSourceBuilder().withFileName('child_class').withYaml(
        '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            age: int
          ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();

    setUpAll(() {
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();
    });

    test(
      'then an error is collected due to invalid default value on id field.',
      () {
        expect(collector.errors, isNotEmpty);
        expect(
          collector.errors.first.message,
          'The "table" property is not allowed due to invalid "id" field defined '
          'on parent classes. The default value "\'550e8400-e29b-41d4-a716-446655440000\'" '
          'is not supported for the id type "UuidValue". Valid options are: '
          '"random", "random_v7".',
        );
      },
    );
  });

  group('Given a parent non-table class with id field of type UuidValue and no default value and a child table class that extends it '
      'when analyzing', () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
          class: ParentClass
          fields:
            id: UuidValue?
            name: String
          ''',
      ).build(),
      ModelSourceBuilder().withFileName('child_class').withYaml(
        '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            age: int
          ''',
      ).build(),
    ];
    var collector = CodeGenerationCollector();

    setUpAll(() {
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();
    });

    test('then an error is collected due to missing default value.', () {
      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The "table" property is not allowed due to invalid "id" field defined '
        'on parent classes. The type "UuidValue" must have a default value. Use '
        'either the "defaultModel" key or the "defaultPersist" key to set it.',
      );
    });
  });

  group(
    'Given a parent non-table class with id field of unsupported type and a child table class that extends it '
    'when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentClass
          fields:
            id: String, default='test'
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();

      setUpAll(() {
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then an error is collected due to missing default value.', () {
        expect(collector.errors, isNotEmpty);
        expect(
          collector.errors.first.message,
          'The "table" property is not allowed due to invalid "id" field defined '
          'on parent classes. The type "String" is not a valid id type. Valid '
          'options are: int, UuidValue.',
        );
      });
    },
  );

  group(
    'Given a parent non-table class with a declared id field with the "scope" key set and a child table class that extends it '
    'when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: ParentClass
          fields:
            id: UuidValue?, default=random, scope=serverOnly
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child_class').withYaml(
          '''
          class: ChildClass
          table: child_table
          extends: ParentClass
          fields:
            age: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();

      setUpAll(() {
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test(
        'then an error is collected due to scope key not allowed on id field.',
        () {
          expect(collector.errors, isNotEmpty);
          expect(
            collector.errors.first.message,
            'The "table" property is not allowed when parent classes set the '
            'scope of the "id" field to a value other than "all".',
          );
        },
      );
    },
  );
}

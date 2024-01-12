import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with a self relation on a field with the class datatype',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: Example?, relation
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var classDefinition = definitions.first as ClassDefinition;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then the field should not be persisted.', () {
      var parent = classDefinition.findField('parent');
      expect(parent?.shouldPersist, isFalse);
    });

    test(
        'then a relation field with the same name appended with Id is set on the relation field.',
        () {
      var parent = classDefinition.findField('parent');
      var relation = parent?.relation;
      expect(relation.runtimeType, ObjectRelationDefinition);
      expect(
        (relation as ObjectRelationDefinition).fieldName,
        'parentId',
      );
    });

    test('has the nullableRelation set to false', () {
      var parent = classDefinition.findField('parent');
      var relation = parent?.relation;

      expect((relation as ObjectRelationDefinition).nullableRelation, false);
    });

    var parentId = classDefinition.findField('parentId');

    test('then the class has a relation field for the id.', () {
      expect(
        parentId,
        isNotNull,
        reason: 'Expected to find a field named parentId.',
      );
    });

    group('', () {
      test('then the relation field has the global scope.', () {
        expect(parentId?.scope, ModelFieldScopeDefinition.all);
      });

      test('then the relation field should be persisted.', () {
        expect(parentId?.shouldPersist, isTrue);
      });

      test('then the relation field type defaults to non-nullable.', () {
        expect(
          parentId?.type.nullable,
          isFalse,
          reason: 'Expected to be non-nullable.',
        );
      });

      test(
          'then the relation field has the parent table set from the object reference.',
          () {
        var parent = classDefinition.findField('parentId');
        var relation = parent?.relation;

        expect(relation.runtimeType, ForeignRelationDefinition);
        expect((relation as ForeignRelationDefinition).parentTable, 'example');
      });

      test(
          'then the relation field has the reference field set to the relation id field.',
          () {
        var parent = classDefinition.findField('parentId');
        var relation = parent?.relation;

        expect(relation.runtimeType, ForeignRelationDefinition);
        expect((relation as ForeignRelationDefinition).foreignFieldName, 'id');
      });
    }, skip: parentId == null);

    test(
        'then the order of the generated field comes before the relation field but after the id.',
        () {
      var fieldNames = classDefinition.fields.map((e) => e.name).toList();
      expect(fieldNames, ['id', 'parentId', 'parent']);
    });
  });

  group(
      'Given a class with a self relation on a field with the class datatype where the relation is optional',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: Example?, relation(optional)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var classDefinition = definitions.first as ClassDefinition;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then relation field is nullable.', () {
      var parent = classDefinition.findField('parentId');
      expect(
        parent?.type.nullable,
        isTrue,
        reason: 'Expected to be nullable.',
      );
    });

    test('has the nullableRelation set to true', () {
      var parent = classDefinition.findField('parent');
      var relation = parent?.relation;

      expect((relation as ObjectRelationDefinition).nullableRelation, true);
    });
  });

  group(
      'Given a class with a self relation on a field with the class datatype where the relation is not optional',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: Example?, relation(!optional)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer =
        StatefulAnalyzer(models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var classDefinition = definitions.first as ClassDefinition;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then relation field is not nullable.', () {
      var parent = classDefinition.findField('parentId');
      expect(
        parent?.type.nullable,
        isFalse,
        reason: 'Expected to not be nullable.',
      );
    });

    test('has the nullableRelation set to false', () {
      var parent = classDefinition.findField('parent');
      var relation = parent?.relation;

      expect((relation as ObjectRelationDefinition).nullableRelation, false);
    });
  });

  test(
      'Given a class with a self relation without any nested rules, then no errors are collected.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: Example?, relation()
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer =
        StatefulAnalyzer(models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(collector.errors, isEmpty, reason: 'Expected no errors');
  });

  test(
      'Given a class with a field without a relation, then no relation is set.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ClassDefinition;

    expect(collector.errors, isEmpty, reason: 'Expected no errors');
    expect(definition.fields.last.relation, isNull);
  });

  test(
      'Given a class with a field with a self reference without a relation, then no relation is set.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          example: Example?
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ClassDefinition;

    expect(collector.errors, isEmpty, reason: 'Expected no errors');
    expect(definition.fields.last.relation, isNull);
  });

  group('Given a class with a field with a self relation', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parentId: int, relation(parent=example)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var classDefinition = definitions.first as ClassDefinition;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty, reason: 'Expected no errors');
    });

    test('then the relation is set with the parent table.', () {
      var relation = classDefinition.fields.last.relation;
      expect(relation.runtimeType, ForeignRelationDefinition);
      expect((relation as ForeignRelationDefinition).parentTable, 'example');
    });

    test('then the relation is set with the reference to the id.', () {
      var relation = classDefinition.fields.last.relation;
      expect(relation.runtimeType, ForeignRelationDefinition);
      expect((relation as ForeignRelationDefinition).foreignFieldName, 'id');
    });

    test('then no relation field is added', () {
      expect(classDefinition.findField('parentIdId'), isNull);
    });
  });

  test(
      'Given a class with a field with a relation, but the parent keyword defined twice, then an error is collected that there is a duplicated key.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parentId: int, relation(parent=example, parent=example)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The field option "parent" is defined more than once.',
    );
  });

  test(
    'Given a class with a field with a relation and parent keyword, then an error is collected that they are mutually exclusive key.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parentId: int, relation(parent=example), parent=example
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error',
      );
      expect(
        collector.errors.first.message,
        'The "parent" property is mutually exclusive with the "relation" property.',
      );
    },
  );

  test(
    'Given a class with a field with a relation, but the parent keyword defined twice, then an error is collected that locates the second parent key.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example, parent=example)
        ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error',
      );

      var error = collector.errors.first;
      expect(error.span, isNotNull,
          reason: 'Expected error to have a source span.');

      var startSpan = error.span!.start;
      expect(startSpan.line, 3);
      expect(startSpan.column, 42);

      var endSpan = error.span!.end;
      expect(endSpan.line, 3);
      expect(endSpan.column, 48);
    },
  );

  test(
    'Given a class with a self relation but without a table defined, then collect an error that the relation keyword cannot be used unless the class has a table.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            parentId: int, relation(parent=example)
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error',
      );
      expect(
        collector.errors.first.message,
        'The "table" property must be defined in the class to set a relation on a field.',
      );
    },
  );

  test(
      'Given a class with a field with a relation on a complex datatype that is not nullable, then an error is collected that the datatype must be nullable.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            parent: Example, relation
          ''',
      ).build()
    ];
    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error',
    );
    expect(
      collector.errors.first.message,
      'Fields with a model relations must be nullable (e.g. parent: Example?).',
    );
  });

  test(
      'Given a class with a field with a relation on a complex datatype and the parent table is defined, then an error is collected that the parent table is redundant.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: Example?, relation(parent=example)
        ''',
      ).build()
    ];
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The "parent" property should be omitted on model relations.',
    );
  });

  test(
      'Given a class with a field with a relation on an id field and the relation is defined as optional, then collect a warning that the optional keyword should not be used.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: int, relation(optional, parent=example)
        ''',
      ).build()
    ];
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The "optional" property should be omitted on id fields.',
    );
  });

  test(
      'Given a class with a field with a relation on an id field but is missing a parent table definition, then collect an error that the parent table is required.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: int, relation
        ''',
      ).build()
    ];
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

    expect(collector.errors, isNotEmpty, reason: 'Expected an error');

    expect(
      collector.errors.first.message,
      'The "parent" property must be defined on id fields.',
    );
  });

  group('Given a class with a relation to a model class with a table defined',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: ExampleParent?, relation
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('example_parent').withYaml(
        '''
        class: ExampleParent
        table: example_parent
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var classDefinition = definitions.first as ClassDefinition;

    test('then no errors were detected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then a relation with the parent table is set on the relation field.',
        () {
      var relation = classDefinition.findField('parentId')?.relation;

      expect(relation.runtimeType, ForeignRelationDefinition);
      expect(
        (relation as ForeignRelationDefinition).parentTable,
        'example_parent',
      );
    });

    test('then a relation with the reference id is set on the relation field.',
        () {
      var relation = classDefinition.findField('parentId')?.relation;

      expect(relation.runtimeType, ForeignRelationDefinition);
      expect((relation as ForeignRelationDefinition).foreignFieldName, 'id');
    });
  });

  group('Given a class with a json field without a relation', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: ExampleParent
        ''',
      ).build(),
      ModelSourceBuilder().withYaml(
        '''
        class: ExampleParent
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var classDefinition = definitions.first as ClassDefinition;

    test('then no errors were detected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then no relation field is created.', () {
      var parentField = classDefinition.findField('parentId');
      expect(parentField, isNull);
    });

    test('then no relation is set on the json field.', () {
      var relation = classDefinition.findField('parent')?.relation;
      expect(relation, isNull);
    });
  });

  group('Given a class with a List json field without a relation', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: List<ExampleParent>
        ''',
      ).build(),
      ModelSourceBuilder().withYaml(
        '''
        class: ExampleParent
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var classDefinition = definitions.first as ClassDefinition;

    test('then no errors were detected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then no relation field is created.', () {
      var parentField = classDefinition.findField('parentId');
      expect(parentField, isNull);
    });

    test('then no relation is set on the json field.', () {
      var relation = classDefinition.findField('parent')?.relation;
      expect(relation, isNull);
    });
  });

  test(
      'Given a class with a relation referencing a non-existent class then collect an error that the class was not found',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: InvalidClass?, relation
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

    expect(collector.errors, isNotEmpty);
    expect(
      collector.errors.last.message,
      'The field has an invalid datatype "InvalidClass".',
    );
  });

  test(
      'Given a class with a relation to a model enum, then collect an error that the class does not exist.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: EnumParent?, relation
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('enum_parent').withYaml(
        '''
        enum: EnumParent
        values:
          - value1
          - value2
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();

    expect(collector.errors, isNotEmpty);
    expect(
      collector.errors.first.message,
      'Only classes can be used in relations, "EnumParent" is not a class.',
    );
  });

  test(
      'Given a class with a relation to a model class without a table defined, then collect an error that the class does not have a table.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: ExampleParent?, relation
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('example_parent').withYaml(
        '''
        class: ExampleParent
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(models, onErrorsCollector(collector)).validateAll();
    expect(collector.errors, isNotEmpty, reason: 'Expected an error');
    expect(
      collector.errors.first.message,
      'The class "ExampleParent" must have a "table" property defined to be used in a relation.',
    );
  });

  group(
      'Given a class with an implicit self relation field name with 61 chars when analyzing model',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa: Example?, relation
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var classDefinition = definitions.firstOrNull as ClassDefinition?;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then class definition is created', () {
      expect(classDefinition, isNotNull);
    });

    test(
        'then no field exists with a name that is longer than Postgres max name limit',
        () {
      var fields = classDefinition?.fields
          .where((element) =>
              element.name.length > DatabaseConstants.pgsqlMaxNameLimitation)
          .map((e) => e.name)
          .toList();

      expect(
        fields,
        isEmpty,
        reason:
            'Expected no fields with a name longer than ${DatabaseConstants.pgsqlMaxNameLimitation} chars',
      );
    }, skip: classDefinition == null);
  });

  group(
      'Given a class with an implicit list relation that creates a foreign key field with more than 63 chars when analyzing model',
      () {
    var models = [
      ModelSourceBuilder().withFileName('employee').withYaml(
        '''
        class: Employee
        table: employee
        fields:
          name: String
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('company').withYaml(
        '''
        class: Company
        table: company
        fields:
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa: List<Employee>?, relation
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );

    var definitions = analyzer.validateAll();

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    var employeeDefinition = definitions
        .where(
          (classes) => classes.className == 'Employee',
        )
        .firstOrNull as ClassDefinition?;

    test('then employee class definition is created.', () {
      expect(employeeDefinition, isNotNull);
    });

    test(
        'then employee class has no field with a name that is longer than Postgres max name limit.',
        () {
      var fields = employeeDefinition?.fields
          .where((element) =>
              element.name.length > DatabaseConstants.pgsqlMaxNameLimitation)
          .map((e) => e.name)
          .toList();

      expect(
        fields,
        isEmpty,
        reason:
            'Expected no fields with a name longer than ${DatabaseConstants.pgsqlMaxNameLimitation} chars',
      );
    }, skip: employeeDefinition == null);
  });

  group(
      'Given a class with an implicit named list relation when analyzing model',
      () {
    var models = [
      ModelSourceBuilder().withFileName('employee').withYaml(
        '''
        class: Employee
        table: employee
        fields:
          name: String
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa: Company?, relation(name=company_employee)
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('company').withYaml(
        '''
        class: Company
        table: company
        fields:
          employees: List<Employee>?, relation(name=company_employee)
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );

    var definitions = analyzer.validateAll();

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    var employeeDefinition = definitions
        .where(
          (classes) => classes.className == 'Employee',
        )
        .firstOrNull as ClassDefinition?;

    test('then employee class definition is created.', () {
      expect(employeeDefinition, isNotNull);
    });

    test(
        'then employee class has no field with a name that is longer than Postgres max name limit.',
        () {
      var fields = employeeDefinition?.fields
          .where((element) =>
              element.name.length > DatabaseConstants.pgsqlMaxNameLimitation)
          .map((e) => e.name)
          .toList();

      expect(
        fields,
        isEmpty,
        reason:
            'Expected no fields with a name longer than ${DatabaseConstants.pgsqlMaxNameLimitation} chars',
      );
    }, skip: employeeDefinition == null);
  });
}

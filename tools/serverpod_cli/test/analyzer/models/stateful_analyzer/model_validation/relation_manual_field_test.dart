import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  group(
      'Given a class with a relation with a defined field name that holds the relation',
      () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          myParentId: int
          parent: ExampleParent?, relation(field=myParentId)
        indexes:
          my_parent_index_idx:
            fields: myParentId
            unique: true
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
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var exampleClass = definitions.first as ClassDefinition;

    test('then no errors were collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then the implicit parentId field is NOT created', () {
      var field = exampleClass.findField('parentId');
      expect(field, isNull);
    });

    test('then the relation field pointer is set on the object relation.', () {
      var relation = exampleClass.findField('parent')?.relation;
      expect(relation.runtimeType, ObjectRelationDefinition);
      expect(
        (relation as ObjectRelationDefinition).fieldName,
        'myParentId',
      );
    });

    test('then the parent field is set to NOT persist.', () {
      var field = exampleClass.findField('parent');
      expect(field?.shouldPersist, isFalse);
    });
  });

  group('Given a class with a relation pointing to a field that does not exist',
      () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  parent: Example?, relation(field=myParentId)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer =
        StatefulAnalyzer(protocols, onErrorsCollector(collector));
    analyzer.validateAll();

    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test('then the error message reports that the field is missing.', () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The field "myParentId" was not found in the class.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field value location.', () {
      var span = collector.errors.first.span;

      expect(span?.start.line, 3);
      expect(span?.start.column, 35);

      expect(span?.end.line, 3);
      expect(span?.end.column, 35 + 'myParentId'.length);
    }, skip: errors.isEmpty);
  });

  group('Given a class with a List relation with a field pointer defined', () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  myChildId: int
  child: List<ExampleChild>?, relation(field=myChildId)
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('example_child').withYaml(
        '''
class: ExampleChild
table: example_child
fields:
  name: String
  exampleId: int, relation(parent=example)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer =
        StatefulAnalyzer(protocols, onErrorsCollector(collector));
    analyzer.validateAll();

    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field keyword cannot be used on a List relation.',
        () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The "field" property can only be used on an object relation.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = collector.errors.first.span;

      expect(span?.start.line, 4);
      expect(span?.start.column, 39);

      expect(span?.end.line, 4);
      expect(span?.end.column, 39 + 'field'.length);
    }, skip: errors.isEmpty);
  });

  group('Given a class with an id relation with a field pointer defined', () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  otherId: int
  exampleChildId: int, relation(parent=example_child, field=otherId)
          ''',
      ).build(),
      ModelSourceBuilder().withFileName('example_child').withYaml(
        '''
class: ExampleChild
table: example_child
fields:
  name: String
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();
    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field keyword cannot be used on an id relation.',
        () {
      var error = errors.first;
      expect(
        error.message,
        'The "field" property can only be used on an object relation.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = errors.first.span;
      expect(span?.start.line, 4);
      expect(span?.start.column, 54);
      expect(span?.end.line, 4);
      expect(span?.end.column, 54 + 'field'.length);
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a relation pointing to a field with a mismatching type to the reference',
      () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  myParentId: String
  parent: Example?, relation(field=myParentId)
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();
    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field has a mismatching type to the reference.',
        () {
      var error = errors.first;
      expect(
        error.message,
        'The field "myParentId" is of type "String" but reference field "id" is of type "int".',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = errors.first.span;
      expect(span?.start.line, 4);
      expect(span?.start.column, 35);
      expect(span?.end.line, 4);
      expect(span?.end.column, 35 + 'myParentId'.length);
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a relation pointing to a field that is set to not persist',
      () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  myParentId: int, !persist
  parent: Example?, relation(field=myParentId)
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();
    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field is not persisted and cannot be used in a relation.',
        () {
      var error = errors.first;
      expect(
        error.message,
        'The field "myParentId" is not persisted and cannot be used in a relation.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = errors.first.span;
      expect(span?.start.line, 4);
      expect(span?.start.column, 35);
      expect(span?.end.line, 4);
      expect(span?.end.column, 35 + 'myParentId'.length);
    }, skip: errors.isEmpty);
  });

  group(
      'Given two classes with a named relation with a defined field name that holds the relation',
      () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parentId: int?
          parent: ExampleParent?, relation(name=example_parent, field=parentId)
        indexes:
          parent_index_idx:
            fields: parentId
            unique: true
        
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('example_parent').withYaml(
        '''
        class: ExampleParent
        table: example_parent
        fields:
          name: String
          example: Example?, relation(name=example_parent)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var exampleClass = definitions.first as ClassDefinition;
    var exampleParentClass = definitions.last as ClassDefinition;

    test('then no errors were collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then parentId is nullable', () {
      var field = exampleClass.findField('parentId');
      expect(field?.type.nullable, isTrue);
    });

    test('then parent field has a nullable relation.', () {
      var field = exampleClass.findField('parent');
      var relation = field!.relation as ObjectRelationDefinition;
      expect(relation.nullableRelation, isTrue);
    });

    group('then the foreign side', () {
      var field = exampleParentClass.findField('example');
      var relation = field!.relation;

      test('has an object relation', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('has a nullable relation', () {
        expect((relation as ObjectRelationDefinition).nullableRelation, isTrue);
      }, skip: relation is! ObjectRelationDefinition);
    });
  });

  group(
      'Given a class with a relation pointing to a field that already has a relation',
      () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parentId: int, relation(parent=example_parent)
          parent: ExampleParent?, relation(name=example_parent, field=parentId)
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('example_parent').withYaml(
        '''
        class: ExampleParent
        table: example_parent
        fields:
          name: String
          example: Example?, relation(name=example_parent)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the relation points to a field that already has a relation.',
        () {
      var error = errors.first;
      expect(
        error.message,
        'The field "parentId" already has a relation and cannot be used as relation field.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the relation field location.', () {
      var span = errors.first.span;
      expect(span?.start.line, 4);
      expect(span?.start.column, 70);
      expect(span?.end.line, 4);
      expect(span?.end.column, 70 + 'parentId'.length);
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a named object relation on both sides with foreign key field without unique index',
      () {
    var protocols = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          addressId: int
          address: Address?, relation(name=user_address, field=addressId)
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('address').withYaml(
        '''
        class: Address
        table: address
        fields:
          user: User?, relation(name=user_address)
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    analyzer.validateAll();

    var errors = collector.errors;

    test('then an error is collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error messages says that there must be a unique index on the field.',
        () {
      expect(
        errors.first.message,
        'The field "addressId" does not have a unique index which is required to be used in a one-to-one relation.',
      );
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a named object relation on both sides with foreign key field in not unique index',
      () {
    var protocols = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          addressId: int
          address: Address?, relation(name=user_address, field=addressId)
        indexes:
          address_index_idx:
            fields: addressId
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('address').withYaml(
        '''
        class: Address
        table: address
        fields:
          user: User?, relation(name=user_address)
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    analyzer.validateAll();

    var errors = collector.errors;

    test('then an error is collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error messages says that there must be a unique index on the field.',
        () {
      expect(
        errors.first.message,
        'The field "addressId" does not have a unique index which is required to be used in a one-to-one relation.',
      );
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a named object relation on both sides with foreign key field in unique index with multiple fields',
      () {
    var protocols = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          name: String
          addressId: int
          address: Address?, relation(name=user_address, field=addressId)
        indexes:
          address_index_idx:
            fields: addressId, name
            unique: true
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('address').withYaml(
        '''
        class: Address
        table: address
        fields:
          user: User?, relation(name=user_address)
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    analyzer.validateAll();

    var errors = collector.errors;

    test('then an error is collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error messages says that there must be a unique index on the field.',
        () {
      expect(
        errors.first.message,
        'The field "addressId" does not have a unique index which is required to be used in a one-to-one relation.',
      );
    }, skip: errors.isEmpty);
  });
}

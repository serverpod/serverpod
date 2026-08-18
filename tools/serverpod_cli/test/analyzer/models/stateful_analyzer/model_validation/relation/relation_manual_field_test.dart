import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  group(
    'Given a class with a relation with a defined field name that holds the relation',
    () {
      var models = [
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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var exampleClass = definitions.first as ClassDefinition;

      test('then no errors were collected', () {
        expect(collector.errors, isEmpty);
      });

      test('then the implicit parentId field is NOT created', () {
        var field = exampleClass.findField('parentId');
        expect(field, isNull);
      });

      test(
        'then the relation field pointer is set on the object relation.',
        () {
          var relation = exampleClass.findField('parent')?.relation;
          expect(relation.runtimeType, ObjectRelationDefinition);
          expect(
            (relation as ObjectRelationDefinition).fieldName,
            'myParentId',
          );
        },
      );

      test('then the parent field is set to NOT persist.', () {
        var field = exampleClass.findField('parent');
        expect(field?.shouldPersist, isFalse);
      });
    },
  );

  group(
    'Given a class with a relation that names a foreign key field that is not declared, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;
      late final ClassDefinition exampleClass;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          parent: ExampleParent?, relation(field=myParentId)
        ''',
          ).build(),
          ModelSourceBuilder().withFileName('example_parent').withYaml(
            '''
        class: ExampleParent
        table: example_parent
        fields:
          name: String
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();
        exampleClass = definitions.first as ClassDefinition;
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test(
        'then a persisted non-nullable integer foreign key field named myParentId is created.',
        () {
          var field = exampleClass.findField('myParentId');
          expect(field, isNotNull);
          expect(field?.shouldPersist, isTrue);
          expect(field?.type.className, 'int');
          expect(field?.type.nullable, isFalse);
        },
      );

      test('then the implicit parentId field is not created.', () {
        var field = exampleClass.findField('parentId');
        expect(field, isNull);
      });

      test(
        'then the object relation points at the named foreign key field.',
        () {
          var relation = exampleClass.findField('parent')?.relation;
          expect(relation, isA<ObjectRelationDefinition>());
          expect(
            (relation as ObjectRelationDefinition).fieldName,
            'myParentId',
          );
        },
      );

      test(
        'then the generated foreign key field is inserted before the object relation field.',
        () {
          expect(
            exampleClass.fields.map((field) => field.name),
            ['id', 'myParentId', 'parent'],
          );
        },
      );

      test(
        'then the generated foreign key field is documented as the foreign key of the parent relation.',
        () {
          expect(
            exampleClass.findField('myParentId')?.documentation,
            ['/// The foreign key of the [parent] relation.'],
          );
        },
      );
    },
  );

  group(
    'Given a class with a relation that names an undeclared foreign key field to a model with a UuidValue id, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;
      late final ClassDefinition exampleClass;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          parent: ExampleParent?, relation(field=myParentId)
        ''',
          ).build(),
          ModelSourceBuilder().withFileName('example_parent').withYaml(
            '''
        class: ExampleParent
        table: example_parent
        fields:
          id: UuidValue, defaultModel=random
          name: String
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();
        exampleClass = definitions.first as ClassDefinition;
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test(
        'then the generated foreign key field has the UuidValue type.',
        () {
          var field = exampleClass.findField('myParentId');
          expect(field?.type.className, 'UuidValue');
          expect(field?.type.nullable, isFalse);
        },
      );
    },
  );

  group(
    'Given a class with an optional relation that names a foreign key field that is not declared, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;
      late final ClassDefinition exampleClass;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          parent: ExampleParent?, relation(optional, field=myParentId)
        ''',
          ).build(),
          ModelSourceBuilder().withFileName('example_parent').withYaml(
            '''
        class: ExampleParent
        table: example_parent
        fields:
          name: String
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();
        exampleClass = definitions.first as ClassDefinition;
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test('then the generated foreign key field is nullable.', () {
        var field = exampleClass.findField('myParentId');
        expect(field?.type.nullable, isTrue);
      });
    },
  );

  group(
    'Given a named one-to-one relation that names an undeclared foreign key field with a unique index, '
    'when the models are analyzed,',
    () {
      late final CodeGenerationCollector collector;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withFileName('user').withYaml(
            '''
        class: User
        table: user
        fields:
          address: Address?, relation(name=user_address, field=addressId)
        indexes:
          address_index_idx:
            fields: addressId
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

        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });
    },
  );

  group(
    'Given a named one-to-one relation that names an undeclared foreign key field without a unique index, '
    'when the models are analyzed,',
    () {
      late final CodeGenerationCollector collector;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withFileName('user').withYaml(
            '''
        class: User
        table: user
        fields:
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

        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test(
        'then an error is collected that the field does not have a unique index.',
        () {
          expect(collector.errors, isNotEmpty);
          expect(
            collector.errors.first.message,
            'The field "addressId" does not have a unique index which is required to be used in a one-to-one relation.',
          );
        },
      );
    },
  );

  group('Given a class with a List relation with a field pointer defined', () {
    var models = [
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
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
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
      },
      skip: errors.isEmpty,
    );

    test(
      'then the error is reported at the field key location.',
      () {
        var span = collector.errors.first.span;

        expect(span?.start.line, 4);
        expect(span?.start.column, 39);

        expect(span?.end.line, 4);
        expect(span?.end.column, 39 + 'field'.length);
      },
      skip: errors.isEmpty,
    );
  });

  group('Given a class with an id relation with a field pointer defined', () {
    var models = [
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
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();
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
      },
      skip: errors.isEmpty,
    );

    test(
      'then the error is reported at the field key location.',
      () {
        var span = errors.first.span;
        expect(span?.start.line, 4);
        expect(span?.start.column, 54);
        expect(span?.end.line, 4);
        expect(span?.end.column, 54 + 'field'.length);
      },
      skip: errors.isEmpty,
    );
  });

  group(
    'Given a class with a relation pointing to a field with a mismatching type to the reference',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  myParentId: String
  parent: Example?, relation(field=myParentId)
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
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
        },
        skip: errors.isEmpty,
      );

      test(
        'then the error is reported at the field key location.',
        () {
          var span = errors.first.span;
          expect(span?.start.line, 4);
          expect(span?.start.column, 35);
          expect(span?.end.line, 4);
          expect(span?.end.column, 35 + 'myParentId'.length);
        },
        skip: errors.isEmpty,
      );
    },
  );

  group(
    'Given a class with a relation pointing to a field that is set to not persist',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  myParentId: int, !persist
  parent: Example?, relation(field=myParentId)
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
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
        },
        skip: errors.isEmpty,
      );

      test(
        'then the error is reported at the field key location.',
        () {
          var span = errors.first.span;
          expect(span?.start.line, 4);
          expect(span?.start.column, 35);
          expect(span?.end.line, 4);
          expect(span?.end.column, 35 + 'myParentId'.length);
        },
        skip: errors.isEmpty,
      );
    },
  );

  group(
    'Given a class with an optional relation pointing to a non-nullable foreign key field, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;

      setUpAll(() {
        var models = [
          ModelSourceBuilder()
              .withYaml(
                '''
                class: Example
                table: example
                fields:
                  manualId: int
                  relationObject: Example?, relation(optional, field=manualId)
                ''',
              )
              .withFileName('example_class')
              .build(),
        ];

        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test(
        'then an error is collected that the optional relation requires a nullable foreign key field.',
        () {
          expect(
            collector.errors.map((e) => e.message),
            contains(
              'An optional relation requires the foreign key field "manualId" to be nullable.',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a class with an optional relation pointing to a nullable foreign key field, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;

      setUpAll(() {
        var models = [
          ModelSourceBuilder()
              .withYaml(
                '''
                class: Example
                table: example
                fields:
                  manualId: int?
                  relationObject: Example?, relation(optional, field=manualId)
                ''',
              )
              .withFileName('example_class')
              .build(),
        ];

        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });
    },
  );

  group(
    'Given an optional named one-to-one relation on the side that does not hold '
    'the foreign key of a class with a non-nullable id, '
    'when the models are analyzed,',
    () {
      late final CodeGenerationCollector collector;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withFileName('company').withYaml(
            '''
        class: Company
        table: company
        fields:
          id: UuidValue, defaultModel=random
          member: Member?, relation(name=company_member, optional)
        ''',
          ).build(),
          ModelSourceBuilder().withFileName('member').withYaml(
            '''
        class: Member
        table: member
        fields:
          id: UuidValue, defaultModel=random
          company: Company?, relation(name=company_member, field=companyId)
        indexes:
          member_company_idx:
            fields: companyId
            unique: true
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });
    },
  );

  group(
    'Given two classes with a named relation with a defined field name that holds the relation',
    () {
      var models = [
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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
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
          expect(
            (relation as ObjectRelationDefinition).nullableRelation,
            isTrue,
          );
        }, skip: relation is! ObjectRelationDefinition);
      });
    },
  );

  group(
    'Given a class with a relation pointing to a field that already has a relation',
    () {
      var models = [
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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

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
        },
        skip: errors.isEmpty,
      );

      test(
        'then the error is reported at the relation field location.',
        () {
          var span = errors.first.span;
          expect(span?.start.line, 4);
          expect(span?.start.column, 70);
          expect(span?.end.line, 4);
          expect(span?.end.column, 70 + 'parentId'.length);
        },
        skip: errors.isEmpty,
      );
    },
  );

  group(
    'Given a class with a named object relation on both sides with foreign key field without unique index',
    () {
      var models = [
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
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
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
        },
        skip: errors.isEmpty,
      );
    },
  );

  group(
    'Given a class with a named object relation on both sides with foreign key field in not unique index',
    () {
      var models = [
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
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
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
        },
        skip: errors.isEmpty,
      );
    },
  );

  group(
    'Given a class with a named object relation on both sides with foreign key field in unique index with multiple fields',
    () {
      var models = [
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
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
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
        },
        skip: errors.isEmpty,
      );
    },
  );
}

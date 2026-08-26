import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
    'Given a named one-to-one relation with fk on one side and a unique index on the generated foreign key, '
    'when the models are analyzed,',
    () {
      late final CodeGenerationCollector collector;
      late final ClassDefinition userDefinition;
      late final ClassDefinition addressDefinition;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withFileName('user').withYaml(
            '''
        class: User
        table: user
        fields:
          address: Address?, relation(name=user_address, fk)
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
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        userDefinition = definitions.whereType<ClassDefinition>().firstWhere(
          (definition) => definition.className == 'User',
        );
        addressDefinition = definitions.whereType<ClassDefinition>().firstWhere(
          (definition) => definition.className == 'Address',
        );
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test(
        'then the addressId foreign key field is generated on the fk side.',
        () {
          var field = userDefinition.findField('addressId');
          expect(field, isNotNull);
          expect(field?.shouldPersist, isTrue);
          expect(field?.type.className, 'int');
          expect(field?.type.nullable, isFalse);
          expect(field?.relation, isA<ForeignRelationDefinition>());
        },
      );

      test('then the object relation on the fk side points at addressId.', () {
        var relation = userDefinition.findField('address')?.relation;
        expect(relation, isA<ObjectRelationDefinition>());
        expect((relation as ObjectRelationDefinition).fieldName, 'addressId');
        expect(relation.isForeignKeyOrigin, isTrue);
      });

      test('then no foreign key field is generated on the other side.', () {
        expect(addressDefinition.findField('userId'), isNull);
      });
    },
  );

  group(
    'Given a named one-to-one relation with an optional fk, '
    'when the models are analyzed,',
    () {
      late final CodeGenerationCollector collector;
      late final ClassDefinition userDefinition;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withFileName('user').withYaml(
            '''
        class: User
        table: user
        fields:
          address: Address?, relation(name=user_address, optional, fk)
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
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        userDefinition = definitions.whereType<ClassDefinition>().firstWhere(
          (definition) => definition.className == 'User',
        );
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test('then the generated foreign key field is nullable.', () {
        expect(userDefinition.findField('addressId')?.type.nullable, isTrue);
      });
    },
  );

  group(
    'Given a named one-to-many relation with fk on the object side, '
    'when the models are analyzed,',
    () {
      late final CodeGenerationCollector collector;
      late final ClassDefinition orderDefinition;
      late final ClassDefinition customerDefinition;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withFileName('customer').withYaml(
            '''
        class: Customer
        table: customer
        fields:
          orders: List<Order>?, relation(name=customer_order)
        ''',
          ).build(),
          ModelSourceBuilder().withFileName('order').withYaml(
            '''
        class: Order
        table: order
        fields:
          customer: Customer?, relation(name=customer_order, fk)
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        customerDefinition = definitions
            .whereType<ClassDefinition>()
            .firstWhere(
              (definition) => definition.className == 'Customer',
            );
        orderDefinition = definitions.whereType<ClassDefinition>().firstWhere(
          (definition) => definition.className == 'Order',
        );
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test(
        'then the customerId foreign key field is generated on the order.',
        () {
          var field = orderDefinition.findField('customerId');
          expect(field, isNotNull);
          expect(field?.relation, isA<ForeignRelationDefinition>());
        },
      );

      test('then the list relation points at the generated foreign key.', () {
        var relation = customerDefinition.findField('orders')?.relation;
        expect(relation, isA<ListRelationDefinition>());
        expect(
          (relation as ListRelationDefinition).foreignFieldName,
          'customerId',
        );
      });
    },
  );

  group(
    'Given an optional fk relation with "serverOnly" scope, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;
      late final ClassDefinition commentDefinition;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withFileName('post').withYaml(
            '''
        class: Post
        table: post
        fields:
          title: String
        ''',
          ).build(),
          ModelSourceBuilder().withFileName('comment').withYaml(
            '''
        class: Comment
        table: comment
        fields:
          post: Post?, relation(fk, optional), scope=serverOnly
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        commentDefinition = definitions.whereType<ClassDefinition>().firstWhere(
          (definition) => definition.className == 'Comment',
        );
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test('then the generated foreign key field is nullable.', () {
        expect(commentDefinition.findField('postId')?.type.nullable, isTrue);
      });
    },
  );

  group(
    'Given an optional relation on the side that does not hold the foreign key '
    'of a class with a non-nullable id, while the other side uses fk, '
    'when the models are analyzed,',
    () {
      late final CodeGenerationCollector collector;
      late final ClassDefinition memberDefinition;

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
          company: Company?, relation(name=company_member, fk)
        indexes:
          member_company_idx:
            fields: companyId
            unique: true
        ''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        memberDefinition = definitions.whereType<ClassDefinition>().firstWhere(
          (definition) => definition.className == 'Member',
        );
      });

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test(
        'then the generated companyId field has the parent table id type.',
        () {
          var field = memberDefinition.findField('companyId');
          expect(field?.type.className, 'UuidValue');
        },
      );
    },
  );

  group(
    'Given a relation that sets both fk and field, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          parent: ExampleParent?, relation(fk, field=myParentId)
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
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then only one error is collected.', () {
        expect(collector.errors.length, 1);
      });

      test(
        'then an error is collected that fk and field are mutually exclusive.',
        () {
          expect(
            collector.errors.single.message,
            'The "fk" property is mutually exclusive with the "field" property.',
          );
        },
      );
    },
  );

  group(
    'Given a list relation with the fk property, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          children: List<ExampleChild>?, relation(fk)
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

        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test(
        'then an error is collected that fk can only be used on an object relation.',
        () {
          expect(
            collector.errors.single.message,
            'The "fk" property can only be used on an object relation.',
          );
        },
      );
    },
  );

  group(
    'Given a named one-to-one relation with fk on both sides, '
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
          address: Address?, relation(name=user_address, fk)
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
          user: User?, relation(name=user_address, fk)
        indexes:
          user_index_idx:
            fields: userId
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

      test(
        'then each side reports the same error that only one may store the foreign key.',
        () {
          expect(collector.errors.length, 2);
          expect(
            collector.errors.map((error) => error.message).toSet().single,
            'Only one side of the relation is allowed to store the foreign key, '
            'remove the "fk" property from one side.',
          );
        },
      );
    },
  );

  group(
    'Given a named one-to-one relation with fk on one side without a unique index, '
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
          address: Address?, relation(name=user_address, fk)
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
        'then an error is collected that the generated foreign key does not have a unique index.',
        () {
          expect(
            collector.errors.single.message,
            'The referenced field "addressId" does not have a unique index '
            'which is required to be used in a one-to-one relation.',
          );
        },
      );
    },
  );

  group(
    'Given a non-optional fk relation with "serverOnly" scope, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withFileName('post').withYaml(
            '''
        class: Post
        table: post
        fields:
          title: String
        ''',
          ).build(),
          ModelSourceBuilder().withFileName('comment').withYaml(
            '''
        class: Comment
        table: comment
        fields:
          post: Post?, relation(fk), scope=serverOnly
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
        'then an error is collected that the relation must be optional.',
        () {
          expect(
            collector.errors.single.message,
            'The relation with scope "serverOnly" requires the relation to be optional.',
          );
        },
      );
    },
  );

  group(
    'Given an id field relation with the fk property, '
    'when the model is analyzed,',
    () {
      late final CodeGenerationCollector collector;

      setUpAll(() {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          parentId: int, relation(parent=example_parent, fk)
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
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test(
        'then an error is collected that fk can only be used on an object relation.',
        () {
          expect(
            collector.errors.single.message,
            'The "fk" property can only be used on an object relation.',
          );
        },
      );
    },
  );

  group(
    'Given a named one-to-one relation with fk on one side and field on the other, '
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
          address: Address?, relation(name=user_address, fk)
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
          user: User?, relation(name=user_address, field=userId)
          userId: int
        indexes:
          user_index_idx:
            fields: userId
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

      test(
        'then each side reports that only one may store the foreign key.',
        () {
          expect(collector.errors.length, 2);
          expect(
            collector.errors.map((error) => error.message).toSet(),
            {
              'Only one side of the relation is allowed to store the foreign '
                  'key, remove the "fk" property from one side.',
              'Only one side of the relation is allowed to store the foreign '
                  'key, remove the specified "field" reference from one side.',
            },
          );
        },
      );
    },
  );
}

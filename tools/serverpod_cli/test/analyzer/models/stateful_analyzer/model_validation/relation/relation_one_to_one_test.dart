import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
      'Given a class with a only a foreign key field defined for the relation',
      () {
    var models = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          addressId: int, relation(parent=address)
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
          street: String
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var userDefinition = definitions.first as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    group('then a relation is defined on the addressId', () {
      var relation = userDefinition.findField('addressId')?.relation;

      test('and has the relation type ForeignRelation', () {
        expect(
          relation.runtimeType,
          ForeignRelationDefinition,
        );
      });

      test('and has the foreignFieldName set to "id"', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.foreignFieldName,
          'id',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the parent table is set to address', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.parentTable,
          'address',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the foreignContainerField is null.', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.foreignContainerField,
          isNull,
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the containerField is null.', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.containerField,
          isNull,
        );
      }, skip: relation is! ForeignRelationDefinition);
    });
  });

  group(
      'Given a class with a only a foreign key field defined for the relation',
      () {
    var models = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          address: Address?, relation
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
          street: String
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var userDefinition = definitions.first as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    group('then a relation is defined on the addressId', () {
      var relation = userDefinition.findField('addressId')?.relation;

      test('and has the relation type ForeignRelation', () {
        expect(
          relation.runtimeType,
          ForeignRelationDefinition,
        );
      });

      test('and has the foreignFieldName set to "id"', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.foreignFieldName,
          'id',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the parent table is set to address', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.parentTable,
          'address',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the foreignContainerField is null.', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.foreignContainerField,
          isNull,
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the containerField is null.', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.containerField?.name,
          'address',
        );
      }, skip: relation is! ForeignRelationDefinition);
    });

    group('then the address field has a relation', () {
      var relation = userDefinition.findField('address')?.relation;
      test('of ObjectRelation type', () {
        expect(
          relation.runtimeType,
          ObjectRelationDefinition,
        );
      });

      test('has the nullableRelation set to false', () {
        expect((relation as ObjectRelationDefinition).nullableRelation, false);
      }, skip: relation is! ObjectRelationDefinition);

      test('without a name for the relation', () {
        expect(relation?.name, isNull);
      }, skip: relation is! ObjectRelationDefinition);

      test('with the foreignContainerField set to null.', () {
        var relationObject = relation as ObjectRelationDefinition;

        expect(relationObject.foreignContainerField, isNull);
      }, skip: relation is! ObjectRelationDefinition);
    });
  });

  group(
      'Given a class with a foreign key and object relation field defined for the relation',
      () {
    var models = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          addressId: int
          address: Address?, relation(field=addressId)
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
          street: String
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var userDefinition = definitions.first as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    group('then a relation is defined on the addressId', () {
      var relation = userDefinition.findField('addressId')?.relation;

      test('and has the relation type ForeignRelation', () {
        expect(
          relation.runtimeType,
          ForeignRelationDefinition,
        );
      });

      test('and has the foreignFieldName set to "id"', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.foreignFieldName,
          'id',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the parent table is set to address', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.parentTable,
          'address',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the foreignContainerField is null.', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.foreignContainerField,
          isNull,
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and has the containerField set.', () {
        var foreignRelation = relation as ForeignRelationDefinition;
        var containerField = userDefinition.findField('address');

        expect(
          foreignRelation.containerField,
          containerField,
        );
      }, skip: relation is! ForeignRelationDefinition);
    });

    group('then the address field has a relation', () {
      var relation = userDefinition.findField('address')?.relation;
      test('of ObjectRelation type', () {
        expect(
          relation.runtimeType,
          ObjectRelationDefinition,
        );
      });

      test('has the nullableRelation set to false', () {
        expect((relation as ObjectRelationDefinition).nullableRelation, false);
      }, skip: relation is! ObjectRelationDefinition);

      test('without a name for the relation', () {
        expect(relation?.name, isNull);
      }, skip: relation is! ObjectRelationDefinition);

      test('with the foreignContainerField set to null.', () {
        var relationObject = relation as ObjectRelationDefinition;

        expect(relationObject.foreignContainerField, isNull);
      }, skip: relation is! ObjectRelationDefinition);
    });
  });

  group(
      'Given a class with a foreign key field and named object relation on the other side',
      () {
    var models = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          addressId: int, relation(name=user_address, parent=address)
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

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var userDefinition = definitions.first as ClassDefinition;
    var addressDefinition = definitions.last as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    group('then a relation is defined on the addressId', () {
      var relation = userDefinition.findField('addressId')?.relation;

      test('and has the relation type ForeignRelation', () {
        expect(
          relation.runtimeType,
          ForeignRelationDefinition,
        );
      });

      test('and has the foreignFieldName set to "id"', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.foreignFieldName,
          'id',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the parent table is set to address', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.parentTable,
          'address',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and has the foreignContainerField set.', () {
        var foreignRelation = relation as ForeignRelationDefinition;
        var foreignField = addressDefinition.findField('user');

        expect(
          foreignRelation.foreignContainerField,
          foreignField,
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the containerField is null.', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.containerField,
          isNull,
        );
      }, skip: relation is! ForeignRelationDefinition);
    });

    group('then the user relation', () {
      var relation = addressDefinition.findField('user')?.relation;

      test('has the relation name set', () {
        expect(relation?.name, 'user_address');
      });

      test('is an ObjectRelationDefinition', () {
        expect(
          relation.runtimeType,
          ObjectRelationDefinition,
          reason: 'Expected the relation to be an ObjectRelationDefinition.',
        );
      });

      test('has the nullableRelation set to false', () {
        expect((relation as ObjectRelationDefinition).nullableRelation, false);
      });

      test('has the parent table is set', () {
        var validateRelation = relation as ObjectRelationDefinition;

        expect(validateRelation.parentTable, 'user');
      }, skip: relation is! ObjectRelationDefinition);

      test(
          'has the foreignFieldName defined to the foreign key field on the other side.',
          () {
        var validateRelation = relation as ObjectRelationDefinition;

        expect(validateRelation.foreignFieldName, 'addressId');
      }, skip: relation is! ObjectRelationDefinition);

      test('has the fieldName defined to the primary key on this side.', () {
        var validateRelation = relation as ObjectRelationDefinition;

        expect(validateRelation.fieldName, 'id');
      }, skip: relation is! ObjectRelationDefinition);

      test('with the foreignContainerField set to null.', () {
        var relationObject = relation as ObjectRelationDefinition;

        expect(relationObject.foreignContainerField, isNull);
      }, skip: relation is! ObjectRelationDefinition);
    });
  });
  group(
      'Given a class with a named object relation on both sides with a field references',
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
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var userDefinition = definitions.first as ClassDefinition;
    var addressDefinition = definitions.last as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    test(
        'then no id field was created for the side without the field pointer defined.',
        () {
      expect(
        addressDefinition.findField('userId'),
        isNull,
        reason: 'Expected userId to not exist as a field, but it did.',
      );
    }, skip: errors.isNotEmpty);

    group('then the user relation', () {
      var relation = addressDefinition.findField('user')?.relation;

      test('has the relation name set', () {
        expect(relation?.name, 'user_address');
      });

      test('is an ObjectRelationDefinition', () {
        expect(
          relation.runtimeType,
          ObjectRelationDefinition,
          reason: 'Expected the relation to be an ObjectRelationDefinition.',
        );
      });

      test('has the nullableRelation set to false', () {
        expect((relation as ObjectRelationDefinition).nullableRelation, false);
      });

      test('has the parent table is set', () {
        var validateRelation = relation as ObjectRelationDefinition;

        expect(validateRelation.parentTable, 'user');
      }, skip: relation is! ObjectRelationDefinition);

      test(
          'has the foreignFieldName defined to the foreign key field on the other side.',
          () {
        var validateRelation = relation as ObjectRelationDefinition;

        expect(validateRelation.foreignFieldName, 'addressId');
      }, skip: relation is! ObjectRelationDefinition);

      test('has the fieldName defined to the primary key on this side.', () {
        var validateRelation = relation as ObjectRelationDefinition;

        expect(validateRelation.fieldName, 'id');
      }, skip: relation is! ObjectRelationDefinition);

      test('with the foreignContainerField set.', () {
        var relationObject = relation as ObjectRelationDefinition;

        expect(relationObject.foreignContainerField?.name, 'address');
      }, skip: relation is! ObjectRelationDefinition);
    });

    test('then the defined addressId field exists.', () {
      expect(
        userDefinition.findField('addressId'),
        isNotNull,
      );
    }, skip: errors.isNotEmpty);

    group('then a relation is defined on the addressId', () {
      var relation = userDefinition.findField('addressId')?.relation;

      test('and has the relation type ForeignRelation', () {
        expect(
          relation.runtimeType,
          ForeignRelationDefinition,
        );
      });

      test('and has the foreignFieldName set to "id"', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.foreignFieldName,
          'id',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the parent table is set to address', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.parentTable,
          'address',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the relation name is set to the user defined relation name.',
          () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.name,
          'user_address',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and has the foreignContainerField set.', () {
        var foreignRelation = relation as ForeignRelationDefinition;
        var foreignField = addressDefinition.findField('user');

        expect(
          foreignRelation.foreignContainerField,
          foreignField,
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and has the containerField set.', () {
        var foreignRelation = relation as ForeignRelationDefinition;
        var containerField = userDefinition.findField('address');

        expect(
          foreignRelation.containerField,
          containerField,
        );
      }, skip: relation is! ForeignRelationDefinition);
    });

    group('then the address field has a relation', () {
      var relation = userDefinition.findField('address')?.relation;
      test('of ObjectRelation type', () {
        expect(
          relation.runtimeType,
          ObjectRelationDefinition,
        );
      });

      test('has the nullableRelation set to false', () {
        expect((relation as ObjectRelationDefinition).nullableRelation, false);
      }, skip: relation is! ObjectRelationDefinition);

      test('without a name for the relation', () {
        expect(relation?.name, isNull);
      }, skip: relation is! ObjectRelationDefinition);

      test('with the foreignContainerField set.', () {
        var relationObject = relation as ObjectRelationDefinition;

        expect(relationObject.foreignContainerField?.name, 'user');
      }, skip: relation is! ObjectRelationDefinition);
    });
  });

  group(
      'Given a class with a named object relation on both sides without a field references',
      () {
    var models = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          address: Address?, relation(name=user_address)
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
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    var errors = collector.errors;

    test('then an error is collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error messages tells the user the relation is ambiguous and the field references should be used.',
        () {
      expect(
        errors.first.message,
        'The relation is ambiguous, unable to resolve which side should hold the relation. Use the field reference syntax to resolve the ambiguity. E.g. relation(name=user_address, field=addressId)',
      );

      expect(
        errors.last.message,
        'The relation is ambiguous, unable to resolve which side should hold the relation. Use the field reference syntax to resolve the ambiguity. E.g. relation(name=user_address, field=userId)',
      );
    }, skip: errors.isEmpty);
  });

  test(
      'Given a class with a one to one relation where the relationship is ambiguous then an error is collected that the reference cannot be resolved.',
      () {
    var models = [
      ModelSourceBuilder().withFileName('company').withYaml(
        '''
        class: Company
        table: company
        fields:
          addressId: int
          address: Address?, relation(name=company_address, field=addressId)
          oldAddressId: int
          oldAddress: Address?, relation(name=company_address, field=oldAddressId)
        indexes:
          address_index_idx:
            fields: addressId
            unique: true
          old_address_index_idx:
            fields: oldAddressId
            unique: true
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('address').withYaml(
        '''
        class: Address
        table: address
        fields:
          company: Company?, relation(name=company_address)
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error but none was found.',
    );

    var error = collector.errors.first;

    expect(
      error.message,
      'Unable to resolve ambiguous relation, there are several named relations with name "company_address" on the class "Company".',
    );
  });

  test(
      'Given a class with a one to one relation where the id column is manually defined on both sides of the relation, then give an error that the field only can be defined on one side.',
      () {
    var models = [
      ModelSourceBuilder().withFileName('company').withYaml(
        '''
        class: Company
        table: company
        fields:
          addressId: int
          address: Address?, relation(name=company_address, field=addressId)
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
          addressCompanyId: int
          addressCompany: Company?, relation(name=company_address, field=addressCompanyId)
        indexes:
          address_company_index_idx:
            fields: addressCompanyId
            unique: true
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      hasLength(greaterThan(1)),
      reason: 'Expected an error but none was found.',
    );

    expect(
      collector.errors.first.message,
      'Only one side of the relation is allowed to store the foreign key, remove the specified "field" reference from one side.',
    );

    expect(
      collector.errors.last.message,
      'Only one side of the relation is allowed to store the foreign key, remove the specified "field" reference from one side.',
    );
  });

  group(
      'Given a class with a one to one relation where the relationship is only named on one side',
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
            unique: true
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('address').withYaml(
        '''
        class: Address
        table: address
        fields:
          user: User?, relation
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    var errors = collector.errors;
    test('then an error is collected', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error messages says that there must be a named relation on the other side.',
        () {
      expect(
        errors.first.message,
        'There is no named relation with name "user_address" on the class "Address".',
      );
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a named object relation to a foreign id relation field that has unique index',
      () {
    var models = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          name: String
          address: Address?, relation(name=user_address)
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('address').withYaml(
        '''
        class: Address
        table: address
        fields:
          userId: int, relation(parent=user, name=user_address)
        indexes:
          user_id_index_idx:
            fields: userId
            unique: true
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    var errors = collector.errors;

    test('then no error is collected.', () {
      expect(errors, isEmpty);
    });
  });

  group(
      'Given a class with a named object relation to a foreign id relation field that does not have unique index',
      () {
    var models = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          name: String
          address: Address?, relation(name=user_address)
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('address').withYaml(
        '''
        class: Address
        table: address
        fields:
          userId: int, relation(parent=user, name=user_address)
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    var errors = collector.errors;

    test('then an error is collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error messages says that there must be a unique index on the foreign field.',
        () {
      expect(
        errors.first.message,
        'The referenced field "userId" does not have a unique index which is required to be used in a one-to-one relation.',
      );
    }, skip: errors.isEmpty);
  });

  test(
      'Given I have an object relation'
      ' and the child is serverOnly'
      ' and the relation is optional '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        serverOnly: true
        fields:
          parent: Parent?, relation(optional)
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
    expect(errors, isEmpty);
  });

  test(
      'Given I have an object relation'
      ' and the child is serverOnly'
      ' and the relation is not optional '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        serverOnly: true
        fields:
          parent: Parent?, relation
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

    expect(errors, isEmpty);
  });

  test(
      'Given I have an object relation'
      ' and the child is not serverOnly'
      ' and the relation is optional '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        fields:
          parent: Parent?, relation(optional)
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

    expect(errors, isEmpty);
  });

  test(
      'Given I have an object relation'
      ' and the child is not serverOnly'
      ' and the relation is optional '
      ' and the field scope is serverOnly '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        fields:
          parent: Parent?, relation(optional), scope=serverOnly
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

    expect(errors, isEmpty);
  });

  test(
      'Given I have an object relation'
      ' and the child is not serverOnly'
      ' and the relation is not optional '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        fields:
          parent: Parent?, relation
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

    expect(errors, isEmpty);
  });

  test(
      'Given I have an object relation'
      ' and the child is not serverOnly'
      ' and the relation is not optional '
      ' and the field scope is serverOnly '
      'when analyzing '
      'then an error is collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        fields:
          parent: Parent?, relation, scope=serverOnly
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

    expect(errors.map((e) => e.message), [
      'The relation with scope "serverOnly" requires the relation to be optional.'
    ]);
  });

  test(
      'Given I have an id relation'
      ' and the child is serverOnly'
      ' and the relation is nullable '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        serverOnly: true
        fields:
          parentId: int?, relation(parent=parent)
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
    expect(errors, isEmpty);
  });

  test(
      'Given I have an id relation'
      ' and the child is serverOnly'
      ' and the relation is not nullable '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        serverOnly: true
        fields:
          parentId: int, relation(parent=parent)
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
    expect(errors, isEmpty);
  });

  test(
      'Given I have an id relation'
      ' and the child is not serverOnly'
      ' and the relation is nullable '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        fields:
          parentId: int?, relation(parent=parent)
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
    expect(errors, isEmpty);
  });

  test(
      'Given I have an id relation'
      ' and the child is not serverOnly'
      ' and the relation is nullable '
      ' and the field scope is serverOnly '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        fields:
          parentId: int?, relation(parent=parent), scope=serverOnly
        ''',
      ).build()
    ];
    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();
    var errors = collector.errors;
    expect(errors, isEmpty);
  });

  test(
      'Given I have an id relation'
      ' and the child is not serverOnly'
      ' and the relation not is nullable '
      'when analyzing '
      'then no errors are collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        fields:
          parentId: int, relation(parent=parent)
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
    expect(errors, isEmpty);
  });

  test(
      'Given I have an id relation'
      ' and the child is not serverOnly'
      ' and the relation is not nullable '
      ' and the field scope is serverOnly '
      'when analyzing '
      'then an error is collected', () {
    var models = [
      (ModelSourceBuilder().withFileName('parent').withYaml(
        '''
        class: Parent
        table: parent
        ''',
      ).build()),
      ModelSourceBuilder().withFileName('child').withYaml(
        '''
        class: Child
        table: child
        fields:
          parentId: int, relation(parent=parent), scope=serverOnly
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
    expect(errors.map((e) => e.message), [
      'The field "parentId" must be nullable when the "scope" property is set to "serverOnly".'
    ]);
  });
}

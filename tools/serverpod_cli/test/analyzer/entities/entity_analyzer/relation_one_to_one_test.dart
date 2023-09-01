import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group(
      'Given a class with a named object relation on both sides with a field references',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: User
table: user
fields:
  addressId: int
  address: Address?, relation(name=user_address, field=addressId)
''',
      Uri(path: 'lib/src/protocol/user.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Address
table: address
fields:
  user: User?, relation(name=user_address)
''',
      Uri(path: 'lib/src/protocol/address.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      entities,
    );

    var userDefinition = definition1 as ClassDefinition;
    var addressDefinition = definition2 as ClassDefinition;

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
    });

    group('then the company field has a relation', () {
      var relation = userDefinition.findField('address')?.relation;
      test('of ObjectRelation type', () {
        expect(
          relation.runtimeType,
          ObjectRelationDefinition,
        );
      });

      test('without a name for the relation', () {
        expect(relation?.name, isNull);
      }, skip: relation is! ObjectRelationDefinition);
    });
  });

  group(
      'Given a class with a named object relation on both sides without a field references',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: User
table: user
fields:
  address: Address?, relation(name=user_address)
''',
      Uri(path: 'lib/src/protocol/user.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Address
table: address
fields:
  user: User?, relation(name=user_address)
''',
      Uri(path: 'lib/src/protocol/address.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      entities,
    );

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
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Company
table: company
fields:
  addressId: int
  address: Address?, relation(name=company_address, field=addressId)
  oldAddressId: int
  oldAddress: Address?, relation(name=company_address, field=oldAddressId)
''',
      Uri(path: 'lib/src/protocol/address.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Address
table: address
fields:
  company: Company?, relation(name=company_address)
''',
      Uri(path: 'lib/src/protocol/company.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      entities,
    );

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
      'Given a class with a one to one relation where the relationship is ambiguous where the field names are the same in both models then an error is collected that the reference cannot be resolved.',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Company
table: company
fields:
  addressCompany: int
  address: Address?, relation(name=company_address, field=addressCompany)
  oldAddressId: int
  oldAddress: Address?, relation(name=company_address, field=oldAddressId)
''',
      Uri(path: 'lib/src/protocol/address.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Address
table: address
fields:
  addressCompany: Company?, relation(name=company_address)
''',
      Uri(path: 'lib/src/protocol/company.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      entities,
    );

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
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Company
table: company
fields:
  addressId: int
  address: Address?, relation(name=company_address, field=addressId)
''',
      Uri(path: 'lib/src/protocol/address.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Address
table: address
fields:
  addressCompanyId: int
  addressCompany: Company?, relation(name=company_address, field=addressCompanyId)
''',
      Uri(path: 'lib/src/protocol/company.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      entities,
    );

    expect(
      collector.errors.length,
      greaterThan(1),
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
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: User
table: user
fields:
  address: Address?, relation(name=user_address)
''',
      Uri(path: 'lib/src/protocol/user.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Address
table: address
fields:
  user: User?, relation
''',
      Uri(path: 'lib/src/protocol/address.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol2.yaml,
      protocol2.yamlSourceUri.path,
      collector,
      definition2,
      entities,
    );

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
}

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
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Address
table: address
fields:
  user: User?, relation(name=user_address)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
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

      test('with out a name for the relation', () {
        expect(relation?.name, isNull);
      }, skip: relation is! ObjectRelationDefinition);
    });
  });
}

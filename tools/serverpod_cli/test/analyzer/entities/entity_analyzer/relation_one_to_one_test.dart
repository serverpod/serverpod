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
class: Employee
table: employee
fields:
  companyId: int
  company: Company?, relation(name=company_ceo, field=companyId)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  ceo: Employee?, relation(name=company_ceo)
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

    var employeeDefinition = definition1 as ClassDefinition;
    var companyDefinition = definition2 as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    test(
        'then no id field was created for the side without the field pointer defined.',
        () {
      expect(
        companyDefinition.findField('ceoId'),
        isNull,
        reason: 'Expected ceoId to not exist as a field, but it did.',
      );
    }, skip: errors.isNotEmpty);

    /* TODO should not be an ObjectRelationDefinition but a new type??? or we add foreign + local field, where local would be ID on this side.
    test('then...', () {
      var relation = classDefinition.findField('ceo')?.relation;
      expect(
        relation.runtimeType,
        ObjectRelationDefinition,
        reason: 'Expected the relation to be an ObjectRelationDefinition.',
      );
    });*/

    test('then the defined companyId field exists.', () {
      expect(
        employeeDefinition.findField('companyId'),
        isNotNull,
      );
    }, skip: errors.isNotEmpty);

    group('then a relation is defined on the companyId', () {
      var relation = employeeDefinition.findField('companyId')?.relation;

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

      test('and the parent table is set to company', () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.parentTable,
          'company',
        );
      }, skip: relation is! ForeignRelationDefinition);

      test('and the relation name is set to the user defined relation name.',
          () {
        var foreignRelation = relation as ForeignRelationDefinition;

        expect(
          foreignRelation.name,
          'company_ceo',
        );
      }, skip: relation is! ForeignRelationDefinition);
    });

    group('then the company field has a relation', () {
      var relation = employeeDefinition.findField('company')?.relation;
      test('of ObjectRelation type', () {
        expect(
          relation.runtimeType,
          ObjectRelationDefinition,
        );
      });
    });
  });

  group(
      'Given a class with a named object relation on both sides without a field references',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  company: Company?, relation(name=company_ceo)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  ceo: Employee?, relation(name=company_ceo)
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

    var errors = collector.errors;

    test('then an error is collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error messages tells the user the relation is ambiguous and the field references should be used.',
        () {
      expect(
        errors.first.message,
        'The relation is ambiguous, unable to resolve which side should hold the relation. Use the field reference syntax to resolve the ambiguity. E.g. relation(name=company_ceo, field=companyId)',
      );
    }, skip: errors.isEmpty);

    test(
        'then the error messages tells the user the relation is ambiguous and the field references should be used.',
        () {
      expect(
        errors.first.message,
        'The relation is ambiguous, unable to resolve which side should hold the relation. Use the field reference syntax to resolve the ambiguity. E.g. relation(name=company_ceo, field=ceoId)',
      );
    }, skip: errors.isEmpty);
  });
}

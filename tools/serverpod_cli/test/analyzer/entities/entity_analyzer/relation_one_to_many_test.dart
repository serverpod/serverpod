import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with a one to many relation', () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  company: Company?, relation(name=company_employees)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  employees: List<Employee>?, relation(name=company_employees)
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

    var classDefinition = definition2 as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    test('then no id field was created for the many side.', () {
      expect(
        classDefinition.findField('employeesId'),
        isNull,
        reason: 'Expected employeesId to not exist as a field, but it did.',
      );
    }, skip: errors.isNotEmpty);

    test('then the reference field is set on the list relation.', () {
      var relation = classDefinition.findField('employees')?.relation;

      classDefinition;
      definition1;

      expect(relation.runtimeType, ListRelationDefinition);
      expect(
        (relation as ListRelationDefinition).foreignFieldName,
        'companyId',
        reason: 'Expected the reference field to be set to "companyId".',
      );
    }, skip: errors.isNotEmpty );
  });

  group(
      'Given two classes with one to many relations defined without specifying a name',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  company: Company?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  employees: List<Employee>?, relation
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

    group('then two independent relations are created', () {
      test('with no errors during validation.', () {
        expect(collector.errors, isEmpty);
      });

      test('with no id field was created for the many side.', () {
        expect(
          companyDefinition.findField('employeesId'),
          isNull,
          reason: 'Expected employeesId to not exist as a field, but it did.',
        );
      });

      test(
          'with the reference field is set on the list relation to an implicit relation field.',
          () {
        var relation = companyDefinition.findField('employees')?.relation;

        expect(relation.runtimeType, ListRelationDefinition);
        expect(
          (relation as ListRelationDefinition).foreignFieldName,
          '_company_employees_companyId',
          reason: 'Expected the reference field to be set.',
        );
      });

      test('with the relation field created on the employee side.', () {
        var field = employeeDefinition.findField(
          '_company_employees_companyId',
        );

        expect(field, isNotNull);
      });

      test(
          'with the reference field is set on the object relation to an implicit relation field.',
          () {
        var relation = employeeDefinition.findField('company')?.relation;

        expect(relation.runtimeType, ObjectRelationDefinition);
        expect(
          (relation as ObjectRelationDefinition).fieldName,
          'companyId',
          reason: 'Expected the reference field to be set.',
        );
      });

      test('with the companyId relation field created on the employee side.',
          () {
        expect(employeeDefinition.findField('companyId'), isNotNull);
      });
    });
  });

  test(
      'Given a class with a one to many relation where the relation ship is ambiguous then an error is collected that the reference cannot be resolved.',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  company: Company?, relation(name=company_employees)
  myCompany: Company?, relation(name=company_employees)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  employees: List<Employee>?, relation(name=company_employees)
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

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error but none was found.',
    );

    var error = collector.errors.first;

    expect(
      error.message,
      'Unable to resolve ambiguous relation, there are several named relations with name "company_employees" on the class "Employee".',
    );
  });

  group(
      'Given a class with a one to many relation where the relationship is only named on one side',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  company: Company?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  employees: List<Employee>?, relation(name=company_employees)
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
    test('then an error is collected', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error messages says that there must be a named relation on the other side.',
        () {
      expect(
        errors.first.message,
        'There is no named relation with name "company_employees" on the class "Employee".',
      );
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a one to many relation where the named relationship has a mismatch table reference',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  parentId: int, relation(name=company_employees, parent=employee)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var entities = [definition1!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );

    var errors = collector.errors;
    test('then an error is collected', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error messages says that there is no matching relation because of invalid table reference.',
        () {
      expect(
        errors.first.message,
        'The "parent" property is mutually exclusive with the "name" property.',
      );

      expect(
        errors.last.message,
        'The "name" property is mutually exclusive with the "parent" property.',
      );
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a one to many relation where the relationship where is named with a none string value',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  company: 
    type: Company?
    relation:
      name: 1
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  employees: 
    type: List<Employee>?
    relation:
      name: 1
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
    test('then an error is collected', () {
      expect(errors, isNotEmpty);
    });

    test('then the error messages says the value must be a string.', () {
      expect(
        errors.first.message,
        'The property must be a String.',
      );
    }, skip: errors.isEmpty);
  });

  group('Given an implicit one to many relation', () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Employee
table: employee
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: Company
table: company
fields:
  employees: List<Employee>?, relation
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

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then the reference field is set on the list relation.', () {
      var relation = companyDefinition.findField('employees')?.relation;

      expect(relation.runtimeType, ListRelationDefinition);
      expect(
        (relation as ListRelationDefinition).foreignFieldName,
        '_company_employees_companyId',
        reason: 'Expected the reference field to be set.',
      );
    });

    test('then the relation field is created on the employee side.', () {
      var field = employeeDefinition.findField('_company_employees_companyId');

      expect(field, isNotNull);
    });
  });
}

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
      'Given two classes with different id types and a one to one relation defined in an object relation field on the class that holds the foreign key',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          id: int?, defaultPersist=serial
          myParentId: UuidValue
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
          id: UuidValue?, defaultModel=random
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    late final definitions = analyzer.validateAll();

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    late final exampleClass = definitions.first as ModelClassDefinition;

    test('then the field type is same as the relation id type.', () {
      var field = exampleClass.findField('myParentId');

      expect(field?.type.className, 'UuidValue');
    });

    test('then the parent table id type of the object relation is int.', () {
      var parent = exampleClass.findField('parent');
      var relation = parent?.relation as ObjectRelationDefinition;

      expect(relation.parentTableIdType.className, 'int');
    });
  });

  group(
      'Given two classes with different id types and a named one to one relation defined in object relation fields on both classes',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          id: int?, defaultPersist=serial
          parentId: UuidValue?
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
          id: UuidValue?, defaultModel=random
          name: String
          example: Example?, relation(name=example_parent)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    late final definitions = analyzer.validateAll();

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    late final exampleClass = definitions.first as ModelClassDefinition;
    late final exampleParentClass = definitions.last as ModelClassDefinition;

    test('then parentId is nullable', () {
      var field = exampleClass.findField('parentId');

      expect(field?.type.nullable, isTrue);
    });

    test('then the parent table id type of the object relation is int.', () {
      var field = exampleClass.findField('parent');
      var relation = field!.relation as ObjectRelationDefinition;

      expect(relation.parentTableIdType.className, 'int');
    });

    test(
        'then the parent table id type of the foreign side object relation is int',
        () {
      var field = exampleParentClass.findField('example');
      var relation = field!.relation as ObjectRelationDefinition;

      expect(relation.parentTableIdType.className, 'int');
    });
  });

  group('Given two classes with different id types and a one to many relation',
      () {
    var models = [
      ModelSourceBuilder().withFileName('employee').withYaml(
        '''
        class: Employee
        table: employee
        fields:
          id: int?, defaultPersist=serial
          company: Company?, relation(name=company_employees)
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('company').withYaml(
        '''
        class: Company
        table: company
        fields:
          id: UuidValue?, defaultModel=random
          employees: List<Employee>?, relation(name=company_employees)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    late final definitions = analyzer.validateAll();

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    late final employeeClass = definitions.first as ModelClassDefinition;
    late final companyClass = definitions.last as ModelClassDefinition;

    test(
        'then the list relation has the foreign key owner id type on the company side of int.',
        () {
      var field = companyClass.findField('employees');
      var relation = field?.relation as ListRelationDefinition;

      expect(relation.foreignKeyOwnerIdType.className, 'int');
    });

    test(
        'then the object relation has parent table id type on the employee side of int.',
        () {
      var field = employeeClass.findField('company');
      var relation = field?.relation as ObjectRelationDefinition;

      expect(relation.parentTableIdType.className, 'int');
    });

    test('then the object relation has the foreign id field of type UuidValue.',
        () {
      var field = employeeClass.findField('companyId');

      expect(field?.type.className, 'UuidValue');
    });
  });

  group(
      'Given two classes with different id types and one to many independent relations defined without specifying a name',
      () {
    var models = [
      ModelSourceBuilder().withFileName('employee').withYaml(
        '''
        class: Employee
        table: employee
        fields:
          id: int?, defaultPersist=serial
          company: Company?, relation
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('company').withYaml(
        '''
        class: Company
        table: company
        fields:
          id: UuidValue?, defaultModel=random
          employees: List<Employee>?, relation
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    late final definitions = analyzer.validateAll();

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    late final employeeClass = definitions.first as ModelClassDefinition;
    late final companyClass = definitions.last as ModelClassDefinition;

    test(
        'then the list relation has the foreign key owner id type on the company side of UuidValue.',
        () {
      var field = companyClass.findField('employees');
      var relation = field?.relation as ListRelationDefinition;

      expect(relation.foreignKeyOwnerIdType.className, 'UuidValue');
    });

    test('then the list relation has the foreign id field of type UuidValue.',
        () {
      var field = employeeClass.findField('_companyEmployeesCompanyId');

      expect(field?.type.className, 'UuidValue');
    });

    test(
        'then the object relation has parent table id type on the employee side of int.',
        () {
      var field = employeeClass.findField('company');
      var relation = field?.relation as ObjectRelationDefinition;

      expect(relation.parentTableIdType.className, 'int');
    });

    test('then the object relation has the foreign id field of type UuidValue.',
        () {
      var field = employeeClass.findField('companyId');

      expect(field?.type.className, 'UuidValue');
    });
  });

  group(
      'Given two classes with different id types and an implicit one to many relation',
      () {
    var models = [
      ModelSourceBuilder().withFileName('employee').withYaml(
        '''
        class: Employee
        table: employee
        fields:
          id: int?, defaultPersist=serial
          name: String
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('company').withYaml(
        '''
        class: Company
        table: company
        fields:
          id: UuidValue?, defaultModel=random
          employees: List<Employee>?, relation
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    late final definitions = analyzer.validateAll();

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    late final employeeClass = definitions.first as ModelClassDefinition;
    late final companyClass = definitions.last as ModelClassDefinition;

    test(
        'then the list relation has the foreign key owner id type on the company side of UuidValue.',
        () {
      var field = companyClass.findField('employees');
      var relation = field?.relation as ListRelationDefinition;

      expect(relation.foreignKeyOwnerIdType.className, 'UuidValue');
    });

    test('then the list relation has the foreign id field of type UuidValue.',
        () {
      var field = employeeClass.findField('_companyEmployeesCompanyId');

      expect(field?.type.className, 'UuidValue');
    });
  });

  group(
      'Given two classes with different id types and a one to many relation on a foreign key field',
      () {
    var models = [
      ModelSourceBuilder().withFileName('employee').withYaml(
        '''
        class: Employee
        table: employee
        fields:
          id: int?, defaultPersist=serial
          companyId: UuidValue, relation(name=company_employees, parent=company)
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('company').withYaml(
        '''
        class: Company
        table: company
        fields:
          id: UuidValue?, defaultModel=random
          employees: List<Employee>?, relation(name=company_employees)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    late final definitions = analyzer.validateAll();

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    late final companyClass = definitions.last as ModelClassDefinition;

    test(
        'then the list relation has the foreign key owner id type on the company side of int.',
        () {
      var field = companyClass.findField('employees');
      var relation = field?.relation as ListRelationDefinition;

      expect(relation.foreignKeyOwnerIdType.className, 'int');
    });
  });
}

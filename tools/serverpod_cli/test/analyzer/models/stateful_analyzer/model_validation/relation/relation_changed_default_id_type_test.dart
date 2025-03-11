import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  for (var idType in SupportedIdType.all) {
    var idTypeAlias = idType.aliases.first;
    var idClassName = idType.className;
    var config = GeneratorConfigBuilder().withDefaultIdType(idType).build();

    group('For manual relations with default id type of $idTypeAlias', () {
      group(
          'Given a class with a relation with a defined field name that holds the relation',
          () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              myParentId: $idClassName
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
        var analyzer =
            StatefulAnalyzer(config, models, onErrorsCollector(collector));
        var definitions = analyzer.validateAll();

        test('then no errors were collected', () {
          expect(collector.errors, isEmpty);
        });

        var exampleClass = definitions.first as ModelClassDefinition;
        var exampleParentClass = definitions.last as ModelClassDefinition;

        test('then the table Example has id type $idTypeAlias.', () {
          expect(exampleClass.idField.type.className, idClassName);
        });

        test('then the table ExampleParent has id type $idTypeAlias.', () {
          expect(exampleParentClass.idField.type.className, idClassName);
        });

        test('then the field type is same as the relation id type.', () {
          var field = exampleClass.findField('myParentId');

          expect(field?.type.className, idClassName);
        });

        test(
            'then the parent table id type of the object relation is $idClassName.',
            () {
          var field = exampleClass.findField('parent');
          var relation = field?.relation as ObjectRelationDefinition;

          expect(relation.parentTableIdType.className, idClassName);
        });
      });

      group(
          'Given two classes with a named relation with a defined field name that holds the relation',
          () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              parentId: $idClassName?
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
        var analyzer =
            StatefulAnalyzer(config, models, onErrorsCollector(collector));
        var definitions = analyzer.validateAll();

        test('then no errors were collected', () {
          expect(collector.errors, isEmpty);
        });

        var exampleClass = definitions.first as ModelClassDefinition;
        var exampleParentClass = definitions.last as ModelClassDefinition;

        test('then parentId is nullable', () {
          var field = exampleClass.findField('parentId');

          expect(field?.type.nullable, isTrue);
        });

        test(
            'then the parent table id type of the object relation is $idClassName.',
            () {
          var field = exampleClass.findField('parent');
          var relation = field!.relation as ObjectRelationDefinition;

          expect(relation.parentTableIdType.className, idClassName);
        });

        test(
            'then the parent table id type of the foreign side object relation is $idClassName',
            () {
          var field = exampleParentClass.findField('example');
          var relation = field!.relation as ObjectRelationDefinition;

          expect(relation.parentTableIdType.className, idClassName);
        });
      });
    });

    group('For one to one relations with default id type of $idTypeAlias', () {
      group(
          'Given a class with only a foreign key field defined for the relation',
          () {
        var models = [
          ModelSourceBuilder().withFileName('user').withYaml(
            '''
            class: User
            table: user
            fields:
              addressId: $idClassName, relation(parent=address)
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

        test('then no errors are collected.', () {
          expect(collector.errors, isEmpty);
        });

        var userClass = definitions.first as ModelClassDefinition;
        var addressClass = definitions.last as ModelClassDefinition;

        test('then the table User has id type $idTypeAlias.', () {
          expect(userClass.idField.type.className, idClassName);
        });

        test('then the table Address has id type $idTypeAlias.', () {
          expect(addressClass.idField.type.className, idClassName);
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
              addressId: $idClassName
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

        test('then no errors are collected.', () {
          expect(collector.errors, isEmpty);
        });

        var userClass = definitions.first as ModelClassDefinition;

        test(
            'then the parent table id type of the object relation is $idClassName.',
            () {
          var field = userClass.findField('address');
          var relation = field?.relation as ObjectRelationDefinition;

          expect(relation.parentTableIdType.className, idClassName);
        });
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
            addressId: $idClassName, relation(name=user_address, parent=address)
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

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      var addressClass = definitions.last as ModelClassDefinition;

      test(
          'then the parent table id type of the object relation on the address side is $idClassName.',
          () {
        var field = addressClass.findField('user');
        var relation = field?.relation as ObjectRelationDefinition;

        expect(relation.parentTableIdType.className, idClassName);
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
            addressId: $idClassName
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

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      var userClass = definitions.first as ModelClassDefinition;
      var addressClass = definitions.last as ModelClassDefinition;

      test(
          'then the parent table id type of the object relation on the address side is $idClassName.',
          () {
        var field = addressClass.findField('user');
        var relation = field?.relation as ObjectRelationDefinition;

        expect(relation.parentTableIdType.className, idClassName);
      });

      test(
          'then the parent table id type of the object relation on the user side is $idClassName.',
          () {
        var field = userClass.findField('address');
        var relation = field?.relation as ObjectRelationDefinition;

        expect(relation.fieldName, 'addressId');
        expect(relation.parentTableIdType.className, idClassName);
      });
    });

    group('For one to many relations with default id type of $idTypeAlias', () {
      group('Given a class with a one to many relation', () {
        var models = [
          ModelSourceBuilder().withFileName('employee').withYaml(
            '''
            class: Employee
            table: employee
            fields:
              company: Company?, relation(name=company_employees)
            ''',
          ).build(),
          ModelSourceBuilder().withFileName('company').withYaml(
            '''
            class: Company
            table: company
            fields:
              employees: List<Employee>?, relation(name=company_employees)
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer =
            StatefulAnalyzer(config, models, onErrorsCollector(collector));
        var definitions = analyzer.validateAll();

        test('then no errors are collected.', () {
          expect(collector.errors, isEmpty);
        });

        var employeeClass = definitions.first as ModelClassDefinition;
        var companyClass = definitions.last as ModelClassDefinition;

        test('then the table Employee has id type $idTypeAlias.', () {
          expect(employeeClass.idField.type.className, idClassName);
        });

        test('then the table Company has id type $idTypeAlias.', () {
          expect(companyClass.idField.type.className, idClassName);
        });

        group('then the list relation', () {
          test(
              'have the foreign key owner id type on the company side of $idClassName.',
              () {
            var field = companyClass.findField('employees');
            var relation = field?.relation as ListRelationDefinition;

            expect(relation.foreignKeyOwnerIdType.className, idClassName);
          });
        });

        group('then the object relation', () {
          test(
              'have parent table id type on the employee side of $idClassName.',
              () {
            var field = employeeClass.findField('company');
            var relation = field?.relation as ObjectRelationDefinition;

            expect(relation.parentTableIdType.className, idClassName);
          });

          test('have the foreign id field of type $idClassName.', () {
            var field = employeeClass.findField('companyId');

            expect(field?.type.className, idClassName);
          });
        });
      });

      group(
          'Given two classes with one to many independent relations defined without specifying a name',
          () {
        var models = [
          ModelSourceBuilder().withFileName('employee').withYaml(
            '''
            class: Employee
            table: employee
            fields:
              company: Company?, relation
            ''',
          ).build(),
          ModelSourceBuilder().withFileName('company').withYaml(
            '''
            class: Company
            table: company
            fields:
              employees: List<Employee>?, relation
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer =
            StatefulAnalyzer(config, models, onErrorsCollector(collector));
        var definitions = analyzer.validateAll();

        test('with no errors during validation.', () {
          expect(collector.errors, isEmpty);
        });

        var employeeClass = definitions.first as ModelClassDefinition;
        var companyClass = definitions.last as ModelClassDefinition;

        group('then the list relation', () {
          test(
              'have the foreign key owner id type on the company side of $idClassName.',
              () {
            var field = companyClass.findField('employees');
            var relation = field?.relation as ListRelationDefinition;

            expect(relation.foreignKeyOwnerIdType.className, idClassName);
          });

          test('have the foreign id field of type $idClassName.', () {
            var field = employeeClass.findField('_companyEmployeesCompanyId');

            expect(field?.type.className, idClassName);
          });
        });

        group('then the object relation', () {
          test(
              'have parent table id type on the employee side of $idClassName.',
              () {
            var field = employeeClass.findField('company');
            var relation = field?.relation as ObjectRelationDefinition;

            expect(relation.parentTableIdType.className, idClassName);
          });

          test('have the foreign id field of type $idClassName.', () {
            var field = employeeClass.findField('companyId');

            expect(field?.type.className, idClassName);
          });
        });
      });

      group('Given an implicit one to many relation', () {
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
              employees: List<Employee>?, relation
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer =
            StatefulAnalyzer(config, models, onErrorsCollector(collector));
        var definitions = analyzer.validateAll();

        test('then no errors are collected.', () {
          expect(collector.errors, isEmpty);
        });

        var employeeClass = definitions.first as ModelClassDefinition;
        var companyClass = definitions.last as ModelClassDefinition;

        group('then the list relation', () {
          test(
              'have the foreign key owner id type on the company side of $idClassName.',
              () {
            var field = companyClass.findField('employees');
            var relation = field?.relation as ListRelationDefinition;

            expect(relation.foreignKeyOwnerIdType.className, idClassName);
          });

          test('have the foreign id field of type $idClassName.', () {
            var field = employeeClass.findField('_companyEmployeesCompanyId');

            expect(field?.type.className, idClassName);
          });
        });
      });

      group('Given a class with a one to many relation on a foreign key field',
          () {
        var models = [
          ModelSourceBuilder().withFileName('employee').withYaml(
            '''
            class: Employee
            table: employee
            fields:
              companyId: $idClassName, relation(name=company_employees, parent=company)
            ''',
          ).build(),
          ModelSourceBuilder().withFileName('company').withYaml(
            '''
            class: Company
            table: company
            fields:
              employees: List<Employee>?, relation(name=company_employees)
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer =
            StatefulAnalyzer(config, models, onErrorsCollector(collector));
        var definitions = analyzer.validateAll();

        test('with no errors during validation.', () {
          expect(collector.errors, isEmpty);
        });

        var companyClass = definitions.last as ModelClassDefinition;

        group('then the list relation', () {
          test(
              'have the foreign key owner id type on the company side of $idClassName.',
              () {
            var field = companyClass.findField('employees');
            var relation = field?.relation as ListRelationDefinition;

            expect(relation.foreignKeyOwnerIdType.className, idClassName);
          });
        });
      });
    });
  }
}

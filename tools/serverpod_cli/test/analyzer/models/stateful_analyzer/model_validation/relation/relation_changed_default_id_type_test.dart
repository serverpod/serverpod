import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  for (var idType in SupportedIdType.all) {
    var idClassName = idType.className;
    var config = GeneratorConfigBuilder().withDefaultIdType(idType).build();

    group('For manual relations with default id type of  $idClassName', () {
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

        var exampleClass = definitions.first as ClassDefinition;
        var parent = exampleClass.findField('parent');
        var relation = parent?.relation as ObjectRelationDefinition;

        test('then the table has id type $idClassName.', () {
          expect(exampleClass.idField.type.className, idClassName);
        });

        test('then the field type is same as the relation id type.', () {
          var field = exampleClass.findField('myParentId');
          expect(field?.type.className, idClassName);
        });

        test('then the object relation id type is $idClassName.', () {
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

        var exampleClass = definitions.first as ClassDefinition;
        var exampleParentClass = definitions.last as ClassDefinition;

        test('then the tables have id type $idClassName.', () {
          expect(exampleClass.idField.type.className, idClassName);
          expect(exampleParentClass.idField.type.className, idClassName);
        });

        test('then parentId is nullable', () {
          var field = exampleClass.findField('parentId');
          expect(field?.type.nullable, isTrue);
        });

        var field = exampleClass.findField('parent');
        var relation = field!.relation as ObjectRelationDefinition;

        test('then relation id type is $idClassName.', () {
          expect(relation.parentTableIdType.className, idClassName);
        });

        test('then the foreign side object relation has id type $idClassName',
            () {
          var field = exampleParentClass.findField('example');
          var foreignRelation = field!.relation as ObjectRelationDefinition;

          expect(foreignRelation.parentTableIdType.className, idClassName);
        });
      });
    });

    group('For one to one relations with default id type of $idClassName', () {
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

        var userDefinition = definitions.first as ClassDefinition;
        var addressDefinition = definitions.last as ClassDefinition;

        test('then the tables have id type $idClassName.', () {
          expect(userDefinition.idField.type.className, idClassName);
          expect(addressDefinition.idField.type.className, idClassName);
        });

        var field = userDefinition.findField('addressId');
        test('then the foreign id field have type $idClassName.', () {
          expect(field?.type.className, idClassName);
        });

        test(
            'then the foreign relation id type on the addressId is $idClassName.',
            () {
          var foreignRelation = field?.relation as ForeignRelationDefinition;

          expect(foreignRelation.idType.className, idClassName);
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

        var userDefinition = definitions.first as ClassDefinition;
        var addressDefinition = definitions.last as ClassDefinition;

        test('then the tables have id type $idClassName.', () {
          expect(userDefinition.idField.type.className, idClassName);
          expect(addressDefinition.idField.type.className, idClassName);
        });

        test(
            'then the object relation id type on the user side is $idClassName.',
            () {
          var field = userDefinition.findField('address');
          var objectRelation = field?.relation as ObjectRelationDefinition;

          expect(objectRelation.parentTableIdType.className, idClassName);
        });

        var field = userDefinition.findField('addressId');
        test('then the foreign id field have type $idClassName.', () {
          expect(field?.type.className, idClassName);
        });

        test(
            'then the foreign relation id type on the addressId is $idClassName.',
            () {
          var foreignRelation = field?.relation as ForeignRelationDefinition;

          expect(foreignRelation.idType.className, idClassName);
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

      var userDefinition = definitions.first as ClassDefinition;
      var addressDefinition = definitions.last as ClassDefinition;

      test('then the tables have id type $idClassName.', () {
        expect(userDefinition.idField.type.className, idClassName);
        expect(addressDefinition.idField.type.className, idClassName);
      });

      test(
          'then the object relation id type on the address side is $idClassName.',
          () {
        var field = addressDefinition.findField('user');
        var objectRelation = field?.relation as ObjectRelationDefinition;

        expect(objectRelation.parentTableIdType.className, idClassName);
      });

      var field = userDefinition.findField('addressId');
      test('then the foreign id field have type $idClassName.', () {
        expect(field?.type.className, idClassName);
      });

      test(
          'then the foreign relation id type on the addressId is $idClassName.',
          () {
        var foreignRelation = field?.relation as ForeignRelationDefinition;

        expect(foreignRelation.idType.className, idClassName);
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

      var userDefinition = definitions.first as ClassDefinition;
      var addressDefinition = definitions.last as ClassDefinition;

      test('then the tables have id type $idClassName.', () {
        expect(userDefinition.idField.type.className, idClassName);
        expect(addressDefinition.idField.type.className, idClassName);
      });

      test(
          'then the object relation id type on the address side is $idClassName.',
          () {
        var field = addressDefinition.findField('user');
        var objectRelation = field?.relation as ObjectRelationDefinition;

        expect(objectRelation.parentTableIdType.className, idClassName);
      });

      test('then the object relation id type on the user side is $idClassName.',
          () {
        var field = userDefinition.findField('address');
        var objectRelation = field?.relation as ObjectRelationDefinition;

        expect(objectRelation.fieldName, 'addressId');
        expect(objectRelation.parentTableIdType.className, idClassName);
      });

      var field = userDefinition.findField('addressId');
      test('then the foreign id field have type $idClassName.', () {
        expect(field?.type.className, idClassName);
      });

      test(
          'then the foreign relation id type on the addressId is $idClassName.',
          () {
        var foreignRelation = field?.relation as ForeignRelationDefinition;

        expect(foreignRelation.idType.className, idClassName);
      });
    });

    group('For one to many relations with default id type of $idClassName', () {
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

        var employeeDefinition = definitions.first as ClassDefinition;
        var companyDefinition = definitions.last as ClassDefinition;

        test('then the tables have id type $idClassName.', () {
          expect(companyDefinition.idField.type.className, idClassName);
          expect(employeeDefinition.idField.type.className, idClassName);
        });

        group('then the list relation', () {
          test('have id type on the company side of $idClassName.', () {
            var employeesField = companyDefinition.findField('employees');
            var field = employeesField?.relation as ListRelationDefinition;

            expect(field.idType.className, idClassName);
          });
        });

        group('then the object relation', () {
          test('have id type on the employee side of $idClassName.', () {
            var field = employeeDefinition.findField('company');
            var objectRelation = field?.relation as ObjectRelationDefinition;

            expect(objectRelation.parentTableIdType.className, idClassName);
          });

          var field = employeeDefinition.findField('companyId');
          test('have the foreign id field of type $idClassName.', () {
            expect(field?.type.className, idClassName);
          });

          test('have the foreign relation id type of $idClassName.', () {
            var foreignRelation = field?.relation as ForeignRelationDefinition;

            expect(foreignRelation.idType.className, idClassName);
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

        var employeeDefinition = definitions.first as ClassDefinition;
        var companyDefinition = definitions.last as ClassDefinition;

        test('then the tables have id type $idClassName.', () {
          expect(companyDefinition.idField.type.className, idClassName);
          expect(employeeDefinition.idField.type.className, idClassName);
        });

        group('then the list relation', () {
          test('have id type on the company side of $idClassName.', () {
            var employeesField = companyDefinition.findField('employees');
            var field = employeesField?.relation as ListRelationDefinition;

            expect(field.idType.className, idClassName);
          });

          var field =
              employeeDefinition.findField('_companyEmployeesCompanyId');
          test('have the foreign id field of type $idClassName.', () {
            expect(field?.type.className, idClassName);
          });

          test('have the foreign relation id type of $idClassName.', () {
            var foreignRelation = field?.relation as ForeignRelationDefinition;

            expect(foreignRelation.idType.className, idClassName);
          });
        });

        group('then the object relation', () {
          test('have id type on the employee side of $idClassName.', () {
            var field = employeeDefinition.findField('company');
            var objectRelation = field?.relation as ObjectRelationDefinition;

            expect(objectRelation.parentTableIdType.className, idClassName);
          });

          var field = employeeDefinition.findField('companyId');
          test('have the foreign id field of type $idClassName.', () {
            expect(field?.type.className, idClassName);
          });

          test('have the foreign relation id type of $idClassName.', () {
            var foreignRelation = field?.relation as ForeignRelationDefinition;

            expect(foreignRelation.idType.className, idClassName);
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

        var employeeDefinition = definitions.first as ClassDefinition;
        var companyDefinition = definitions.last as ClassDefinition;

        test('then the tables have id type $idClassName.', () {
          expect(companyDefinition.idField.type.className, idClassName);
          expect(employeeDefinition.idField.type.className, idClassName);
        });

        group('then the list relation', () {
          test('have id type on the company side of $idClassName.', () {
            var employeesField = companyDefinition.findField('employees');
            var field = employeesField?.relation as ListRelationDefinition;

            expect(field.idType.className, idClassName);
          });

          var field =
              employeeDefinition.findField('_companyEmployeesCompanyId');
          test('have the foreign id field of type $idClassName.', () {
            expect(field?.type.className, idClassName);
          });

          test('have the foreign relation id type of $idClassName.', () {
            var foreignRelation = field?.relation as ForeignRelationDefinition;

            expect(foreignRelation.idType.className, idClassName);
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

        var employeeDefinition = definitions.first as ClassDefinition;
        var companyDefinition = definitions.last as ClassDefinition;

        test('then the tables have id type $idClassName.', () {
          expect(companyDefinition.idField.type.className, idClassName);
          expect(employeeDefinition.idField.type.className, idClassName);
        });

        group('then the list relation', () {
          test('have id type on the company side of $idClassName.', () {
            var employeesField = companyDefinition.findField('employees');
            var field = employeesField?.relation as ListRelationDefinition;

            expect(field.idType.className, idClassName);
          });

          var field = employeeDefinition.findField('companyId');
          test('have the foreign id field of type $idClassName.', () {
            expect(field?.type.className, idClassName);
          });
        });
      });
    });
  }
}

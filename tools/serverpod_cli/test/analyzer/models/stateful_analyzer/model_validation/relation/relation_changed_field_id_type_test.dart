import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
    [ExperimentalFeature.changeIdType],
  ).build();

  for (var idType1 in SupportedIdType.all) {
    var idTypeAlias1 = idType1.aliases.first;
    var idClassName1 = idType1.className;

    for (var idType2 in SupportedIdType.all) {
      var idClassName2 = idType2.className;
      var idTypeAlias2 = idType2.aliases.first;

      group('For id type combination of $idTypeAlias1 and $idTypeAlias2', () {
        group('For manual relations', () {
          group(
              'Given a class with a relation with a defined field name that holds the relation',
              () {
            var models = [
              ModelSourceBuilder().withYaml(
                '''
                class: Example
                table: example
                fields:
                  id: $idClassName1, default=${idType1.defaultValue}
                  myParentId: $idClassName2
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
                  id: $idClassName2, default=${idType2.defaultValue}
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

            test('then the table Example has id type $idTypeAlias1.', () {
              expect(exampleClass.idField.type.className, idClassName1);
            });

            test('then the table ExampleParent has id type $idTypeAlias2.', () {
              expect(exampleParentClass.idField.type.className, idClassName2);
            });

            test('then the field type is same as the relation id type.', () {
              var field = exampleClass.findField('myParentId');

              expect(field?.type.className, idClassName2);
            });

            test(
                'then the parent table id type of the object relation is $idClassName1.',
                () {
              var parent = exampleClass.findField('parent');
              var relation = parent?.relation as ObjectRelationDefinition;

              expect(relation.parentTableIdType.className, idClassName1);
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
                  id: $idClassName1, default=${idType1.defaultValue}
                  parentId: $idClassName2?
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
                  id: $idClassName2, default=${idType2.defaultValue}
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
                'then the parent table id type of the object relation is $idClassName1.',
                () {
              var field = exampleClass.findField('parent');
              var relation = field!.relation as ObjectRelationDefinition;

              expect(relation.parentTableIdType.className, idClassName1);
            });

            test(
                'then the parent table id type of the foreign side object relation is $idClassName1',
                () {
              var field = exampleParentClass.findField('example');
              var relation = field!.relation as ObjectRelationDefinition;

              expect(relation.parentTableIdType.className, idClassName1);
            });
          });
        });

        group('For one to one relations', () {
          group(
              'Given a class with only a foreign key field defined for the relation',
              () {
            var models = [
              ModelSourceBuilder().withFileName('user').withYaml(
                '''
                class: User
                table: user
                fields:
                  id: $idClassName1, default=${idType1.defaultValue}
                  addressId: $idClassName2, relation(parent=address)
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
                  id: $idClassName2, default=${idType2.defaultValue}
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

            test('then the table User has id type $idTypeAlias1.', () {
              expect(userClass.idField.type.className, idClassName1);
            });

            test('then the table Address has id type $idTypeAlias2.', () {
              expect(addressClass.idField.type.className, idClassName2);
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
                  id: $idClassName1, default=${idType1.defaultValue}
                  addressId: $idClassName2
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
                  id: $idClassName2, default=${idType2.defaultValue}
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
                'then the parent table id type of the object relation is $idClassName1.',
                () {
              var field = userClass.findField('address');
              var relation = field?.relation as ObjectRelationDefinition;

              expect(relation.parentTableIdType.className, idClassName1);
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
                  id: $idClassName1, default=${idType1.defaultValue}
                  addressId: $idClassName2, relation(name=user_address, parent=address)
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
                  id: $idClassName2, default=${idType2.defaultValue}
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
                'then the parent table id type of the object relation on the address side is $idClassName1.',
                () {
              var field = addressClass.findField('user');
              var relation = field?.relation as ObjectRelationDefinition;

              expect(relation.parentTableIdType.className, idClassName1);
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
                  id: $idClassName1, default=${idType1.defaultValue}
                  addressId: $idClassName2
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
                  id: $idClassName2, default=${idType2.defaultValue}
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
                'then the parent table id type of the object relation on the address side is $idClassName1.',
                () {
              var field = addressClass.findField('user');
              var relation = field?.relation as ObjectRelationDefinition;

              expect(relation.parentTableIdType.className, idClassName1);
            });

            test(
                'then the parent table id type of the object relation on the user side is $idClassName1.',
                () {
              var field = userClass.findField('address');
              var relation = field?.relation as ObjectRelationDefinition;

              expect(relation.fieldName, 'addressId');
              expect(relation.parentTableIdType.className, idClassName1);
            });
          });
        });

        group('For one to many relations', () {
          group('Given a class with a one to many relation', () {
            var models = [
              ModelSourceBuilder().withFileName('employee').withYaml(
                '''
                class: Employee
                table: employee
                fields:
                  id: $idClassName1, default=${idType1.defaultValue}
                  company: Company?, relation(name=company_employees)
                ''',
              ).build(),
              ModelSourceBuilder().withFileName('company').withYaml(
                '''
                class: Company
                table: company
                fields:
                  id: $idClassName2, default=${idType2.defaultValue}
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

            test('then the table Employee has id type $idTypeAlias1.', () {
              expect(employeeClass.idField.type.className, idClassName1);
            });

            test('then the table Company has id type $idTypeAlias2.', () {
              expect(companyClass.idField.type.className, idClassName2);
            });

            group('then the list relation', () {
              test(
                  'have the foreign key owner id type on the company side of $idClassName1.',
                  () {
                var field = companyClass.findField('employees');
                var relation = field?.relation as ListRelationDefinition;

                expect(relation.foreignKeyOwnerIdType.className, idClassName1);
              });
            });

            group('then the object relation', () {
              test(
                  'have parent table id type on the employee side of $idClassName1.',
                  () {
                var field = employeeClass.findField('company');
                var relation = field?.relation as ObjectRelationDefinition;

                expect(relation.parentTableIdType.className, idClassName1);
              });

              test('have the foreign id field of type $idClassName2.', () {
                var field = employeeClass.findField('companyId');

                expect(field?.type.className, idClassName2);
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
                  id: $idClassName1, default=${idType1.defaultValue}
                  company: Company?, relation
                ''',
              ).build(),
              ModelSourceBuilder().withFileName('company').withYaml(
                '''
                class: Company
                table: company
                fields:
                  id: $idClassName2, default=${idType2.defaultValue}
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
                  'have the foreign key owner id type on the company side of $idClassName2.',
                  () {
                var field = companyClass.findField('employees');
                var relation = field?.relation as ListRelationDefinition;

                expect(relation.foreignKeyOwnerIdType.className, idClassName2);
              });

              test('have the foreign id field of type $idClassName2.', () {
                var field =
                    employeeClass.findField('_companyEmployeesCompanyId');

                expect(field?.type.className, idClassName2);
              });
            });

            group('then the object relation', () {
              test(
                  'have parent table id type on the employee side of $idClassName1.',
                  () {
                var field = employeeClass.findField('company');
                var relation = field?.relation as ObjectRelationDefinition;

                expect(relation.parentTableIdType.className, idClassName1);
              });

              test('have the foreign id field of type $idClassName2.', () {
                var field = employeeClass.findField('companyId');

                expect(field?.type.className, idClassName2);
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
                  id: $idClassName1, default=${idType1.defaultValue}
                  name: String
                ''',
              ).build(),
              ModelSourceBuilder().withFileName('company').withYaml(
                '''
                class: Company
                table: company
                fields:
                  id: $idClassName2, default=${idType2.defaultValue}
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
                  'have the foreign key owner id type on the company side of $idClassName2.',
                  () {
                var field = companyClass.findField('employees');
                var relation = field?.relation as ListRelationDefinition;

                expect(relation.foreignKeyOwnerIdType.className, idClassName2);
              });

              test('have the foreign id field of type $idClassName2.', () {
                var field =
                    employeeClass.findField('_companyEmployeesCompanyId');

                expect(field?.type.className, idClassName2);
              });
            });
          });

          group(
              'Given a class with a one to many relation on a foreign key field',
              () {
            var models = [
              ModelSourceBuilder().withFileName('employee').withYaml(
                '''
                class: Employee
                table: employee
                fields:
                  id: $idClassName1, default=${idType1.defaultValue}
                  companyId: $idClassName2, relation(name=company_employees, parent=company)
                ''',
              ).build(),
              ModelSourceBuilder().withFileName('company').withYaml(
                '''
                class: Company
                table: company
                fields:
                  id: $idClassName2, default=${idType2.defaultValue}
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
                  'have the foreign key owner id type on the company side of $idClassName1.',
                  () {
                var field = companyClass.findField('employees');
                var relation = field?.relation as ListRelationDefinition;

                expect(relation.foreignKeyOwnerIdType.className, idClassName1);
              });
            });
          });
        });
      });
    }
  }
}

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );
  var tableName = 'example_table';

  group('Given a class with table name when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );
    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    test('then a class named ${testClassName}Include is generated.', () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}Include',
        ),
        isTrue,
        reason: 'Missing class named ${testClassName}Include.',
      );
    });

    test('then a class named ${testClassName}IncludeList is generated', () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}IncludeList',
        ),
        isTrue,
        reason: 'Missing class named ${testClassName}IncludeList.',
      );
    });
  });

  group(
    'Given a class with table name and object relation field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withObjectRelationField('company', 'Company', 'company')
            .build(),
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;
      var maybeClassNamedExampleInclude =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Include',
          );

      group(
        'then the class named ${testClassName}Include',
        () {
          var exampleIncludeClass = maybeClassNamedExampleInclude!;
          test('inherits from IncludeObject.', () {
            expect(
              CompilationUnitHelpers.hasExtendsClause(
                exampleIncludeClass,
                name: 'IncludeObject',
              ),
              isTrue,
              reason: 'Missing extends clause for IncludeObject.',
            );
          });

          test(
            'implements ${testClassName}JsonInclude and FullModelInclude.',
            () {
              expect(
                CompilationUnitHelpers.hasImplementsClause(
                  exampleIncludeClass,
                  name: '${testClassName}JsonInclude',
                ),
                isTrue,
              );
              expect(
                CompilationUnitHelpers.hasImplementsClause(
                  exampleIncludeClass,
                  name: 'FullModelInclude',
                ),
                isTrue,
              );
            },
          );

          test(
            'has named parameter for field in internal constructor without selectedColumns.',
            () {
              expect(
                CompilationUnitHelpers.hasConstructorDeclaration(
                  exampleIncludeClass,
                  name: '_',
                  parameters: [
                    'CompanyInclude? company',
                  ],
                ),
                isTrue,
                reason:
                    'Missing constructor with named parameter for field in ${testClassName}Include.',
              );
            },
          );

          test('has private field as nullable class variable.', () {
            expect(
              CompilationUnitHelpers.hasFieldDeclaration(
                exampleIncludeClass,
                name: '_company',
                type: 'CompanyInclude?',
              ),
              isTrue,
              reason:
                  'Missing declaration for company field in ${testClassName}Include.',
            );
          });

          test('has an includes method.', () {
            expect(
              CompilationUnitHelpers.hasMethodDeclaration(
                exampleIncludeClass,
                name: 'includes',
              ),
              isTrue,
              reason: 'Missing declaration for includes method.',
            );
          });

          test('has a table method.', () {
            expect(
              CompilationUnitHelpers.hasMethodDeclaration(
                exampleIncludeClass,
                name: 'table',
                isGetter: true,
                functionExpression: 'Example.t',
              ),
              isTrue,
              reason: 'Missing declaration for table method.',
            );
          });

          test('has table method generic to nullable int type.', () {
            var maybeTableGetter =
                CompilationUnitHelpers.tryFindMethodDeclaration(
                  exampleIncludeClass,
                  name: 'table',
                  isGetter: true,
                );

            var typeArguments = maybeTableGetter?.returnType as NamedType?;
            var genericType = typeArguments?.typeArguments?.arguments.first;

            expect(
              (genericType as NamedType?)?.toString(),
              'int?',
              reason: 'Wrong generic type for table method.',
            );
          });
        },
        skip: maybeClassNamedExampleInclude == null
            ? 'Could not run test because ${testClassName}Include class was not found.'
            : false,
      );

      var maybeClassNamedExampleJsonInclude =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '_${testClassName}JsonInclude',
          );

      group(
        'then the class named _${testClassName}JsonInclude',
        () {
          var exampleJsonIncludeClass = maybeClassNamedExampleJsonInclude!;
          test(
            'inherits from IncludeObject and implements ${testClassName}JsonInclude.',
            () {
              expect(
                CompilationUnitHelpers.hasExtendsClause(
                  exampleJsonIncludeClass,
                  name: 'IncludeObject',
                ),
                isTrue,
              );
              expect(
                CompilationUnitHelpers.hasImplementsClause(
                  exampleJsonIncludeClass,
                  name: '${testClassName}JsonInclude',
                ),
                isTrue,
              );
            },
          );

          test(
            'has named parameter for field and selectedColumns in internal constructor.',
            () {
              expect(
                CompilationUnitHelpers.hasConstructorDeclaration(
                  exampleJsonIncludeClass,
                  name: '_',
                  parameters: [
                    'CompanyJsonInclude? company',
                    'this.selectedColumns',
                  ],
                ),
                isTrue,
              );
            },
          );

          test('has selectedColumns field.', () {
            expect(
              CompilationUnitHelpers.hasFieldDeclaration(
                exampleJsonIncludeClass,
                name: 'selectedColumns',
              ),
              isTrue,
            );
          });
        },
        skip: maybeClassNamedExampleJsonInclude == null
            ? 'Could not run test because _${testClassName}JsonInclude class was not found.'
            : false,
      );

      var includeListClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: '${testClassName}IncludeList',
      );

      group(
        'then the class named ${testClassName}IncludeList',
        () {
          var exampleIncludeListClass = includeListClass!;

          test(
            'inherits from IncludeList and implements ${testClassName}JsonIncludeList, FullModelInclude.',
            () {
              expect(
                CompilationUnitHelpers.hasExtendsClause(
                  exampleIncludeListClass,
                  name: 'IncludeList',
                ),
                isTrue,
                reason: 'Missing extends clause for IncludeList.',
              );
              expect(
                CompilationUnitHelpers.hasImplementsClause(
                  exampleIncludeListClass,
                  name: '${testClassName}JsonIncludeList',
                ),
                isTrue,
              );
              expect(
                CompilationUnitHelpers.hasImplementsClause(
                  exampleIncludeListClass,
                  name: 'FullModelInclude',
                ),
                isTrue,
              );
            },
          );

          test(
            'has named parameter for field in internal constructor without selectedColumns.',
            () {
              var constructor =
                  CompilationUnitHelpers.tryFindConstructorDeclaration(
                    exampleIncludeListClass,
                    name: '_',
                  );
              expect(
                constructor,
                isNotNull,
                reason:
                    'Missing constructor with named parameter for field in ${testClassName}IncludeList.',
              );

              var params = constructor?.parameters.toSource();
              expect(params, contains('super.where'));
              expect(params, contains('super.limit'));
              expect(params, contains('super.offset'));
              expect(params, contains('super.orderBy'));
              expect(params, contains('super.orderByList'));
              expect(params, contains('super.include'));
              expect(params, isNot(contains('this.selectedColumns')));
            },
          );

          test('has an includes method.', () {
            expect(
              CompilationUnitHelpers.hasMethodDeclaration(
                exampleIncludeListClass,
                name: 'includes',
              ),
              isTrue,
              reason: 'Missing declaration for includes method.',
            );
          });

          test('has a table method.', () {
            expect(
              CompilationUnitHelpers.hasMethodDeclaration(
                exampleIncludeListClass,
                name: 'table',
                isGetter: true,
                functionExpression: 'Example.t',
              ),
              isTrue,
              reason: 'Missing declaration for table method.',
            );
          });

          test('has table method generic to nullable int type.', () {
            var maybeTableGetter =
                CompilationUnitHelpers.tryFindMethodDeclaration(
                  exampleIncludeListClass,
                  name: 'table',
                  isGetter: true,
                );

            var typeArguments = maybeTableGetter?.returnType as NamedType?;
            var genericType = typeArguments?.typeArguments?.arguments.first;

            expect(
              (genericType as NamedType?)?.toString(),
              'int?',
              reason: 'Wrong generic type for table method.',
            );
          });
        },
        skip: includeListClass == null
            ? 'Could not run test because ${testClassName}Include class was not found.'
            : false,
      );

      var jsonIncludeListClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: '_${testClassName}JsonIncludeList',
      );

      group(
        'then the class named _${testClassName}JsonIncludeList',
        () {
          var exampleJsonIncludeListClass = jsonIncludeListClass!;

          test(
            'inherits from IncludeList and implements ${testClassName}JsonIncludeList.',
            () {
              expect(
                CompilationUnitHelpers.hasExtendsClause(
                  exampleJsonIncludeListClass,
                  name: 'IncludeList',
                ),
                isTrue,
              );
              expect(
                CompilationUnitHelpers.hasImplementsClause(
                  exampleJsonIncludeListClass,
                  name: '${testClassName}JsonIncludeList',
                ),
                isTrue,
              );
            },
          );

          test('has selectedColumns parameter in constructor.', () {
            var constructor =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  exampleJsonIncludeListClass,
                  name: '_',
                );
            expect(constructor, isNotNull);
            var params = constructor?.parameters.toSource();
            expect(params, contains('this.selectedColumns'));
          });
        },
        skip: jsonIncludeListClass == null
            ? 'Could not run test because _${testClassName}JsonIncludeList class was not found.'
            : false,
      );
    },
  );

  group(
    'Given a class with table name and object relation field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withListRelationField(
              'users',
              'User',
              'exampleId',
            )
            .build(),
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;
      var maybeClassNamedExampleInclude =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Include',
          );

      group('then the class named ${testClassName}Include', () {
        var exampleIncludeClass = maybeClassNamedExampleInclude!;

        test('has named parameter for field in internal constructor.', () {
          expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              exampleIncludeClass,
              name: '_',
              parameters: [
                'UserIncludeList? users',
              ],
            ),
            isTrue,
            reason:
                'Missing constructor with named parameter for field in ${testClassName}Include.',
          );
        });

        test('has private field as nullable class variable.', () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              exampleIncludeClass,
              name: '_users',
              type: 'UserIncludeList?',
            ),
            isTrue,
            reason:
                'Missing declaration for company field in ${testClassName}Include.',
          );
        });
      });
    },
  );
}

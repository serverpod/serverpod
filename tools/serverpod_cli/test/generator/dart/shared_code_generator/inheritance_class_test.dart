import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const sharedPackageName = 'shared_pkg';
const projectName = 'example_project';
const serverPathParts = ['server_root'];
final config = GeneratorConfigBuilder()
    .withServerPackageDirectoryPathParts(serverPathParts)
    .withSharedModelsSourcePathsParts({
      sharedPackageName: ['packages', 'shared'],
    })
    .withModules([])
    .build();
const generator = DartSharedCodeGenerator();

void main() {
  late var parentClassName = 'Example';
  late var parentClassFileName = 'example';
  var parentExpectedFilePath = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$parentClassFileName.dart',
  ]);

  late var childClassName = 'ChildExample';
  late var childClassFileName = 'child_example';
  var childExpectedFilePath = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$childClassFileName.dart',
  ]);

  group(
    'Given a child-class named $childClassName with one primitive var extending a parent-class named $parentClassName with one primitive var when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(parentClassName)
            .withFileName(parentClassFileName)
            .withSimpleField('name', 'String')
            .withChildClasses(
              [
                ModelClassDefinitionBuilder()
                    .withClassName(childClassName)
                    .withFileName(childClassFileName)
                    .withSimpleField('age', 'int')
                    .withSharedPackageName(sharedPackageName)
                    .build(),
              ],
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
        ModelClassDefinitionBuilder()
            .withClassName(childClassName)
            .withFileName(childClassFileName)
            .withSimpleField('age', 'int', nullable: true)
            .withExtendsClass(
              ModelClassDefinitionBuilder()
                  .withClassName(parentClassName)
                  .withFileName(parentClassFileName)
                  .withSimpleField('name', 'String')
                  .withSharedPackageName(sharedPackageName)
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var parentCompilationUnit = parseString(
        content: codeMap[parentExpectedFilePath]!,
      ).unit;
      late var childCompilationUnit = parseString(
        content: codeMap[childExpectedFilePath]!,
      ).unit;

      group('Then the $parentClassName', () {
        late var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
          parentCompilationUnit,
          name: parentClassName,
        );

        group('has a public constructor', () {
          late var publicConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                parentClass!,
                name: null,
              );

          test('defined', () {
            expect(publicConstructor, isNotNull);
          });

          test('without the factory keyword', () {
            expect(publicConstructor?.factoryKeyword, isNull);
          });
        });
      });

      group('Then the $childClassName', () {
        late var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
          childCompilationUnit,
          name: childClassName,
        );

        group('has a private constructor', () {
          late var privateConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                childClass!,
                name: '_',
              );

          test('defined', () {
            expect(privateConstructor, isNotNull);
          });

          test('with both classes vars as params', () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({required super.name, this.age})',
            );
          });
        });

        group('has a factory constructor', () {
          late var factoryConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                childClass!,
                name: null,
              );

          test('defined', () {
            expect(factoryConstructor, isNotNull);
          });

          test('with the factory keyword', () {
            expect(
              factoryConstructor?.factoryKeyword,
              isNotNull,
              reason: 'No factory keyword found on $childClassName',
            );
          });

          test(
            'passed to private implementing class',
            () {
              expect(
                factoryConstructor?.redirectedConstructor?.toSource(),
                '_${childClassName}Impl',
              );
            },
            skip: factoryConstructor == null,
          );

          test('with the class vars as params', () {
            expect(
              factoryConstructor?.parameters.toSource(),
              '({required String name, int? age})',
            );
          });
        });

        group('has a copyWith method', () {
          late var copyWithMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                childClass!,
                name: 'copyWith',
              );

          test('declared', () {
            expect(
              copyWithMethod,
              isNotNull,
              reason: 'No copyWith method found on $childClassName',
            );
          });

          test(
            'with the return type of $childClassName.',
            () {
              expect(copyWithMethod?.returnType?.toSource(), childClassName);
            },
            skip: copyWithMethod == null,
          );

          test(
            'with the named params set where all variables are nullable.',
            () {
              expect(
                copyWithMethod?.parameters?.toSource(),
                '({String? name, int? age})',
              );
            },
            skip: copyWithMethod == null,
          );

          test('with no code body.', () {
            var sourceCode = copyWithMethod?.body.toSource();
            expect(sourceCode, ';');
          });
        });
      });

      late var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: '_${childClassName}Impl',
      );

      test('then a class named _${childClassName}Impl is generated.', () {
        expect(
          copyWithClass,
          isNotNull,
          reason: 'Missing definition for class named _${childClassName}Impl',
        );
      });

      group('then the class named _${childClassName}Impl', () {
        group('has a constructor', () {
          late var defaultConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                copyWithClass!,
                name: null,
              );

          test('without a name.', () {
            expect(
              defaultConstructor,
              isNotNull,
              reason: 'Missing declaration for base private constructor.',
            );
          });

          test(
            'with the params set to the same as the parent class.',
            () {
              expect(
                defaultConstructor?.parameters.toSource(),
                '({required String name, int? age})',
              );
            },
            skip: defaultConstructor == null,
          );

          test('with super call to named private constructor', () {
            expect(
              defaultConstructor?.initializers.first.toSource(),
              'super._(name: name, age: age)',
            );
          });
        });
      });
    },
  );

  group(
    'Given a child-class named $childClassName with one primitive var and a var with default value extending a parent-class named $parentClassName with one primitive var and a var with default value when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(parentClassName)
            .withFileName(parentClassFileName)
            .withSimpleField('name', 'String')
            .withSimpleField('parentDefault', 'int', defaultModelValue: '0')
            .withChildClasses(
              [
                ModelClassDefinitionBuilder()
                    .withClassName(childClassName)
                    .withFileName(childClassFileName)
                    .withSimpleField('age', 'int')
                    .withSimpleField(
                      'childDefault',
                      'int',
                      defaultModelValue: '-1',
                    )
                    .withSharedPackageName(sharedPackageName)
                    .build(),
              ],
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
        ModelClassDefinitionBuilder()
            .withClassName(childClassName)
            .withFileName(childClassFileName)
            .withSimpleField('age', 'int', nullable: true)
            .withSimpleField('childDefault', 'int', defaultModelValue: '-1')
            .withExtendsClass(
              ModelClassDefinitionBuilder()
                  .withClassName(parentClassName)
                  .withFileName(parentClassFileName)
                  .withSimpleField('name', 'String')
                  .withSimpleField(
                    'parentDefault',
                    'int',
                    defaultModelValue: '0',
                  )
                  .withSharedPackageName(sharedPackageName)
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var parentCompilationUnit = parseString(
        content: codeMap[parentExpectedFilePath]!,
      ).unit;
      late var childCompilationUnit = parseString(
        content: codeMap[childExpectedFilePath]!,
      ).unit;

      group('Then the $parentClassName', () {
        late var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
          parentCompilationUnit,
          name: parentClassName,
        );

        group('has a public constructor', () {
          late var publicConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                parentClass!,
                name: null,
              );

          group('with the initializers', () {
            test('containing 1 entry', () {
              expect(publicConstructor?.initializers.length, 1);
            });

            test('correctly set', () {
              expect(
                publicConstructor?.initializers.first.toSource(),
                'parentDefault = parentDefault ?? 0',
              );
            });
          });
        });
      });

      group('Then the $childClassName', () {
        late var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
          childCompilationUnit,
          name: childClassName,
        );

        group('has a private constructor', () {
          late var privateConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                childClass!,
                name: '_',
              );

          test('with both classes vars as params', () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({required super.name, super.parentDefault, this.age, int? childDefault})',
            );
          });

          group('with the initializers', () {
            test('containing 1 entry', () {
              expect(privateConstructor?.initializers.length, 1);
            });

            test('correctly set', () {
              expect(
                privateConstructor?.initializers.first.toSource(),
                'childDefault = childDefault ?? -1',
              );
            });
          });
        });

        group('has a factory constructor', () {
          late var factoryConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                childClass!,
                name: null,
              );

          test('with the class vars as params', () {
            expect(
              factoryConstructor?.parameters.toSource(),
              '({required String name, int? parentDefault, int? age, int? childDefault})',
            );
          });
        });

        group('has a copyWith method', () {
          late var copyWithMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                childClass!,
                name: 'copyWith',
              );

          test(
            'with the named params set where all variables are nullable.',
            () {
              expect(
                copyWithMethod?.parameters?.toSource(),
                '({String? name, int? parentDefault, int? age, int? childDefault})',
              );
            },
            skip: copyWithMethod == null,
          );
        });
      });
      late var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: '_${childClassName}Impl',
      );

      group('then the class named _${childClassName}Impl', () {
        group('has a constructor', () {
          late var defaultConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                copyWithClass!,
                name: null,
              );

          test(
            'with the params set to the same as the parent class.',
            () {
              expect(
                defaultConstructor?.parameters.toSource(),
                '({required String name, int? parentDefault, int? age, int? childDefault})',
              );
            },
            skip: defaultConstructor == null,
          );

          test('with super call to named private constructor', () {
            expect(
              defaultConstructor?.initializers.first.toSource(),
              'super._(name: name, parentDefault: parentDefault, age: age, childDefault: childDefault)',
            );
          });
        });
      });
    },
  );
}

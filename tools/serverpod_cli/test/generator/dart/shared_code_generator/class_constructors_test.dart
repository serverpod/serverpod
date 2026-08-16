import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
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
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  ]);

  group(
    'Given a class named $testClassName with two primitive vars when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withSimpleField('name', 'String')
            .withSimpleField('age', 'int', nullable: true)
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      group('then the $testClassName', () {
        late var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        group('has a private constructor', () {
          late var privateConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                baseClass!,
                name: '_',
              );

          test('defined', () {
            expect(privateConstructor, isNotNull);
          });

          test('with the class vars as params', () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({required this.name, this.age})',
            );
          });
        });

        group('has a factory constructor', () {
          late var factoryConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                baseClass!,
                name: null,
              );

          test('defined', () {
            expect(factoryConstructor, isNotNull);
          });

          test('with the factory keyword', () {
            expect(
              factoryConstructor?.factoryKeyword,
              isNotNull,
              reason: 'No factory keyword found on $testClassName',
            );
          });

          test(
            'passed to private implementing class',
            () {
              expect(
                factoryConstructor?.redirectedConstructor?.toSource(),
                '_${testClassName}Impl',
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
                baseClass!,
                name: 'copyWith',
              );
          test('declared', () {
            expect(
              copyWithMethod,
              isNotNull,
              reason: 'No copyWith method found on $testClassName',
            );
          });

          test('with the return type of $testClassName.', () {
            expect(copyWithMethod?.returnType?.toSource(), testClassName);
          });

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
        compilationUnit,
        name: '_${testClassName}Impl',
      );

      test('then a class named _${testClassName}Impl is generated.', () {
        expect(
          copyWithClass,
          isNotNull,
          reason: 'Missing definition for class named _${testClassName}Impl',
        );
      });

      group('then the class named _${testClassName}Impl', () {
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
            'with the params set to the same as the base class.',
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
    'Given a class named $testClassName with a var with none scope when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('noneName')
                  .withTypeDefinition('String')
                  .withScope(ModelFieldScopeDefinition.none)
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      group('then the $testClassName', () {
        late var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        group('has a private constructor', () {
          late var privateConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                baseClass!,
                name: '_',
              );

          test('defined', () {
            expect(privateConstructor, isNotNull);
          });

          test('with no params', () {
            expect(
              privateConstructor?.parameters.toSource(),
              '()',
            );
          });
        });

        group('has a factory constructor', () {
          late var factoryConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                baseClass!,
                name: null,
              );

          test('with no params', () {
            expect(
              factoryConstructor?.parameters.toSource(),
              '()',
            );
          });
        });
      });

      late var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: '_${testClassName}Impl',
      );
      test('then a class named _${testClassName}Impl is generated.', () {
        expect(
          copyWithClass,
          isNotNull,
          reason: 'Missing definition for class named _${testClassName}Impl',
        );
      });

      group('then the class named _${testClassName}Impl', () {
        group('has a constructor', () {
          late var defaultConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                copyWithClass!,
                name: null,
              );

          test(
            'with the params set to the same as the base class.',
            () {
              expect(
                defaultConstructor?.parameters.toSource(),
                '()',
              );
            },
            skip: defaultConstructor == null,
          );

          test('with super call to named private constructor', () {
            expect(
              defaultConstructor?.initializers.first.toSource(),
              'super._()',
            );
          });
        });
      });
    },
  );

  group(
    'Given a class named $testClassName with a var with serverOnly scope when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('serverOnlyName')
                  .withTypeDefinition('String')
                  .withScope(ModelFieldScopeDefinition.serverOnly)
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      group('then the $testClassName', () {
        late var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        group('has a private constructor', () {
          late var privateConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                baseClass!,
                name: '_',
              );

          test('defined', () {
            expect(privateConstructor, isNotNull);
          });

          test('with no params', () {
            expect(
              privateConstructor?.parameters.toSource(),
              '()',
            );
          });
        });

        group('has a factory constructor', () {
          late var factoryConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                baseClass!,
                name: null,
              );

          test('with no params', () {
            expect(
              factoryConstructor?.parameters.toSource(),
              '()',
            );
          });
        });
      });

      late var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: '_${testClassName}Impl',
      );
      test('then a class named _${testClassName}Impl is generated.', () {
        expect(
          copyWithClass,
          isNotNull,
          reason: 'Missing definition for class named _${testClassName}Impl',
        );
      });

      group('then the class named _${testClassName}Impl', () {
        group('has a constructor', () {
          late var defaultConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                copyWithClass!,
                name: null,
              );

          test('with no params.', () {
            expect(
              defaultConstructor?.parameters.toSource(),
              '()',
            );
          });

          test('with super call to named private constructor', () {
            expect(
              defaultConstructor?.initializers.first.toSource(),
              'super._()',
            );
          });
        });
      });
    },
  );

  group(
    'Given a class named $testClassName with a list var when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('names')
                  .withType(
                    TypeDefinitionBuilder().withListOf('String').build(),
                  )
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      var implClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: '_${testClassName}Impl',
      );

      late var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName,
      );

      test('then the base class has a constructor with the full List type', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          implClass!,
          name: null,
        );

        expect(
          constructor?.parameters.toSource(),
          '({required List<String> names})',
        );
      });

      test(
        'then the implemented class has a private constructor with the full List type',
        () {
          late var privateConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                implClass!,
                name: null,
              );

          expect(
            privateConstructor?.parameters.toSource(),
            '({required List<String> names})',
          );
        },
      );

      test(
        'then the copyWith method has the full List type in the params in the base class',
        () {
          late var copyWithMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                baseClass!,
                name: 'copyWith',
              );

          expect(
            copyWithMethod?.parameters?.toSource(),
            '({List<String>? names})',
          );
        },
      );
    },
  );
}

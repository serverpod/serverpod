import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var parentClassName = 'Example';
  var parentClassFileName = 'example';
  var parentExpectedFilePath =
      path.join('lib', 'src', 'generated', '$parentClassFileName.dart');

  var childClassName = 'ChildExample';
  var childClassFileName = 'child_example';
  var childExpectedFilePath =
      path.join('lib', 'src', 'generated', '$childClassFileName.dart');

  group(
      'Given a child-class named $childClassName with one primitive var extending a parent-class named $parentClassName with one primitive var when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSimpleField('name', 'String')
          .withChildClasses(
        [
          ClassDefinitionBuilder()
              .withClassName(childClassName)
              .withFileName(childClassFileName)
              .withSimpleField('age', 'int')
              .build(),
        ],
      ).build(),
      ClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withSimpleField('age', 'int', nullable: true)
          .withExtendsClass(
            ClassDefinitionBuilder()
                .withClassName(parentClassName)
                .withFileName(parentClassFileName)
                .withSimpleField('name', 'String')
                .build(),
          )
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var parentCompilationUnit =
        parseString(content: codeMap[parentExpectedFilePath]!).unit;
    var childCompilationUnit =
        parseString(content: codeMap[childExpectedFilePath]!).unit;

    group('Then the $parentClassName', () {
      var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
        parentCompilationUnit,
        name: parentClassName,
      );

      group('has a public constructor', () {
        var publicConstructor =
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
      var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: childClassName,
      );

      group('has a private constructor', () {
        var privateConstructor =
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
        }, skip: privateConstructor == null);
      });

      group('has a factory constructor', () {
        var factoryConstructor =
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
        }, skip: factoryConstructor == null);

        test('passed to private implementing class', () {
          expect(
            factoryConstructor?.redirectedConstructor?.toSource(),
            '_${childClassName}Impl',
          );
        }, skip: factoryConstructor == null);

        test('with the class vars as params', () {
          expect(
            factoryConstructor?.parameters.toSource(),
            '({required String name, int? age})',
          );
        }, skip: factoryConstructor == null);
      });

      group('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
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

        test('with the return type of $childClassName.', () {
          expect(copyWithMethod?.returnType?.toSource(), childClassName);
        }, skip: copyWithMethod == null);

        test('with the named params set where all variables are nullable.', () {
          expect(
            copyWithMethod?.parameters?.toSource(),
            '({String? name, int? age})',
          );
        }, skip: copyWithMethod == null);

        test('with no code body.', () {
          var sourceCode = copyWithMethod?.body.toSource();
          expect(sourceCode, ';');
        }, skip: copyWithMethod == null);
      }, skip: childClass == null);
    });
    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
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
        var defaultConstructor =
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

        test('with the params set to the same as the parent-class.', () {
          expect(
            defaultConstructor?.parameters.toSource(),
            '({required String name, int? age})',
          );
        }, skip: defaultConstructor == null);

        test('with super call to named private constructor', () {
          expect(
            defaultConstructor?.initializers.first.toSource(),
            'super._(name: name, age: age)',
          );
        });
      });
    });
  });

  test(
      'Given a class named $childClassName extending an existing class named $parentClassName, Then $childClassName should have a valid (absolute) import path to $parentClassName',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSimpleField('name', 'String')
          .withChildClasses(
        [
          ClassDefinitionBuilder()
              .withClassName(childClassName)
              .withFileName(childClassFileName)
              .withSimpleField('age', 'int')
              .build(),
        ],
      ).build(),
      ClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withSimpleField('age', 'int', nullable: true)
          .withExtendsClass(
            ClassDefinitionBuilder()
                .withClassName(parentClassName)
                .withFileName(parentClassFileName)
                .withSimpleField('name', 'String')
                .build(),
          )
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var childCompilationUnit =
        parseString(content: codeMap[childExpectedFilePath]!).unit;

    var expectedParentLink =
        'package:${projectName}_server/src/generated/$parentClassFileName.dart';

    var hasValidImportPath = CompilationUnitHelpers.hasImportDirective(
      childCompilationUnit,
      uri: expectedParentLink,
    );

    expect(hasValidImportPath, isTrue);
  });

  test(
      'Given a class named $childClassName extending an existing class named $parentClassName, When $childClassName is located in a sub directory, Then $childClassName should have a valid (absolute) import path to $parentClassName',
      () {
    var childExpectedFilePathWithSubDir = path.join(
        'lib', 'src', 'generated', 'inheritance', '$childClassFileName.dart');

    var models = [
      ClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSimpleField('name', 'String')
          .withChildClasses(
        [
          ClassDefinitionBuilder()
              .withClassName(childClassName)
              .withFileName(childClassFileName)
              .withSubDirParts(['inheritance'])
              .withSimpleField('age', 'int')
              .build(),
        ],
      ).build(),
      ClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withSubDirParts(['inheritance'])
          .withSimpleField('age', 'int', nullable: true)
          .withExtendsClass(
            ClassDefinitionBuilder()
                .withClassName(parentClassName)
                .withFileName(parentClassFileName)
                .withSimpleField('name', 'String')
                .build(),
          )
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var childCompilationUnit =
        parseString(content: codeMap[childExpectedFilePathWithSubDir]!).unit;

    var expectedParentLink =
        'package:${projectName}_server/src/generated/$parentClassFileName.dart';

    var hasValidImportPath = CompilationUnitHelpers.hasImportDirective(
      childCompilationUnit,
      uri: expectedParentLink,
    );

    expect(hasValidImportPath, isTrue);
  });

  test(
      'Given a class named $childClassName extending an existing class named $parentClassName, When $parentClassName is located in a sub directory, Then $childClassName should have a valid (absolute) import path to $parentClassName',
      () {
    var childExpectedFilePath =
        path.join('lib', 'src', 'generated', '$childClassFileName.dart');

    var models = [
      ClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSubDirParts(['inheritance'])
          .withSimpleField('name', 'String')
          .withChildClasses(
            [
              ClassDefinitionBuilder()
                  .withClassName(childClassName)
                  .withFileName(childClassFileName)
                  .withSimpleField('age', 'int')
                  .build(),
            ],
          )
          .build(),
      ClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withSimpleField('age', 'int', nullable: true)
          .withExtendsClass(
            ClassDefinitionBuilder()
                .withClassName(parentClassName)
                .withFileName(parentClassFileName)
                .withSubDirParts(['inheritance'])
                .withSimpleField('name', 'String')
                .build(),
          )
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var childCompilationUnit =
        parseString(content: codeMap[childExpectedFilePath]!).unit;

    var expectedParentLinkWithSubDir =
        'package:${projectName}_server/src/generated/inheritance/$parentClassFileName.dart';

    var hasValidImportPath = CompilationUnitHelpers.hasImportDirective(
      childCompilationUnit,
      uri: expectedParentLinkWithSubDir,
    );

    expect(hasValidImportPath, isTrue);
  });

  test(
      'Given a class named $childClassName extending an existing class named $parentClassName, When both are located in a sub directory, Then $childClassName should have a valid (absolute) import path to $parentClassName',
      () {
    var childExpectedFilePathWithSubDir = path.join(
        'lib', 'src', 'generated', 'inheritance', '$childClassFileName.dart');

    var models = [
      ClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSubDirParts(['inheritance'])
          .withSimpleField('name', 'String')
          .withChildClasses(
            [
              ClassDefinitionBuilder()
                  .withClassName(childClassName)
                  .withFileName(childClassFileName)
                  .withSubDirParts(['inheritance'])
                  .withSimpleField('age', 'int')
                  .build(),
            ],
          )
          .build(),
      ClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withSubDirParts(['inheritance'])
          .withSimpleField('age', 'int', nullable: true)
          .withExtendsClass(
            ClassDefinitionBuilder()
                .withClassName(parentClassName)
                .withFileName(parentClassFileName)
                .withSubDirParts(['inheritance'])
                .withSimpleField('name', 'String')
                .build(),
          )
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var childCompilationUnit =
        parseString(content: codeMap[childExpectedFilePathWithSubDir]!).unit;

    var expectedParentLinkWithSubDir =
        'package:${projectName}_server/src/generated/inheritance/$parentClassFileName.dart';

    var hasValidImportPath = CompilationUnitHelpers.hasImportDirective(
      childCompilationUnit,
      uri: expectedParentLinkWithSubDir,
    );

    expect(hasValidImportPath, isTrue);
  });
}

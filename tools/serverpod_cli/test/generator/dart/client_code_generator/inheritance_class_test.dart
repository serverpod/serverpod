import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  var baseClassName = 'Example';
  var baseClassFileName = 'example';
  var baseExpectedFilePath = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$baseClassFileName.dart',
  );

  var subClassName = 'SubExample';
  var subClassFileName = 'sub_example';
  var subExpectedFilePath = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$subClassFileName.dart',
  );

  group(
      'Given a sub-class named $subClassName with one primitive var extending a base-class named $baseClassName with one primitive var when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(baseClassName)
          .withFileName(baseClassFileName)
          .withSimpleField('name', 'String')
          .build(),
      ClassDefinitionBuilder()
          .withClassName(subClassName)
          .withFileName(subClassFileName)
          .withSimpleField('age', 'int', nullable: true)
          .withExtendsClass(baseClassName)
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var baseCompilationUnit =
        parseString(content: codeMap[baseExpectedFilePath]!).unit;
    var subCompilationUnit =
        parseString(content: codeMap[subExpectedFilePath]!).unit;

    group('Then the $baseClassName', () {
      var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
        baseCompilationUnit,
        name: baseClassName,
      );

      group('has a public constructor', () {
        var publicConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          baseClass!,
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

    group('Then the $subClassName', () {
      var subClass = CompilationUnitHelpers.tryFindClassDeclaration(
        subCompilationUnit,
        name: subClassName,
      );

      group('has a private constructor', () {
        var privateConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          subClass!,
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
          subClass!,
          name: null,
        );

        test('defined', () {
          expect(factoryConstructor, isNotNull);
        });

        test('with the factory keyword', () {
          expect(
            factoryConstructor?.factoryKeyword,
            isNotNull,
            reason: 'No factory keyword found on $subClassName',
          );
        }, skip: factoryConstructor == null);

        test('passed to private implementing class', () {
          expect(
            factoryConstructor?.redirectedConstructor?.toSource(),
            '_${subClassName}Impl',
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
          subClass!,
          name: 'copyWith',
        );

        test('declared', () {
          expect(
            copyWithMethod,
            isNotNull,
            reason: 'No copyWith method found on $subClassName',
          );
        });

        test('with the return type of $subClassName.', () {
          expect(copyWithMethod?.returnType?.toSource(), subClassName);
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
      }, skip: subClass == null);
    });
    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      subCompilationUnit,
      name: '_${subClassName}Impl',
    );
    test('then a class named _${subClassName}Impl is generated.', () {
      expect(
        copyWithClass,
        isNotNull,
        reason: 'Missing definition for class named _${subClassName}Impl',
      );
    });

    group('then the class named _${subClassName}Impl', () {
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

        test('with the params set to the same as the base class.', () {
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
}

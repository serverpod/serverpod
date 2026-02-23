import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
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
  group(
    'Given an exception class with fields when generating shared code',
    () {
      ClassDeclaration? baseClass;
      MethodDeclaration? toStringMethod;

      setUpAll(() {
        var testClassName = 'MyException';
        var testClassFileName = 'my_exception';
        var expectedFilePath = path.joinAll([
          ...serverPathParts,
          'packages',
          'shared',
          'lib',
          'src',
          'generated',
          '$testClassFileName.dart',
        ]);

        var fields = [
          FieldDefinitionBuilder()
              .withName('message')
              .withTypeDefinition('String', false)
              .build(),
          FieldDefinitionBuilder()
              .withName('errorCode')
              .withTypeDefinition('int', false)
              .build(),
        ];

        var models = [
          ExceptionClassDefinitionBuilder()
              .withClassName(testClassName)
              .withFileName(testClassFileName)
              .withFields(fields)
              .withSharedPackageName(sharedPackageName)
              .build(),
        ];

        var codeMap = generator.generateSerializableModelsCode(
          models: models,
          config: config,
        );

        var compilationUnit = parseString(
          content: codeMap[expectedFilePath]!,
        ).unit;

        baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        toStringMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          baseClass!,
          name: 'toString',
        );
      });

      test('then the toString method is defined', () {
        expect(toStringMethod, isNotNull);
      });

      test(
        'then the toString method returns a descriptive string with fields',
        () {
          expect(
            toStringMethod?.body.toString(),
            contains(
              "'MyException(message: \$message, errorCode: \$errorCode)'",
            ),
          );
        },
      );
    },
  );

  group(
    'Given an exception class without fields when generating shared code',
    () {
      ClassDeclaration? baseClass;
      MethodDeclaration? toStringMethod;

      setUpAll(() {
        var testClassName = 'EmptyException';
        var testClassFileName = 'empty_exception';
        var expectedFilePath = path.joinAll([
          ...serverPathParts,
          'packages',
          'shared',
          'lib',
          'src',
          'generated',
          '$testClassFileName.dart',
        ]);

        var models = [
          ExceptionClassDefinitionBuilder()
              .withClassName(testClassName)
              .withFileName(testClassFileName)
              .withFields([])
              .withSharedPackageName(sharedPackageName)
              .build(),
        ];

        var codeMap = generator.generateSerializableModelsCode(
          models: models,
          config: config,
        );

        var compilationUnit = parseString(
          content: codeMap[expectedFilePath]!,
        ).unit;

        baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        toStringMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          baseClass!,
          name: 'toString',
        );
      });

      test('then the toString method is defined', () {
        expect(toStringMethod, isNotNull);
      });

      test(
        'then the toString method returns just the class name',
        () {
          expect(
            toStringMethod?.body.toString(),
            contains("'EmptyException'"),
          );
        },
      );
    },
  );
}

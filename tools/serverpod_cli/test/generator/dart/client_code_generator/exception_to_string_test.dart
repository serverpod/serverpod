import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  group(
    'Given an exception class with fields when generating client code',
    () {
      ClassDeclaration? baseClass;
      MethodDeclaration? toStringMethod;

      setUpAll(() {
        var testClassName = 'MyException';
        var testClassFileName = 'my_exception';
        var expectedFilePath = path.join(
          '..',
          'example_project_client',
          'lib',
          'src',
          'protocol',
          '$testClassFileName.dart',
        );

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
    'Given an exception class without fields when generating client code',
    () {
      ClassDeclaration? baseClass;
      MethodDeclaration? toStringMethod;

      setUpAll(() {
        var testClassName = 'EmptyException';
        var testClassFileName = 'empty_exception';
        var expectedFilePath = path.join(
          '..',
          'example_project_client',
          'lib',
          'src',
          'protocol',
          '$testClassFileName.dart',
        );

        var models = [
          ExceptionClassDefinitionBuilder()
              .withClassName(testClassName)
              .withFileName(testClassFileName)
              .withFields([])
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

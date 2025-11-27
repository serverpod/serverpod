import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  group(
    'Given an exception class named DefaultException with string fields having defaultModelValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'DefaultException';
        var testClassFileName = 'default_exception';
        var expectedFilePath = path.join(
          'lib',
          'src',
          'generated',
          '$testClassFileName.dart',
        );

        var fields = [
          FieldDefinitionBuilder()
              .withName('defaultMessage')
              .withTypeDefinition('String', false)
              .withDefaults(defaultModelValue: '\'Default error message\'')
              .build(),
          FieldDefinitionBuilder()
              .withName('defaultNullMessage')
              .withTypeDefinition('String', true)
              .withDefaults(
                defaultModelValue: '\'Default model error message\'',
              )
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

        privateConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
              baseClass!,
              name: '_',
            );
      });

      group('then the DefaultException has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({String? defaultMessage, String? defaultNullMessage})',
            );
          },
        );

        test(
          'with defaultMessage default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('defaultMessage'),
            );
            expect(
              initializer?.toSource(),
              "defaultMessage = defaultMessage ?? 'Default error message'",
            );
          },
        );

        test(
          'with defaultNullMessage default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('defaultNullMessage'),
            );
            expect(
              initializer?.toSource(),
              "defaultNullMessage = defaultNullMessage ?? 'Default model error message'",
            );
          },
        );
      });
    },
  );
}

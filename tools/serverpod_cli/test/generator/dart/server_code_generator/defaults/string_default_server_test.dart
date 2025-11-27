import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  group(
    'Given a class named StringDefault with String fields having defaultModelValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'StringDefault';
        var testClassFileName = 'string_default';
        var expectedFilePath = path.join(
          'lib',
          'src',
          'generated',
          '$testClassFileName.dart',
        );

        var fields = [
          FieldDefinitionBuilder()
              .withName('stringDefault')
              .withTypeDefinition('String', false)
              .withDefaults(
                defaultModelValue: '\'This is a default model value\'',
              )
              .build(),
          FieldDefinitionBuilder()
              .withName('stringDefaultNull')
              .withTypeDefinition('String', true)
              .withDefaults(
                defaultModelValue: '\'This is a default model null value\'',
              )
              .build(),
        ];

        var models = [
          ModelClassDefinitionBuilder()
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

      group('then the StringDefault has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({String? stringDefault, String? stringDefaultNull})',
            );
          },
        );

        test(
          'with stringDefault default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('stringDefault'),
            );
            expect(
              initializer?.toSource(),
              'stringDefault = stringDefault ?? \'This is a default model value\'',
            );
          },
        );

        test(
          'with stringDefaultNull default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('stringDefaultNull'),
            );
            expect(
              initializer?.toSource(),
              'stringDefaultNull = stringDefaultNull ?? \'This is a default model null value\'',
            );
          },
        );
      });
    },
  );

  group(
    'Given a class named StringDefaultPersist with String fields having defaultPersistValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'StringDefaultPersist';
        var testClassFileName = 'string_default_persist';
        var expectedFilePath = path.join(
          'lib',
          'src',
          'generated',
          '$testClassFileName.dart',
        );

        var fields = [
          FieldDefinitionBuilder()
              .withName('stringDefaultPersist')
              .withTypeDefinition('String', true)
              .withDefaults(
                defaultPersistValue: '\'This is a default persist value\'',
              )
              .build(),
        ];

        var models = [
          ModelClassDefinitionBuilder()
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

      group('then the StringDefaultPersist has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({this.stringDefaultPersist})',
            );
          },
        );
      });
    },
  );
}

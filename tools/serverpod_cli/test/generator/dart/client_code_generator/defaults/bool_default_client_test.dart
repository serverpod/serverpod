import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  group(
    'Given a class named BoolDefault with bool fields having defaultModelValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'BoolDefault';
        var testClassFileName = 'bool_default';
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
              .withName('boolDefaultTrue')
              .withTypeDefinition('bool', false)
              .withDefaults(defaultModelValue: 'true')
              .build(),
          FieldDefinitionBuilder()
              .withName('boolDefaultFalse')
              .withTypeDefinition('bool', false)
              .withDefaults(defaultModelValue: 'false')
              .build(),
          FieldDefinitionBuilder()
              .withName('boolDefaultNullFalse')
              .withTypeDefinition('bool', true)
              .withDefaults(defaultModelValue: 'false')
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

      group('then the BoolDefault has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({bool? boolDefaultTrue, bool? boolDefaultFalse, bool? boolDefaultNullFalse})',
            );
          },
        );

        test(
          'with boolDefaultTrue default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('boolDefaultTrue'),
            );
            expect(
              initializer?.toSource(),
              'boolDefaultTrue = boolDefaultTrue ?? true',
            );
          },
        );

        test(
          'with boolDefaultFalse default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('boolDefaultFalse'),
            );
            expect(
              initializer?.toSource(),
              'boolDefaultFalse = boolDefaultFalse ?? false',
            );
          },
        );

        test(
          'with boolDefaultNullFalse default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('boolDefaultNullFalse'),
            );
            expect(
              initializer?.toSource(),
              'boolDefaultNullFalse = boolDefaultNullFalse ?? false',
            );
          },
        );
      });
    },
  );

  group(
    'Given a class named BoolDefaultPersist with bool fields having defaultPersistValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'BoolDefaultPersist';
        var testClassFileName = 'bool_default_persist';
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
              .withName('boolDefaultPersistTrue')
              .withTypeDefinition('bool', true)
              .withDefaults(defaultPersistValue: 'true')
              .build(),
          FieldDefinitionBuilder()
              .withName('boolDefaultPersistFalse')
              .withTypeDefinition('bool', true)
              .withDefaults(defaultPersistValue: 'false')
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

      group('then the BoolDefaultPersist has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({this.boolDefaultPersistTrue, this.boolDefaultPersistFalse})',
            );
          },
        );
      });
    },
  );
}

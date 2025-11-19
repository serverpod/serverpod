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
    'Given a class named UuidDefault with Uuid fields having defaultModelValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'UuidDefault';
        var testClassFileName = 'uuid_default';
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
              .withName('uuidDefaultRandom')
              .withTypeDefinition('UuidValue', false)
              .withDefaults(defaultModelValue: 'random')
              .build(),
          FieldDefinitionBuilder()
              .withName('uuidDefaultRandomV7')
              .withTypeDefinition('UuidValue', false)
              .withDefaults(defaultModelValue: 'random_v7')
              .build(),
          FieldDefinitionBuilder()
              .withName('uuidDefaultStr')
              .withTypeDefinition('UuidValue', false)
              .withDefaults(
                defaultModelValue: '\'550e8400-e29b-41d4-a716-446655440000\'',
              )
              .build(),
          FieldDefinitionBuilder()
              .withName('uuidDefaultStrNull')
              .withTypeDefinition('UuidValue', true)
              .withDefaults(
                defaultModelValue: '\'550e8400-e29b-41d4-a716-446655440000\'',
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

      group('then the UuidDefault has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource().withoutImportPrefix,
              '({UuidValue? uuidDefaultRandom, UuidValue? uuidDefaultRandomV7, UuidValue? uuidDefaultStr, UuidValue? uuidDefaultStrNull})',
            );
          },
        );

        test(
          'with uuidDefaultRandom default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('uuidDefaultRandom'),
            );
            expect(
              initializer?.toSource().withoutImportPrefix,
              'uuidDefaultRandom = uuidDefaultRandom ?? Uuid().v4obj()',
            );
          },
        );

        test(
          'with uuidDefaultRandomV7 default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('uuidDefaultRandomV7'),
            );
            expect(
              initializer?.toSource().withoutImportPrefix,
              'uuidDefaultRandomV7 = uuidDefaultRandomV7 ?? Uuid().v7obj()',
            );
          },
        );

        test(
          'with uuidDefaultStr default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('uuidDefaultStr'),
            );
            expect(
              initializer?.toSource().withoutImportPrefix,
              'uuidDefaultStr = uuidDefaultStr ?? UuidValue.fromString(\'550e8400-e29b-41d4-a716-446655440000\')',
            );
          },
        );

        test(
          'with uuidDefaultStrNull default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('uuidDefaultStrNull'),
            );
            expect(
              initializer?.toSource().withoutImportPrefix,
              'uuidDefaultStrNull = uuidDefaultStrNull ?? UuidValue.fromString(\'550e8400-e29b-41d4-a716-446655440000\')',
            );
          },
        );
      });
    },
  );

  group(
    'Given a class named UuidDefaultPersist with Uuid fields having defaultPersistValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'UuidDefaultPersist';
        var testClassFileName = 'uuid_default_persist';
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
              .withName('uuidDefaultPersistRandom')
              .withTypeDefinition('UuidValue', true)
              .withDefaults(defaultPersistValue: 'random')
              .build(),
          FieldDefinitionBuilder()
              .withName('uuidDefaultPersistStr')
              .withTypeDefinition('UuidValue', true)
              .withDefaults(
                defaultPersistValue: '\'550e8400-e29b-41d4-a716-446655440000\'',
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

      group('then the UuidDefaultPersist has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({this.uuidDefaultPersistRandom, this.uuidDefaultPersistStr})',
            );
          },
        );
      });
    },
  );
}

extension _StrExt on String {
  String get withoutImportPrefix {
    return replaceAll(RegExp(r'_i\d+\.'), '');
  }
}

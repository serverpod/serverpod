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
    'Given a class named DateTimeDefault with DateTime fields having defaultModelValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'DateTimeDefault';
        var testClassFileName = 'datetime_default';
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
              .withName('dateTimeDefaultNow')
              .withTypeDefinition('DateTime', false)
              .withDefaults(defaultModelValue: 'now')
              .build(),
          FieldDefinitionBuilder()
              .withName('dateTimeDefaultStr')
              .withTypeDefinition('DateTime', false)
              .withDefaults(defaultModelValue: '2024-05-24T22:00:00.000Z')
              .build(),
          FieldDefinitionBuilder()
              .withName('dateTimeDefaultStrNull')
              .withTypeDefinition('DateTime', true)
              .withDefaults(defaultModelValue: '2024-05-24T22:00:00.000Z')
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

      group('then the DateTimeDefault has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({DateTime? dateTimeDefaultNow, DateTime? dateTimeDefaultStr, DateTime? dateTimeDefaultStrNull})',
            );
          },
        );

        test(
          'with dateTimeDefaultNow default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('dateTimeDefaultNow'),
            );
            expect(
              initializer?.toSource(),
              'dateTimeDefaultNow = dateTimeDefaultNow ?? DateTime.now()',
            );
          },
        );

        test(
          'with dateTimeDefaultStr default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('dateTimeDefaultStr'),
            );
            expect(
              initializer?.toSource(),
              'dateTimeDefaultStr = dateTimeDefaultStr ?? DateTime.parse(\'2024-05-24T22:00:00.000Z\')',
            );
          },
        );

        test(
          'with dateTimeDefaultStrNull default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('dateTimeDefaultStrNull'),
            );
            expect(
              initializer?.toSource(),
              'dateTimeDefaultStrNull = dateTimeDefaultStrNull ?? DateTime.parse(\'2024-05-24T22:00:00.000Z\')',
            );
          },
        );
      });
    },
  );

  group(
    'Given a class named DateTimeDefaultPersist with DateTime fields having defaultPersistValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'DateTimeDefaultPersist';
        var testClassFileName = 'datetime_default_persist';
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
              .withName('dateTimeDefaultPersistNow')
              .withTypeDefinition('DateTime', true)
              .withDefaults(defaultPersistValue: 'now')
              .build(),
          FieldDefinitionBuilder()
              .withName('dateTimeDefaultPersistStr')
              .withTypeDefinition('DateTime', true)
              .withDefaults(defaultPersistValue: '2024-05-24T22:00:00.000Z')
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

      group('then the DateTimeDefaultPersist has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({this.dateTimeDefaultPersistNow, this.dateTimeDefaultPersistStr})',
            );
          },
        );
      });
    },
  );
}

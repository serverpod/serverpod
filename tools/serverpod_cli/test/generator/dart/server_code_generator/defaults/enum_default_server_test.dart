import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/enum_definition_builder.dart';
import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var enumDefinition = EnumDefinitionBuilder()
      .withClassName('ByNameEnum')
      .withFileName('by_name_enum')
      .withValues([
        ProtocolEnumValueDefinition('byName1'),
        ProtocolEnumValueDefinition('byName2'),
      ])
      .build();

  group(
    'Given a class named EnumDefault with enum fields having defaultModelValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'EnumDefault';
        var testClassFileName = 'enum_default';
        var expectedFilePath = path.join(
          'lib',
          'src',
          'generated',
          '$testClassFileName.dart',
        );

        var fields = [
          FieldDefinitionBuilder()
              .withName('byNameEnumDefault')
              .withEnumDefinition(enumDefinition, false)
              .withDefaults(defaultModelValue: 'byName1')
              .build(),
          FieldDefinitionBuilder()
              .withName('byNameEnumDefaultNull')
              .withEnumDefinition(enumDefinition, true)
              .withDefaults(defaultModelValue: 'byName2')
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

      group('then the EnumDefault has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({ByNameEnum? byNameEnumDefault, ByNameEnum? byNameEnumDefaultNull})',
            );
          },
        );

        test(
          'with byNameEnumDefault default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('byNameEnumDefault'),
            );
            expect(
              initializer?.toSource(),
              'byNameEnumDefault = byNameEnumDefault ?? ByNameEnum.byName1',
            );
          },
        );

        test(
          'with byNameEnumDefaultNull default value set correctly',
          () {
            var initializer = privateConstructor?.initializers.firstWhere(
              (e) => e.toSource().contains('byNameEnumDefaultNull'),
            );
            expect(
              initializer?.toSource(),
              'byNameEnumDefaultNull = byNameEnumDefaultNull ?? ByNameEnum.byName2',
            );
          },
        );
      });
    },
  );

  group(
    'Given a class named EnumDefaultPersist with enum fields having defaultPersistValue when generating code',
    () {
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;

      setUpAll(() {
        var testClassName = 'EnumDefaultPersist';
        var testClassFileName = 'enum_default_persist';
        var expectedFilePath = path.join(
          'lib',
          'src',
          'generated',
          '$testClassFileName.dart',
        );

        var fields = [
          FieldDefinitionBuilder()
              .withName('byNameEnumDefaultPersist')
              .withEnumDefinition(enumDefinition, true)
              .withDefaults(defaultPersistValue: 'byName1')
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

      group('then the EnumDefaultPersist has a private constructor', () {
        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test(
          'with the class vars as params',
          () {
            expect(
              privateConstructor?.parameters.toSource(),
              '({this.byNameEnumDefaultPersist})',
            );
          },
        );
      });
    },
  );
}

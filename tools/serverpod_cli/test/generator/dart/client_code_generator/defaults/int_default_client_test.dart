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
      'Given a class named IntDefault with int fields having defaultModelValue when generating code',
      () {
    ClassDeclaration? baseClass;
    ConstructorDeclaration? privateConstructor;

    setUpAll(() {
      var testClassName = 'IntDefault';
      var testClassFileName = 'int_default';
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
            .withName('intDefault')
            .withTypeInt(defaultModelValue: 10)
            .build(),
        FieldDefinitionBuilder()
            .withName('intDefaultNull')
            .withTypeInt(defaultModelValue: 20, nullable: true)
            .build(),
      ];

      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withFields(fields)
            .build()
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var compilationUnit =
          parseString(content: codeMap[expectedFilePath]!).unit;

      baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName,
      );

      privateConstructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
        baseClass!,
        name: '_',
      );
    });

    group('then the IntDefault has a private constructor', () {
      test('defined', () {
        expect(privateConstructor, isNotNull);
      });

      test(
        'with the class vars as params',
        () {
          expect(
            privateConstructor?.parameters.toSource(),
            '({int? intDefault, int? intDefaultNull})',
          );
        },
      );

      test(
        'with intDefault default value set correctly',
        () {
          var initializer = privateConstructor?.initializers
              .firstWhere((e) => e.toSource().contains('intDefault'));
          expect(initializer?.toSource(), 'intDefault = intDefault ?? 10');
        },
      );

      test(
        'with intDefaultNull default value set correctly',
        () {
          var initializer = privateConstructor?.initializers
              .firstWhere((e) => e.toSource().contains('intDefaultNull'));
          expect(
              initializer?.toSource(), 'intDefaultNull = intDefaultNull ?? 20');
        },
      );
    });
  });

  group(
      'Given a class named IntDefaultPersist with int fields having defaultPersistValue when generating code',
      () {
    ClassDeclaration? baseClass;
    ConstructorDeclaration? privateConstructor;

    setUpAll(() {
      var testClassName = 'IntDefaultPersist';
      var testClassFileName = 'int_default_persist';
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
            .withName('intDefaultPersist')
            .withTypeInt(defaultPersistValue: 10, nullable: true)
            .build(),
      ];

      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withFields(fields)
            .build()
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var compilationUnit =
          parseString(content: codeMap[expectedFilePath]!).unit;
      baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName,
      );

      privateConstructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
        baseClass!,
        name: '_',
      );
    });

    group('then the IntDefaultPersist has a private constructor', () {
      test('defined', () {
        expect(privateConstructor, isNotNull);
      });

      test(
        'with the class vars as params',
        () {
          expect(privateConstructor?.parameters.toSource(),
              '({this.intDefaultPersist})');
        },
      );
    });
  });
}

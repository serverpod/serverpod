import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
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
      'Given a class with serverOnly scoped fields having defaultModelValue when generating server code',
      () {
    ClassDeclaration? baseClass;
    ConstructorDeclaration? privateConstructor;

    setUpAll(() {
      var testClassName = 'ServerOnlyDefault';
      var testClassFileName = 'server_only_default';
      var expectedFilePath =
          path.join('lib', 'src', 'generated', '$testClassFileName.dart');

      var fields = [
        FieldDefinitionBuilder()
            .withName('normalField')
            .withTypeDefinition('String', false)
            .withScope(ModelFieldScopeDefinition.all)
            .build(),
        FieldDefinitionBuilder()
            .withName('serverOnlyField')
            .withTypeDefinition('int', true)
            .withScope(ModelFieldScopeDefinition.serverOnly)
            .withDefaults(defaultModelValue: '-1')
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

    group('then the ServerOnlyDefault server class', () {
      test('has serverOnlyField in constructor parameters', () {
        expect(
          privateConstructor?.parameters.toSource(),
          contains('int? serverOnlyField'),
        );
      });

      test('has serverOnlyField default value initializer', () {
        var initializer = privateConstructor?.initializers
            .firstWhere((e) => e.toSource().contains('serverOnlyField'));
        expect(
          initializer?.toSource(),
          'serverOnlyField = serverOnlyField ?? -1',
        );
      });

      test('has serverOnly field as class property', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            baseClass!,
            name: 'serverOnlyField',
            type: 'int?',
          ),
          isTrue,
          reason: 'serverOnly field should be present in server model',
        );
      });
    });
  });
}

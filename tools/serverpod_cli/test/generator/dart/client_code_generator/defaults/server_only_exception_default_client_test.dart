import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  group(
      'Given an exception class with serverOnly scoped fields having defaultModelValue when generating client code',
      () {
    ClassDeclaration? baseClass;
    ConstructorDeclaration? privateConstructor;

    setUpAll(() {
      var testClassName = 'ServerOnlyException';
      var testClassFileName = 'server_only_exception';
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
            .withScope(ModelFieldScopeDefinition.all)
            .withDefaults(defaultModelValue: '\'Default error message\'')
            .build(),
        FieldDefinitionBuilder()
            .withName('serverErrorCode')
            .withTypeDefinition('int', true)
            .withScope(ModelFieldScopeDefinition.serverOnly)
            .withDefaults(defaultModelValue: '500')
            .build(),
      ];

      var models = [
        ExceptionClassDefinitionBuilder()
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

    group('then the ServerOnlyException client class', () {
      test('has message field default value initializer', () {
        var initializer = privateConstructor?.initializers
            .firstWhere((e) => e.toSource().contains('message'));
        expect(
          initializer?.toSource(),
          "message = message ?? 'Default error message'",
        );
      });

      test('does NOT have serverErrorCode field initializer', () {
        var initializerSources = privateConstructor?.initializers
                .map((init) => init.toSource())
                .toList() ??
            [];

        expect(
          initializerSources,
          isNot(contains(contains('serverErrorCode'))),
          reason:
              'serverOnly field should not have initializer in client exception',
        );
      });
    });
  });
}

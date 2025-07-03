import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
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
      'Given a class with serverOnly scoped fields having defaultModelValue when generating client code',
      () {
    ClassDeclaration? baseClass;
    ConstructorDeclaration? privateConstructor;

    setUpAll(() {
      var testClassName = 'ServerOnlyDefault';
      var testClassFileName = 'server_only_default';
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
        FieldDefinitionBuilder()
            .withName('serverOnlyStringField')
            .withTypeDefinition('String', true)
            .withScope(ModelFieldScopeDefinition.serverOnly)
            .withDefaults(defaultModelValue: "'Server only message'")
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

    group('then the ServerOnlyDefault class', () {
      test('is generated', () {
        expect(baseClass, isNotNull);
      });

      test('has normalField in constructor parameters', () {
        final paramsSource = privateConstructor?.parameters.toSource() ?? '';
        expect(
          paramsSource.contains('String normalField') ||
              paramsSource.contains('{required this.normalField}'),
          isTrue,
          reason: 'normalField should be present as a required parameter',
        );
      });
      test('does NOT have serverOnlyField in constructor parameters', () {
        expect(
          privateConstructor?.parameters.toSource(),
          isNot(contains('serverOnlyField')),
        );
      });

      test('does NOT have serverOnlyStringField in constructor parameters', () {
        expect(
          privateConstructor?.parameters.toSource(),
          isNot(contains('serverOnlyStringField')),
        );
      });

      test('has NO initializers for serverOnly fields with defaults', () {
        var initializerSources = privateConstructor?.initializers
                .map((init) => init.toSource())
                .toList() ??
            [];

        expect(
          initializerSources,
          isNot(contains(contains('serverOnlyField'))),
          reason: 'serverOnly field should not have initializer in client code',
        );

        expect(
          initializerSources,
          isNot(contains(contains('serverOnlyStringField'))),
          reason:
              'serverOnly string field should not have initializer in client code',
        );
      });

      test('does NOT have serverOnly fields as class properties', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            baseClass!,
            name: 'serverOnlyField',
            type: 'int?',
          ),
          isFalse,
          reason: 'serverOnly field should not be present in client model',
        );
      });
    });
  });
}

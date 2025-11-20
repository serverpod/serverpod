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
    'Given a class with serverOnly field having default=now when generating client code',
    () {
      late String generatedCode;
      ClassDeclaration? baseClass;
      ConstructorDeclaration? privateConstructor;
      ConstructorDeclaration? factoryConstructor;

      setUpAll(() {
        var testClassName = 'ServerOnlyDateTimeNow';
        var testClassFileName = 'server_only_datetime_now';
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
              .withName('name')
              .withTypeDefinition('String', false)
              .withScope(ModelFieldScopeDefinition.all)
              .build(),
          FieldDefinitionBuilder()
              .withName('createdAt')
              .withTypeDefinition('DateTime', true)
              .withScope(ModelFieldScopeDefinition.serverOnly)
              .withDefaults(defaultModelValue: 'now')
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

        generatedCode = codeMap[expectedFilePath]!;

        var compilationUnit = parseString(
          content: generatedCode,
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

        factoryConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
              baseClass!,
              name: null,
            );
      });

      test('then the class is generated', () {
        expect(baseClass, isNotNull);
      });

      test('then createdAt field is NOT present in the class', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            baseClass!,
            name: 'createdAt',
          ),
          isFalse,
          reason: 'serverOnly field should not be in client model',
        );
      });

      test('then createdAt is NOT in private constructor parameters', () {
        expect(
          privateConstructor?.parameters.toSource(),
          isNot(contains('createdAt')),
          reason: 'serverOnly field should not be in private constructor',
        );
      });

      test('then createdAt is NOT in factory constructor parameters', () {
        expect(
          factoryConstructor?.parameters.toSource(),
          isNot(contains('createdAt')),
          reason: 'serverOnly field should not be in factory constructor',
        );
      });

      test('then DateTime.now() is NOT in any constructor initializer', () {
        var initializerSources =
            privateConstructor?.initializers
                .map((init) => init.toSource())
                .toList() ??
            [];

        expect(
          initializerSources.any((source) => source.contains('DateTime.now')),
          isFalse,
          reason: 'DateTime.now() should not appear in client constructor',
        );
      });

      test('then DateTime.now() is NOT anywhere in generated code', () {
        expect(
          generatedCode.contains('DateTime.now'),
          isFalse,
          reason: 'DateTime.now() should not appear in client code at all',
        );
      });

      test('then createdAt is NOT in copyWith method', () {
        var copyWithMethod = baseClass!.members
            .whereType<MethodDeclaration>()
            .firstWhere((m) => m.name.lexeme == 'copyWith');

        expect(
          copyWithMethod.toSource(),
          isNot(contains('createdAt')),
          reason: 'serverOnly field should not be in copyWith method',
        );
      });

      test('then createdAt is NOT in toJson method', () {
        var toJsonMethod = baseClass!.members
            .whereType<MethodDeclaration>()
            .firstWhere((m) => m.name.lexeme == 'toJson');

        expect(
          toJsonMethod.toSource(),
          isNot(contains('createdAt')),
          reason: 'serverOnly field should not be serialized in client toJson',
        );
      });

      test('then createdAt is NOT in fromJson constructor', () {
        var fromJsonConstructor = baseClass!.members
            .whereType<ConstructorDeclaration>()
            .firstWhere((c) => c.name?.lexeme == 'fromJson');

        expect(
          fromJsonConstructor.toSource(),
          isNot(contains('createdAt')),
          reason: 'serverOnly field should not be in fromJson constructor',
        );
      });
    },
  );
}

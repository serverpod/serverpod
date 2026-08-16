import 'package:analyzer/dart/analysis/utilities.dart';
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
  var expectedFilePath = path.join('lib', 'src', 'generated', 'example.dart');

  group(
    'Given a table class with id type "int" with a field that should persist but is scoped too none',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName('Example')
            .withFileName('example')
            .withTableName('example')
            .withIdFieldType(SupportedIdType.int)
            .withSimpleField('extra', 'bool')
            .withField(
              FieldDefinitionBuilder()
                  .withName('_name')
                  .withType(TypeDefinition(className: 'String', nullable: true))
                  .withShouldPersist(true)
                  .withScope(ModelFieldScopeDefinition.none)
                  .build(),
            )
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      var implicitClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: 'ExampleImplicit',
      );

      test(
        'then an implicit class named "ExampleImplicit" is correctly generated',
        () {
          expect(implicitClass, isNotNull);
        },
      );

      test(
        'then the private constructor have the id parameter with type "int"',
        () {
          var constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                implicitClass!,
                name: '_',
              );

          expect(
            constructor?.parameters.toSource(),
            contains('int? id,'),
          );
        },
      );
    },
  );

  group(
    'Given a table class with id type "UUIDv4" with a field that should persist but is scoped too none',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName('Example')
            .withFileName('example')
            .withTableName('example')
            .withIdFieldType(SupportedIdType.uuidV4)
            .withSimpleField('extra', 'bool')
            .withField(
              FieldDefinitionBuilder()
                  .withName('_name')
                  .withType(TypeDefinition(className: 'String', nullable: true))
                  .withShouldPersist(true)
                  .withScope(ModelFieldScopeDefinition.none)
                  .build(),
            )
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      var implicitClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: 'ExampleImplicit',
      );

      test(
        'then an implicit class named "ExampleImplicit" is correctly generated',
        () {
          expect(implicitClass, isNotNull);
        },
      );

      test(
        'then the private constructor have the id parameter with type "UuidValue"',
        () {
          var constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                implicitClass!,
                name: '_',
              );

          expect(
            constructor?.parameters.toSource(),
            contains('UuidValue? id,'),
          );
        },
      );
    },
  );
}

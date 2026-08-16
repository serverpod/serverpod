import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/module_config_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
const generator = DartServerCodeGenerator();

void main() {
  group('Given a model that references a type from module:serverpod', () {
    var config = GeneratorConfigBuilder().withName(projectName).build();

    var myModel = ModelClassDefinitionBuilder()
        .withClassName('MyModel')
        .withFileName('my_model')
        .withField(
          FieldDefinitionBuilder()
              .withName('uuidValue')
              .withType(
                TypeDefinitionBuilder()
                    .withClassName('UuidValue')
                    .withUrl('module:serverpod')
                    .withNullable(true)
                    .build(),
              )
              .build(),
        )
        .build();

    var models = [myModel];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    String getExpectedFilePath(String fileName) => p.joinAll([
      'lib',
      'src',
      'generated',
      '$fileName.dart',
    ]);

    var myModelCode = codeMap[getExpectedFilePath('my_model')]!;
    var compilationUnit = parseString(content: myModelCode).unit;

    test(
      'then the generated file does not have compilation errors',
      () {
        var parseResult = parseString(content: myModelCode);
        expect(parseResult.errors, isEmpty);
      },
    );

    test(
      'then the generated file imports from package:serverpod/serverpod.dart',
      () {
        var import = CompilationUnitHelpers.tryFindImportDirective(
          compilationUnit,
          uri: 'package:serverpod/serverpod.dart',
        );

        expect(import, isNotNull);
      },
    );
  });

  group('Given a model that references AuthUser from serverpod_auth_core', () {
    var authCoreModule = ModuleConfigBuilder(
      'serverpod_auth_core',
      'serverpod_auth_core',
    ).build();

    var config = GeneratorConfigBuilder().withName(projectName).withModules([
      authCoreModule,
    ]).build();

    var myDomainData = ModelClassDefinitionBuilder()
        .withClassName('MyDomainData')
        .withFileName('my_domain_data')
        .withField(
          FieldDefinitionBuilder()
              .withName('authUser')
              .withType(
                TypeDefinitionBuilder()
                    .withClassName('AuthUser')
                    .withUrl('module:serverpod_auth_core')
                    .withNullable(true)
                    .build(),
              )
              .withRelationTo('serverpod_auth_core_user', 'id')
              .build(),
        )
        .withSimpleField('additionalInfo', 'String')
        .withTableName('my_domain_data')
        .build();

    var models = [myDomainData];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    String getExpectedFilePath(String fileName) => p.joinAll([
      'lib',
      'src',
      'generated',
      '$fileName.dart',
    ]);

    var myDomainDataCode = codeMap[getExpectedFilePath('my_domain_data')]!;
    var compilationUnit = parseString(content: myDomainDataCode).unit;

    test(
      'then the generated file does not have compilation errors',
      () {
        var parseResult = parseString(content: myDomainDataCode);
        expect(parseResult.errors, isEmpty);
      },
    );

    test(
      'then the generated file has an import directive for serverpod_auth_core_server package',
      () {
        var import = CompilationUnitHelpers.tryFindImportDirective(
          compilationUnit,
          uri:
              'package:serverpod_auth_core_server/serverpod_auth_core_server.dart',
        );

        expect(import, isNotNull);
      },
    );
  });
}

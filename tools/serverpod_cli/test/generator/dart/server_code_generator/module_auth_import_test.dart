import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
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
  group('Given a model that references AuthUser from serverpod_auth_core', () {
    // Set up module config for serverpod_auth_core
    var authCoreModule =
        ModuleConfigBuilder('serverpod_auth_core', 'serverpod_auth_core')
            .build();

    var config = GeneratorConfigBuilder()
        .withName(projectName)
        .withModules([authCoreModule])
        .build();;

    // Define AuthUser from the auth_core module
    var authUser = ModelClassDefinitionBuilder()
        .withClassName('AuthUser')
        .withFileName('auth_user')
        .withSimpleField('id', 'UuidValue')
        .withSimpleField('scopeNames', 'Set<String>')
        .withTableName('serverpod_auth_core_user')
        .build();

    // Define a custom model that references AuthUser
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
      'then the generated file has an import directive for serverpod_auth_core_server package',
      () {
        var import = CompilationUnitHelpers.tryFindImportDirective(
          compilationUnit,
          uri:
              'package:serverpod_auth_core_server/serverpod_auth_core_server.dart',
        );

        expect(
          import,
          isNotNull,
          reason:
              'Generated code should import the auth_core module package for AuthUser type',
        );
      },
    );

    test(
      'then the generated file does not have compilation errors',
      () {
        // Parse and check for syntax errors
        var parseResult = parseString(content: myDomainDataCode);
        expect(
          parseResult.errors,
          isEmpty,
          reason: 'Generated code should be valid Dart code without errors',
        );
      },
    );
  });
}

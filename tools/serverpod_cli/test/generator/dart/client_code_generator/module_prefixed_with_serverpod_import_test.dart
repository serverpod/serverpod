import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/module_config_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
const generator = DartClientCodeGenerator();

void main() {
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
              .build(),
        )
        .withSimpleField('additionalInfo', 'String')
        .build();

    var models = [myDomainData];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    String getExpectedFilePath(String fileName) => p.joinAll([
      '..',
      'example_project_client',
      'lib',
      'src',
      'protocol',
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
      'then the generated file has an import directive for serverpod_auth_core_client package',
      () {
        var import = CompilationUnitHelpers.tryFindImportDirective(
          compilationUnit,
          uri:
              'package:serverpod_auth_core_client/serverpod_auth_core_client.dart',
        );

        expect(import, isNotNull);
      },
    );
  });
}

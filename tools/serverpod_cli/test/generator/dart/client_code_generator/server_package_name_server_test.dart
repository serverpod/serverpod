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

const generator = DartClientCodeGenerator();

void main() {
  group(
    'Given a server package named "server" when generating client code',
    () {
      var authCoreModule = ModuleConfigBuilder(
        'serverpod_auth_core',
        'serverpod_auth_core',
      ).build();

      var config = GeneratorConfigBuilder()
          .withServerPackage('server')
          .withDartClientPackage('client')
          .withRelativeDartClientPackagePathParts(['..', 'client'])
          .withModules([authCoreModule])
          .build();

      var myModel = ModelClassDefinitionBuilder()
          .withClassName('MyModel')
          .withFileName('my_model')
          .withField(
            FieldDefinitionBuilder()
                .withName('authSuccess')
                .withType(
                  TypeDefinitionBuilder()
                      .withClassName('AuthSuccess')
                      .withUrl(
                        'package:serverpod_auth_core_server/src/protocol/common/models/auth_success.dart',
                      )
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
        '..',
        'client',
        'lib',
        'src',
        'protocol',
        '$fileName.dart',
      ]);

      var myModelCode = codeMap[getExpectedFilePath('my_model')]!;
      var compilationUnit = parseString(content: myModelCode).unit;

      test(
        'then the generated file does not have compilation errors.',
        () {
          var parseResult = parseString(content: myModelCode);
          expect(parseResult.errors, isEmpty);
        },
      );

      test(
        'then the generated file correctly imports from serverpod_auth_core_client.',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            compilationUnit,
            uri:
                'package:serverpod_auth_core_client/src/protocol/common/models/auth_success.dart',
          );

          expect(
            import,
            isNotNull,
            reason: 'Expected import from serverpod_auth_core_client',
          );
        },
      );

      test(
        'then the generated file does NOT import from clientpod_auth_core_server.',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            compilationUnit,
            uri:
                'package:clientpod_auth_core_server/src/protocol/common/models/auth_success.dart',
          );

          expect(
            import,
            isNull,
            reason:
                'Should not have incorrect import from clientpod_auth_core_server (bug)',
          );
        },
      );

      test(
        'then the generated file does NOT import from clientpod_auth_core_client.',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            compilationUnit,
            uri:
                'package:clientpod_auth_core_client/src/protocol/common/models/auth_success.dart',
          );

          expect(
            import,
            isNull,
            reason:
                'Should not have incorrect import from clientpod_auth_core_client (another variant of the bug)',
          );
        },
      );
    },
  );
}

import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:serverpod_cli/src/generator/yaml/endpoint_description_generator.dart';
import 'package:serverpod_cli/src/generator/yaml/serverpod_manifest_generator.dart';
import 'package:test/test.dart';

import '../test_util/builders/generator_config_builder.dart';
import '../test_util/builders/model_class_definition_builder.dart';

void main() {
  test(
    'Given plain, server-only and shared models, '
    'when comparing serializableModelPaths with what the generators write, '
    'then the paths are the same.',
    () {
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(['server_root'])
          .withRelativeDartClientPackagePathParts(['example_client'])
          .withSharedModelsSourcePathsParts({
            'shared_pkg': ['packages', 'shared'],
          })
          .withModules([])
          .build();
      final models = [
        ModelClassDefinitionBuilder()
            .withClassName('Plain')
            .withFileName('plain')
            .withSimpleField('name', 'String')
            .build(),
        ModelClassDefinitionBuilder()
            .withClassName('Secret')
            .withFileName('secret')
            .withSubDirParts(['internal'])
            .withServerOnly(true)
            .withSimpleField('name', 'String')
            .build(),
        ModelClassDefinitionBuilder()
            .withClassName('Shared')
            .withFileName('shared')
            .withSharedPackageName('shared_pkg')
            .withSimpleField('name', 'String')
            .build(),
        // Owned by a package this project does not generate for.
        ModelClassDefinitionBuilder()
            .withClassName('Foreign')
            .withFileName('foreign')
            .withSharedPackageName('other_pkg')
            .withSimpleField('name', 'String')
            .build(),
      ];
      const generators = <CodeGenerator>[
        DartServerCodeGenerator(),
        DartClientCodeGenerator(),
        DartSharedCodeGenerator(),
        EndpointDescriptionGenerator(),
        ServerpodManifestGenerator(),
      ];

      final paths = ServerpodCodeGenerator.serializableModelPaths(
        models: models,
        config: config,
      );

      final written = {
        for (final generator in generators)
          ...generator
              .generateSerializableModelsCode(models: models, config: config)
              .keys,
      };
      // Plain on server and client, Secret on the server, Shared in its package.
      expect(written, hasLength(4));
      expect(paths, equals(written));
    },
  );
}

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:serverpod_cli/src/generator/yaml/serverpod_manifest_generator.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/builders/module_config_builder.dart';

const generator = ServerpodManifestGenerator();
const protocolDefinition = ProtocolDefinition(
  endpoints: [],
  models: [],
  futureCalls: [],
);

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'manifest.yaml',
  );

  test(
    'Given an internal package that owns a shared package, '
    'when generating its Serverpod manifest, '
    'then the manifest contains the package name.',
    () {
      var config = GeneratorConfigBuilder()
          .withPackageType(PackageType.internal)
          .withSharedModelsSourcePathsParts({
            'example_shared': ['..', 'example_shared'],
          })
          .build();

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(
        codeMap,
        equals({
          expectedFileName: '''
version: 1
shared_packages:
  - example_shared
''',
        }),
      );
    },
  );

  test(
    'Given a module with the databaseSync experimental feature and the '
    'serverpod_offline_sync module, '
    'when generating its Serverpod manifest, '
    'then the manifest contains the sync tables flag.',
    () {
      var config = GeneratorConfigBuilder()
          .withPackageType(PackageType.module)
          .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
          .withModules([
            ModuleConfigBuilder(
              'serverpod_offline_sync',
              'offline_sync',
            ).build(),
          ])
          .build();

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(
        codeMap,
        equals({
          expectedFileName: '''
version: 1
shared_packages: []
sync_tables: true
''',
        }),
      );
    },
  );

  test(
    'Given a module that owns shared packages, '
    'when generating its Serverpod manifest, '
    'then the manifest contains their package names.',
    () {
      var config = GeneratorConfigBuilder()
          .withPackageType(PackageType.module)
          .withSharedModelsSourcePathsParts({
            'first_shared': ['..', 'first_shared'],
            'second_shared': ['..', 'second_shared'],
          })
          .build();

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(
        codeMap,
        equals({
          expectedFileName: '''
version: 1
shared_packages:
  - first_shared
  - second_shared
''',
        }),
      );
    },
  );

  test(
    'Given a regular server project, '
    'when generating its Serverpod manifest, '
    'then no manifest is created.',
    () {
      var config = GeneratorConfigBuilder().build();

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(codeMap, isEmpty);
    },
  );

  test(
    'Given a module without shared packages, '
    'when generating its Serverpod manifest, '
    'then no manifest is created.',
    () {
      var config = GeneratorConfigBuilder()
          .withPackageType(PackageType.module)
          .build();

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(codeMap, isEmpty);
    },
  );

  test(
    'Given a previously generated manifest whose metadata is no longer present, '
    'when cleaning generated files, '
    'then the manifest is removed.',
    () async {
      var projectDirectory = Directory.systemTemp.createTempSync(
        'serverpod_manifest_test_',
      );
      addTearDown(() => projectDirectory.delete(recursive: true));
      var config = GeneratorConfigBuilder()
          .withPackageType(PackageType.module)
          .withServerPackageDirectoryPathParts([projectDirectory.path])
          .withRelativeDartClientPackagePathParts(['client'])
          .build();
      var manifestFile = File(
        path.joinAll(config.generatedServerpodManifestFilePathParts),
      );
      manifestFile.createSync(recursive: true);
      manifestFile.writeAsStringSync('''
version: 1
shared_packages:
  - obsolete_shared
''');
      Directory(
        path.joinAll(config.generatedDartClientModelPathParts),
      ).createSync(recursive: true);

      await ServerpodCodeGenerator.cleanPreviouslyGeneratedFiles(
        generatedFiles: {},
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(manifestFile.existsSync(), isFalse);
    },
  );
}

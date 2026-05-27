import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';

const _protocolBackupMarker = 'UNIQUE_PROTOCOL_BACKUP_MARKER';

GeneratorConfig _buildTestConfig(Directory projectDir) {
  return GeneratorConfigBuilder()
      .withName('test')
      .withServerPackageDirectoryPathParts([projectDir.path])
      .withRelativeDartClientPackagePathParts(['test_client'])
      .withModules([
        ModuleConfig(
          type: PackageType.server,
          name: 'test',
          nickname: 'test',
          migrationVersions: [],
          serverPackageDirectoryPathParts: [projectDir.path],
        ),
      ])
      .build();
}

void main() {
  group(
    'Given an existing protocol.dart when model-only generation runs',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;
      late File protocolFile;

      tearDownAll(() => projectDir.deleteIfExists(recursive: true));

      setUpAll(() async {
        projectDir = Directory.systemTemp.createTempSync('cli_test_');
        await createTestEnvironment(projectDir);

        protocolFile = File(
          p.join(projectDir.path, 'lib', 'src', 'generated', 'protocol.dart'),
        );
        protocolFile.createSync(recursive: true);
        protocolFile.writeAsStringSync('''
// $_protocolBackupMarker
class Protocol {
  factory Protocol() => Protocol._();
  Protocol._();
}
''');

        final modelFile = File(
          p.join(
            projectDir.path,
            'lib',
            'src',
            'protocol',
            'item.spy.yaml',
          ),
        );
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
class: Item
fields:
  name: String
''');

        config = _buildTestConfig(projectDir);
        analyzers = await Analyzers.create(config);
        await analyzers.update(
          config: config,
          affectedPaths: {modelFile.path},
        );
      });

      test(
        'then the previous protocol.dart is restored after generation',
        () async {
          await analyzers.performGenerate(
            config: config,
            requirements: const GenerationRequirements(
              generateModels: true,
              generateProtocol: false,
            ),
          );

          expect(
            protocolFile.readAsStringSync(),
            contains(_protocolBackupMarker),
          );
        },
      );
    },
  );
}

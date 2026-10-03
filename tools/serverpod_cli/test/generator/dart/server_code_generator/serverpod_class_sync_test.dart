import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/module_config_builder.dart';

const projectName = 'example_project';
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join('lib', 'src', 'generated', 'serverpod.dart');

  group(
    'Given the databaseSync experimental feature enabled and the sync module, '
    'when generating the Serverpod class,',
    () {
      late Map<String, String> codeMap;

      setUpAll(() {
        codeMap = generator.generateProtocolCode(
          protocolDefinition: const ProtocolDefinition(
            endpoints: [],
            models: [],
            futureCalls: [],
          ),
          config: GeneratorConfigBuilder()
              .withName(projectName)
              .withEnabledExperimentalFeatures([
                ExperimentalFeature.databaseSync,
              ])
              .withModules([
                ModuleConfigBuilder(
                  'serverpod_offline_sync',
                  'offline_sync',
                ).build(),
              ])
              .build(),
        );
      });

      test('then the offline sync server package is imported.', () {
        expect(
          codeMap[expectedFileName],
          contains(
            "import 'package:serverpod_offline_sync_server/"
            "serverpod_offline_sync_server.dart'",
          ),
        );
      });

      test(
        'then the offline sync interceptor wraps any provided interceptor.',
        () {
          expect(
            codeMap[expectedFileName],
            matches(
              RegExp(
                r'databaseInterceptor:\s*\(\s*session,\s*inner,?\s*\) => '
                r'_i[a-z0-9]+\.offlineSyncDatabaseInterceptor\(\s*session,\s*'
                r'databaseInterceptor\?\.call\(\s*session,\s*inner,?\s*\)\s*'
                r'\?\?\s*inner,?\s*\),',
              ),
            ),
          );
        },
      );

      test(
        'then offline sync is initialized with the generated sync tables.',
        () {
          expect(
            codeMap[expectedFileName],
            matches(
              RegExp(
                r'initializeOfflineSync\(syncTables: _i[a-z0-9]+\.syncTables\);',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'Given the databaseSync experimental feature enabled without the sync module, '
    'when generating the Serverpod class,',
    () {
      late Map<String, String> codeMap;

      setUpAll(() {
        codeMap = generator.generateProtocolCode(
          protocolDefinition: const ProtocolDefinition(
            endpoints: [],
            models: [],
            futureCalls: [],
          ),
          config: GeneratorConfigBuilder()
              .withName(projectName)
              .withEnabledExperimentalFeatures([
                ExperimentalFeature.databaseSync,
              ])
              .withAuthModule()
              .build(),
        );
      });

      test('then offline sync is not configured.', () {
        expect(codeMap[expectedFileName], isNot(contains('OfflineSync')));
        expect(codeMap[expectedFileName], isNot(contains('offlineSync')));
      });
    },
  );

  group(
    'Given the databaseSync experimental feature disabled with the sync module, '
    'when generating the Serverpod class,',
    () {
      late Map<String, String> codeMap;

      setUpAll(() {
        codeMap = generator.generateProtocolCode(
          protocolDefinition: const ProtocolDefinition(
            endpoints: [],
            models: [],
            futureCalls: [],
          ),
          config: GeneratorConfigBuilder().withName(projectName).withModules([
            ModuleConfigBuilder(
              'serverpod_offline_sync',
              'offline_sync',
            ).build(),
          ]).build(),
        );
      });

      test('then offline sync is not configured.', () {
        expect(codeMap[expectedFileName], isNot(contains('OfflineSync')));
        expect(codeMap[expectedFileName], isNot(contains('offlineSync')));
      });
    },
  );
}

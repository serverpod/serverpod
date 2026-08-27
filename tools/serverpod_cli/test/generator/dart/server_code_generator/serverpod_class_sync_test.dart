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

  const protocolDefinition = ProtocolDefinition(
    endpoints: [],
    models: [],
    futureCalls: [],
  );

  var syncModule = ModuleConfigBuilder(
    'serverpod_offline_sync',
    'offline_sync',
  ).build();

  group(
    'Given the databaseSync experimental feature enabled and the '
    'serverpod_offline_sync module when generating the Serverpod class',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: GeneratorConfigBuilder()
            .withName(projectName)
            .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
            .withModules([syncModule])
            .build(),
      );

      test('then the offline sync server package is imported.', () {
        expect(
          codeMap[expectedFileName],
          contains(
            "import 'package:serverpod_offline_sync_server/"
            "serverpod_offline_sync_server.dart'",
          ),
        );
      });

      test('then the crdt database interceptor is used by default.', () {
        expect(
          codeMap[expectedFileName],
          matches(
            RegExp(
              r'databaseInterceptor:\n'
              r'\s+databaseInterceptor \?\? _i[a-z0-9]+\.crdtDatabaseInterceptor,',
            ),
          ),
        );
      });

      test(
        'then the crdt sync is initialized with the protocol sync tables.',
        () {
          expect(
            codeMap[expectedFileName],
            matches(
              RegExp(
                r'initializeCrdtSync\(syncTables: _i[a-z0-9]+\.Protocol\.syncTables\);',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'Given the databaseSync experimental feature enabled without the '
    'serverpod_offline_sync module when generating the Serverpod class',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: GeneratorConfigBuilder()
            .withName(projectName)
            .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
            .withAuthModule()
            .build(),
      );

      test('then the crdt sync is not configured.', () {
        expect(codeMap[expectedFileName], isNot(contains('Crdt')));
        expect(codeMap[expectedFileName], isNot(contains('crdt')));
      });
    },
  );

  group(
    'Given the databaseSync experimental feature disabled with the '
    'serverpod_offline_sync module when generating the Serverpod class',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: GeneratorConfigBuilder().withName(projectName).withModules([
          syncModule,
        ]).build(),
      );

      test('then the crdt sync is not configured.', () {
        expect(codeMap[expectedFileName], isNot(contains('Crdt')));
        expect(codeMap[expectedFileName], isNot(contains('crdt')));
      });
    },
  );
}

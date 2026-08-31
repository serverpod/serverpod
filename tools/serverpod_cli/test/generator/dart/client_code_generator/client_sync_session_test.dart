import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/module_config_builder.dart';

const projectName = 'example_project';
const generator = DartClientCodeGenerator();

void main() {
  var expectedFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    'client.dart',
  );

  var syncModule = ModuleConfigBuilder(
    'serverpod_offline_sync',
    'offline_sync',
  ).build();

  var syncConfig = GeneratorConfigBuilder()
      .withName(projectName)
      .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
      .withModules([syncModule])
      .build();

  ProtocolDefinition protocolWithTable(ModelDatabaseDefinition database) =>
      ProtocolDefinition(
        endpoints: [],
        models: [
          ModelClassDefinitionBuilder()
              .withClassName('Person')
              .withFileName('person')
              .withTableName('person')
              .withDatabase(database)
              .build(),
        ],
        futureCalls: [],
      );

  group(
    'Given the databaseSync experimental feature enabled, the '
    'serverpod_offline_sync module and a sync table when generating the '
    'client file',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolWithTable(ModelDatabaseDefinition.sync),
        config: syncConfig,
      );

      test('then the client contains a createSyncSession method.', () {
        expect(
          codeMap[expectedFileName],
          matches(
            r'Future<_i[a-z0-9]+\.CrdtDatabaseSession> createSyncSession\(\n'
            r'    String path, \{\n'
            r'    bool runMigrations = true,\n'
            r'    bool isDebugMode = false,\n'
            r'    _i[a-z0-9]+\.UuidValue\? persistentUserId,\n'
            r'  \}\)',
          ),
        );
      });

      test(
        'then createSyncSession wraps createSession with the generated sync '
        'tables and the persistent user id.',
        () {
          expect(
            codeMap[expectedFileName],
            matches(
              r'final session = _i[a-z0-9]+\.CrdtDatabaseSession\.wraps\(\n'
              r'      await createSession\(\n'
              r'        path,\n'
              r'        runMigrations: runMigrations,\n'
              r'        isDebugMode: isDebugMode,\n'
              r'      \),\n'
              r'      syncTables: _i[a-z0-9]+\.syncTables,\n'
              r'      persistentUserId: persistentUserId,\n'
              r'    \);',
            ),
          );
        },
      );

      test('then createSyncSession initializes the database.', () {
        expect(
          codeMap[expectedFileName],
          contains('await session.db.initialize();\n    return session;'),
        );
      });
    },
  );

  group(
    'Given the databaseSync experimental feature enabled and the '
    'serverpod_offline_sync module but no client database tables when '
    'generating the client file',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolWithTable(ModelDatabaseDefinition.server),
        config: syncConfig,
      );

      test('then the client contains no createSyncSession method.', () {
        expect(codeMap[expectedFileName], isNot(contains('createSyncSession')));
      });
    },
  );

  group(
    'Given the databaseSync experimental feature enabled and a sync table '
    'without the serverpod_offline_sync module when generating the client '
    'file',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolWithTable(ModelDatabaseDefinition.sync),
        config: GeneratorConfigBuilder()
            .withName(projectName)
            .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
            .build(),
      );

      test('then the client contains no createSyncSession method.', () {
        expect(codeMap[expectedFileName], isNot(contains('createSyncSession')));
      });
    },
  );

  group(
    'Given the databaseSync experimental feature disabled with the '
    'serverpod_offline_sync module and a sync table when generating the '
    'client file',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolWithTable(ModelDatabaseDefinition.sync),
        config: GeneratorConfigBuilder().withName(projectName).withModules([
          syncModule,
        ]).build(),
      );

      test('then the client contains no createSyncSession method.', () {
        expect(codeMap[expectedFileName], isNot(contains('createSyncSession')));
      });
    },
  );
}

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/module_config_builder.dart';

const projectName = 'example_project';
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'sync_tables.dart',
  );
  var protocolFileName = path.join('lib', 'src', 'generated', 'protocol.dart');

  var syncModule = ModuleConfigBuilder(
    'serverpod_offline_sync',
    'offline_sync',
  ).build();

  var syncConfig = GeneratorConfigBuilder()
      .withName(projectName)
      .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
      .withModules([syncModule])
      .build();

  ModelClassDefinition syncModel(String className, String tableName) =>
      ModelClassDefinitionBuilder()
          .withClassName(className)
          .withFileName(tableName)
          .withTableName(tableName)
          .withDatabase(ModelDatabaseDefinition.sync)
          .build();

  group(
    'Given the databaseSync experimental feature enabled, the '
    'serverpod_offline_sync module and two sync tables when generating the '
    'protocol files',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: [
            syncModel('Person', 'person'),
            syncModel('Book', 'book'),
          ],
          futureCalls: [],
        ),
        config: syncConfig,
      );

      test('then sync_tables.dart lists the tables sorted by name.', () {
        expect(
          codeMap[expectedFileName],
          matches(
            RegExp(
              r'final List<_i[a-z0-9]+\.Table> syncTables = \[\n'
              r'  _i[a-z0-9]+\.Book\.t,\n'
              r'  _i[a-z0-9]+\.Person\.t,\n'
              r'\];',
            ),
          ),
        );
      });

      test('then the protocol file exports sync_tables.dart.', () {
        expect(
          codeMap[protocolFileName],
          contains("export 'sync_tables.dart';"),
        );
      });

      test('then the protocol file has no sync tables member.', () {
        expect(codeMap[protocolFileName], isNot(contains('getSyncTables')));
      });
    },
  );

  group(
    'Given the databaseSync experimental feature enabled and a module '
    'dependency with sync tables when generating the protocol files',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: [syncModel('Person', 'person')],
          futureCalls: [],
          moduleAliasesWithSyncTables: {'auth'},
        ),
        config: GeneratorConfigBuilder()
            .withName(projectName)
            .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
            .withModules([syncModule])
            .withAuthModule()
            .build(),
      );

      test('then sync_tables.dart spreads the module sync tables.', () {
        expect(
          codeMap[expectedFileName],
          matches(
            RegExp(
              r'final List<_i[a-z0-9]+\.Table> syncTables = \[\n'
              r'  _i[a-z0-9]+\.Person\.t,\n'
              r'  \.\.\._i[a-z0-9]+\.syncTables,\n'
              r'\];',
            ),
          ),
        );
      });
    },
  );

  group(
    'Given the databaseSync experimental feature enabled and a module '
    'dependency without sync tables when generating the protocol files',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: [syncModel('Person', 'person')],
          futureCalls: [],
        ),
        config: GeneratorConfigBuilder()
            .withName(projectName)
            .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
            .withModules([syncModule])
            .withAuthModule()
            .build(),
      );

      test('then sync_tables.dart does not spread the module.', () {
        expect(codeMap[expectedFileName], isNot(contains('...')));
      });
    },
  );

  group(
    'Given the databaseSync experimental feature enabled without the '
    'serverpod_offline_sync module when generating the protocol files',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: [syncModel('Person', 'person')],
          futureCalls: [],
        ),
        config: GeneratorConfigBuilder()
            .withName(projectName)
            .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
            .build(),
      );

      test('then no sync_tables.dart is generated.', () {
        expect(codeMap[expectedFileName], isNull);
        expect(codeMap[protocolFileName], isNot(contains('sync_tables')));
      });
    },
  );

  group(
    'Given the databaseSync experimental feature disabled with the '
    'serverpod_offline_sync module when generating the protocol files',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: [syncModel('Person', 'person')],
          futureCalls: [],
        ),
        config: GeneratorConfigBuilder().withName(projectName).withModules([
          syncModule,
        ]).build(),
      );

      test('then no sync_tables.dart is generated.', () {
        expect(codeMap[expectedFileName], isNull);
        expect(codeMap[protocolFileName], isNot(contains('sync_tables')));
      });
    },
  );
}

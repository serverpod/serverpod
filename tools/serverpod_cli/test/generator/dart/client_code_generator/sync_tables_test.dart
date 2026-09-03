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
  var clientProtocolPathParts = [
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
  ];
  var expectedFileName = path.joinAll([
    ...clientProtocolPathParts,
    'sync_tables.dart',
  ]);
  var protocolFileName = path.joinAll([
    ...clientProtocolPathParts,
    'protocol.dart',
  ]);

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
    'Given the databaseSync experimental feature enabled, the sync module and two sync tables, '
    'when generating the protocol files,',
    () {
      late var codeMap = generator.generateProtocolCode(
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
    },
  );

  group(
    'Given the databaseSync experimental feature enabled, the sync module and a shared package sync table, '
    'when generating the protocol files,',
    () {
      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: [
            syncModel('Person', 'person'),
            ModelClassDefinitionBuilder()
                .withClassName('SharedThing')
                .withFileName('shared_thing')
                .withTableName('shared_thing')
                .withDatabase(ModelDatabaseDefinition.sync)
                .withSharedPackageName('shared_pkg')
                .build(),
          ],
          futureCalls: [],
        ),
        config: GeneratorConfigBuilder()
            .withName(projectName)
            .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
            .withSharedModelsSourcePathsParts({
              'shared_pkg': ['packages', 'shared'],
            })
            .withModules([syncModule])
            .build(),
      );

      test('then sync_tables.dart references the shared table by package.', () {
        expect(
          codeMap[expectedFileName],
          contains("import 'package:shared_pkg/shared_pkg.dart'"),
        );
        expect(
          codeMap[expectedFileName],
          matches(RegExp(r'_i[a-z0-9]+\.SharedThing\.t,')),
        );
      });

      test(
        'then sync_tables.dart does not import the shared table by path.',
        () {
          expect(
            codeMap[expectedFileName],
            isNot(contains("import 'shared_thing.dart'")),
          );
        },
      );
    },
  );

  group(
    'Given the databaseSync experimental feature enabled and a module dependency with sync tables, '
    'when generating the protocol files,',
    () {
      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: [syncModel('Person', 'person')],
          futureCalls: [],
        ),
        config: GeneratorConfigBuilder()
            .withName(projectName)
            .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
            .withModules([
              syncModule,
              ModuleConfigBuilder(
                'serverpod_auth',
                'auth',
              ).withHasSyncTables(true).build(),
            ])
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
    'Given the databaseSync experimental feature enabled without the sync module, '
    'when generating the protocol files,',
    () {
      late var codeMap = generator.generateProtocolCode(
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
    'Given the databaseSync experimental feature disabled with the sync module, '
    'when generating the protocol files,',
    () {
      late var codeMap = generator.generateProtocolCode(
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

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';

const projectName = 'example_project';
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join('lib', 'src', 'generated', 'protocol.dart');

  var syncConfig = GeneratorConfigBuilder()
      .withName(projectName)
      .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
      .build();

  ModelClassDefinition syncModel(String className, String tableName) =>
      ModelClassDefinitionBuilder()
          .withClassName(className)
          .withFileName(tableName)
          .withTableName(tableName)
          .withDatabase(ModelDatabaseDefinition.sync)
          .build();

  group(
    'Given the databaseSync experimental feature enabled and two sync tables '
    'when generating the protocol file',
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

      test('then the syncTables getter lists the tables sorted by name.', () {
        expect(
          codeMap[expectedFileName],
          matches(
            RegExp(
              r'static List<_i[a-z0-9]+\.Table> get syncTables => \[\n'
              r'    _i[a-z0-9]+\.Book\.t,\n'
              r'    _i[a-z0-9]+\.Person\.t,\n'
              r'  \];',
            ),
          ),
        );
      });

      test('then getSyncTables returns the syncTables getter.', () {
        expect(
          codeMap[expectedFileName],
          matches(
            RegExp(
              r'@override\n'
              r'  List<_i[a-z0-9]+\.Table> getSyncTables\(\) => syncTables;',
            ),
          ),
        );
      });
    },
  );

  group(
    'Given the databaseSync experimental feature enabled and a table that is '
    'not synced when generating the protocol file',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: [
            ModelClassDefinitionBuilder()
                .withClassName('Person')
                .withFileName('person')
                .withTableName('person')
                .withDatabase(ModelDatabaseDefinition.all)
                .build(),
          ],
          futureCalls: [],
        ),
        config: syncConfig,
      );

      test('then the syncTables getter is empty.', () {
        expect(
          codeMap[expectedFileName],
          matches(
            RegExp(r'static List<_i[a-z0-9]+\.Table> get syncTables => \[\];'),
          ),
        );
      });
    },
  );

  group(
    'Given the databaseSync experimental feature enabled and a module '
    'dependency when generating the protocol file',
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
            .withAuthModule()
            .build(),
      );

      test('then the syncTables getter spreads the module sync tables.', () {
        expect(
          codeMap[expectedFileName],
          matches(
            RegExp(
              r'static List<_i[a-z0-9]+\.Table> get syncTables => \[\n'
              r'    _i[a-z0-9]+\.Person\.t,\n'
              r'    \.\.\._i[a-z0-9]+\.Protocol\(\)\.getSyncTables\(\),\n'
              r'  \];',
            ),
          ),
        );
      });
    },
  );

  group(
    'Given the databaseSync experimental feature disabled and a sync table '
    'when generating the protocol file',
    () {
      var codeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: [syncModel('Person', 'person')],
          futureCalls: [],
        ),
        config: GeneratorConfigBuilder().withName(projectName).build(),
      );

      test('then no syncTables getter is generated.', () {
        expect(codeMap[expectedFileName], isNot(contains('syncTables')));
      });
    },
  );
}

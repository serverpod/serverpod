import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/builders/module_config_builder.dart';

const _moduleName = 'example_module';
const _projectName = 'example_project';

void main() {
  group('Given a module protocol when generating code', () {
    late final moduleConfig = GeneratorConfigBuilder()
        .withName(_moduleName)
        .withPackageType(PackageType.module)
        .build();

    const protocolDefinition = ProtocolDefinition(
      endpoints: [],
      models: [],
      futureCalls: [],
    );

    late final codeMap = const DartServerCodeGenerator().generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: moduleConfig,
    );

    late final protocolSource =
        codeMap[path.join(
          'lib',
          'src',
          'generated',
          'protocol.dart',
        )]!;

    test('then it defines a host protocol registry', () {
      expect(protocolSource, contains('_hostProtocols'));
    });

    test('then it defines registerHostProtocol', () {
      expect(
        protocolSource,
        contains('void registerHostProtocol('),
      );
    });

    test('then it assigns the protocol to the registry', () {
      expect(
        protocolSource,
        contains('_hostProtocols.add(protocol)'),
      );
    });

    test('then it overrides dynamicFieldToJson', () {
      expect(
        protocolSource,
        contains('''
  @override
  Object? dynamicFieldToJson('''),
      );
    });

    test(
      'then it overrides deserializeDynamicFieldValue',
      () {
        expect(
          protocolSource,
          contains('''
  @override
  dynamic deserializeDynamicFieldValue('''),
        );
      },
    );

    test(
      'then getClassNameForObject does not delegate to registered hosts',
      () {
        expect(
          protocolSource,
          contains('factory Protocol() => _instance;'),
        );
      },
    );
  });

  group(
    'Given a project protocol with a module dependency when generating code',
    () {
      late final projectConfig = GeneratorConfigBuilder()
          .withName(_projectName)
          .withModules([
            ModuleConfigBuilder(_moduleName).build(),
          ])
          .build();

      const protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: [],
        futureCalls: [],
      );

      late final codeMap = const DartServerCodeGenerator().generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: projectConfig,
      );

      late final protocolSource =
          codeMap[path.join(
            'lib',
            'src',
            'generated',
            'protocol.dart',
          )]!;

      test(
        'then Protocol() registers the project as a module host on the singleton instance',
        () {
          expect(
            protocolSource,
            contains(
              'static final Protocol _instance = Protocol._().._registerHostProtocols();',
            ),
          );
          expect(
            protocolSource,
            contains("registerHostProtocol('$_projectName', this)"),
          );
        },
      );

      test('then it does not override dynamicFieldToJson', () {
        expect(protocolSource, isNot(contains('dynamicFieldToJson')));
      });

      test('then it does not override deserializeDynamicFieldValue', () {
        expect(protocolSource, isNot(contains('deserializeDynamicFieldValue')));
      });
    },
  );
  group(
    'Given a module protocol with a shared package, '
    'when generating code,',
    () {
      late String serverProtocolSource;
      late String clientProtocolSource;

      setUpAll(() {
        final moduleConfig = GeneratorConfigBuilder()
            .withName(_moduleName)
            .withPackageType(PackageType.module)
            .withSharedModelsSourcePathsParts({
              'example_shared': ['..', 'example_shared'],
            })
            .build();

        final protocolDefinition = ProtocolDefinition(
          endpoints: [],
          models: [
            ModelClassDefinitionBuilder()
                .withClassName('SharedTable')
                .withTableName('shared_table')
                .withDatabase(ModelDatabaseDefinition.all)
                .withSharedPackageName('example_shared')
                .build(),
          ],
          futureCalls: [],
        );

        serverProtocolSource = const DartServerCodeGenerator()
            .generateProtocolCode(
              protocolDefinition: protocolDefinition,
              config: moduleConfig,
            )[path.join('lib', 'src', 'generated', 'protocol.dart')]!;
        clientProtocolSource =
            const DartClientCodeGenerator().generateProtocolCode(
              protocolDefinition: protocolDefinition,
              config: moduleConfig,
            )[path.join(
              '..',
              '${_moduleName}_client',
              'lib',
              'src',
              'protocol',
              'protocol.dart',
            )]!;
      });

      test(
        'then the server and client protocols re-export the shared package models.',
        () {
          const sharedPackageExport =
              "export 'package:example_shared/example_shared.dart' hide Protocol;";

          expect(serverProtocolSource, contains(sharedPackageExport));
          expect(clientProtocolSource, contains(sharedPackageExport));
        },
      );

      test(
        'then the server and client protocols forward shared model class names without a shared package prefix.',
        () {
          for (final protocolSource in [
            serverProtocolSource,
            clientProtocolSource,
          ]) {
            expect(
              protocolSource,
              contains('if (className != null) return className;'),
            );
            expect(
              protocolSource,
              isNot(contains("'example_shared.\$className'")),
            );
          }
        },
      );

      test(
        'then the server and client protocols deserialize unprefixed shared model class names.',
        () {
          for (final protocolSource in [
            serverProtocolSource,
            clientProtocolSource,
          ]) {
            expect(
              protocolSource,
              contains('Protocol().deserializeByClassName(data)'),
            );
            expect(
              protocolSource,
              isNot(contains("dataClassName.startsWith('example_shared.')")),
            );
          }
        },
      );

      test(
        'then the client protocol forwards the shared table metadata.',
        () {
          expect(
            clientProtocolSource,
            matches(
              RegExp(
                r'class Protocol extends _i\d+\.DatabaseSerializationManager',
              ),
            ),
          );
          expect(clientProtocolSource, contains('getTargetTableDefinitions'));
        },
      );

      test(
        'then the server and client protocols forward host registrations to '
        'the shared package.',
        () {
          for (final protocolSource in [
            serverProtocolSource,
            clientProtocolSource,
          ]) {
            expect(
              protocolSource,
              contains('.registerHostProtocol(projectName, protocol);'),
            );
          }
        },
      );
    },
  );
}

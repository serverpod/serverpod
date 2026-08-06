import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';

const _sharedPackageName = 'example_shared';
const _projectName = 'example_project';

void main() {
  group('Given a shared package protocol when generating code', () {
    late final sharedConfig = GeneratorConfigBuilder()
        .withName(_projectName)
        .withSharedModelsSourcePathsParts({
          _sharedPackageName: ['..', _sharedPackageName],
        })
        .build();

    late final protocolDefinition = ProtocolDefinition(
      endpoints: [],
      models: [
        ModelClassDefinitionBuilder()
            .withClassName('Example')
            .withSharedPackageName(_sharedPackageName)
            .build(),
      ],
      futureCalls: [],
    );

    late final codeMap = const DartSharedCodeGenerator().generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: sharedConfig,
    );

    late final protocolSource =
        codeMap[path.join(
          '..',
          _sharedPackageName,
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
    'Given a project protocol with a shared package when generating code',
    () {
      late final projectConfig = GeneratorConfigBuilder()
          .withName(_projectName)
          .withSharedModelsSourcePathsParts({
            _sharedPackageName: ['..', _sharedPackageName],
          })
          .build();

      const protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: [],
        futureCalls: [],
      );

      late final codeMap = const DartClientCodeGenerator().generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: projectConfig,
      );

      late final protocolSource =
          codeMap[path.join(
            '..',
            '${_projectName}_client',
            'lib',
            'src',
            'protocol',
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
}

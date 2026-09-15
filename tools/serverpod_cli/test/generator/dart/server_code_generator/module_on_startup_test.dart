import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/module_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

final expectedFileName = path.join(
  'lib',
  'src',
  'generated',
  'endpoints.dart',
);

void main() {
  group(
    'Given protocol without Module and without nested modules when generating',
    () {
      late String? endpointsFile;

      setUpAll(() {
        var protocolDefinition = const ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [],
        );

        var codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );
        endpointsFile = codeMap[expectedFileName];
      });

      test('then onStartup override is omitted.', () {
        expect(endpointsFile, isNot(contains('onStartup')));
      });
    },
  );

  group('Given protocol with a local Module when generating', () {
    late String? endpointsFile;

    setUpAll(() {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: [],
        futureCalls: [],
        module: ModuleDefinition(
          className: 'MyModule',
          filePath: path.join(
            'lib',
            'src',
            'my_module.dart',
          ),
          isAbstract: false,
        ),
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );
      endpointsFile = codeMap[expectedFileName];
    });

    test('then onStartup calls the local Module.', () {
      expect(endpointsFile, contains('onStartup'));
      expect(
        endpointsFile,
        contains('.MyModule().onStartup(session);'),
      );
    });
  });

  group(
    'Given host with nested modules and no local Module when generating',
    () {
      late String? endpointsFile;

      setUpAll(() {
        var hostConfig = GeneratorConfigBuilder()
            .withName(projectName)
            .withModules([
              ModuleConfigBuilder('zeta_mod').build(),
              ModuleConfigBuilder('alpha_mod').build(),
            ])
            .build();

        var protocolDefinition = const ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [],
        );

        var codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: hostConfig,
        );
        endpointsFile = codeMap[expectedFileName];
      });

      test('then onStartup fans out sorted by module name.', () {
        expect(endpointsFile, contains('onStartup'));
        final alphaIndex = endpointsFile!.indexOf(
          "modules['alpha_mod']!.onStartup(session)",
        );
        final zetaIndex = endpointsFile!.indexOf(
          "modules['zeta_mod']!.onStartup(session)",
        );
        expect(alphaIndex, greaterThan(-1));
        expect(zetaIndex, greaterThan(-1));
        expect(alphaIndex, lessThan(zetaIndex));
      });

      test('then no local Module instantiation is generated.', () {
        expect(endpointsFile, isNot(contains('Module().onStartup')));
      });
    },
  );

  group(
    'Given module package with local Module and nested modules when generating',
    () {
      late String? endpointsFile;

      setUpAll(() {
        var moduleConfig = GeneratorConfigBuilder()
            .withName('auth_idp')
            .withPackageType(PackageType.module)
            .withModules([ModuleConfigBuilder('auth_core').build()])
            .build();

        var protocolDefinition = ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [],
          module: ModuleDefinition(
            className: 'AuthIdpModule',
            filePath: path.join('lib', 'src', 'auth_idp_module.dart'),
            isAbstract: false,
          ),
        );

        var codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: moduleConfig,
        );
        endpointsFile = codeMap[expectedFileName];
      });

      test('then onStartup calls local Module only (no nested fan-out).', () {
        expect(
          endpointsFile,
          contains('.AuthIdpModule().onStartup(session);'),
        );
        expect(
          endpointsFile,
          isNot(contains("modules['auth_core']!.onStartup")),
        );
      });
    },
  );

  group(
    'Given host with local Module and nested modules when generating',
    () {
      late String? endpointsFile;

      setUpAll(() {
        var hostConfig = GeneratorConfigBuilder()
            .withName(projectName)
            .withModules([ModuleConfigBuilder('dep_mod').build()])
            .build();

        var protocolDefinition = ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [],
          module: ModuleDefinition(
            className: 'HostModule',
            filePath: path.join('lib', 'src', 'host_module.dart'),
            isAbstract: false,
          ),
        );

        var codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: hostConfig,
        );
        endpointsFile = codeMap[expectedFileName];
      });

      test('then local Module runs before nested fan-out.', () {
        final localIndex = endpointsFile!.indexOf(
          '.HostModule().onStartup(session)',
        );
        final nestedIndex = endpointsFile!.indexOf(
          "modules['dep_mod']!.onStartup(session)",
        );
        expect(localIndex, greaterThan(-1));
        expect(nestedIndex, greaterThan(-1));
        expect(localIndex, lessThan(nestedIndex));
      });
    },
  );
}

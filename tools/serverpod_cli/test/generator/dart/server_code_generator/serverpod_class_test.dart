import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
const generator = DartServerCodeGenerator();

const protocolDefinition = ProtocolDefinition(
  endpoints: [],
  models: [],
  futureCalls: [],
);

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'serverpod.dart',
  );

  group(
    'Given a server package when generating protocol code',
    () {
      late Map<String, String> codeMap;
      late String? serverpodFile;
      setUpAll(() {
        var config = GeneratorConfigBuilder().withName(projectName).build();

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );
        serverpodFile = codeMap[expectedFileName];
      });

      test('then the serverpod file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      group('then the serverpod file', () {
        test('declares a Serverpod class extending the framework class.', () {
          expect(
            serverpodFile,
            matches(r'class Serverpod extends _i\d+\.Serverpod'),
          );
        });

        test('re-exports the framework hiding its Serverpod class.', () {
          expect(
            serverpodFile,
            contains(
              "export 'package:serverpod/serverpod.dart' hide Serverpod;",
            ),
          );
        });

        test(
          'wires the generated Protocol and Endpoints in the super call.',
          () {
            expect(serverpodFile, matches(r'_i\d+\.Protocol\(\)'));
            expect(serverpodFile, matches(r'_i\d+\.Endpoints\(\)'));
          },
        );
      });
    },
  );

  test(
    'Given a module package when generating protocol code then no serverpod '
    'file is created.',
    () {
      var config = GeneratorConfigBuilder()
          .withName(projectName)
          .withPackageType(PackageType.module)
          .build();

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(codeMap.keys, isNot(contains(expectedFileName)));
    },
  );
}

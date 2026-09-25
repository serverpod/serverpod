import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';

const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'integration_test',
    'test_tools',
    'serverpod_test_tools.dart',
  );

  var protocolDefinition = const ProtocolDefinition(
    endpoints: [],
    models: [],
    futureCalls: [],
  );

  group(
    'Given a server package named "server" without the _server suffix when '
    'generating test tools file',
    () {
      // `withServerPackage` must be called after `withName`, since `withName`
      // also sets the server package to '<name>_server'. With the builder's
      // default name, a reconstructed '<name>_server' import would not
      // contain 'package:server_server' and the assertions below would pass
      // without exercising the renamed-package scenario.
      var config = GeneratorConfigBuilder()
          .withName('server')
          .withServerPackage('server')
          .withRelativeServerTestToolsPathParts(
            ['integration_test', 'test_tools'],
          )
          .build();

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      late var testToolsFile = codeMap[expectedFileName];

      test('then the config models the renamed package.', () {
        expect(config.name, 'server');
        expect(config.serverPackage, 'server');
      });

      test('then import path towards project protocol is correct.', () {
        expect(
          testToolsFile,
          contains("import 'package:server/src/generated/protocol.dart';"),
        );
      });

      test('then import path towards project endpoints is correct.', () {
        expect(
          testToolsFile,
          contains("import 'package:server/src/generated/endpoints.dart';"),
        );
      });

      test(
        'then no import reconstructs the package name with a _server suffix.',
        () {
          expect(testToolsFile, isNot(contains('package:server_server')));
        },
      );
    },
  );

  group(
    'Given a server package with a generic name without the _server suffix '
    'when generating test tools file',
    () {
      var config = GeneratorConfigBuilder()
          .withName('my_backend')
          .withServerPackage('my_backend')
          .withRelativeServerTestToolsPathParts(
            ['integration_test', 'test_tools'],
          )
          .build();

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      late var testToolsFile = codeMap[expectedFileName];

      test('then the config models the renamed package.', () {
        expect(config.name, 'my_backend');
        expect(config.serverPackage, 'my_backend');
      });

      test('then import path towards project protocol is correct.', () {
        expect(
          testToolsFile,
          contains("import 'package:my_backend/src/generated/protocol.dart';"),
        );
      });

      test('then import path towards project endpoints is correct.', () {
        expect(
          testToolsFile,
          contains(
            "import 'package:my_backend/src/generated/endpoints.dart';",
          ),
        );
      });

      test(
        'then no import reconstructs the package name with a _server suffix.',
        () {
          expect(testToolsFile, isNot(contains('package:my_backend_server')));
        },
      );
    },
  );
}

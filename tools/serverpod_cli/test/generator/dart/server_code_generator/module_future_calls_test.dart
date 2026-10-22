import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/future_call_definition_builder.dart';
import '../../../test_util/builders/future_call_method_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';

void main() {
  group('Given a module defining a future call,', () {
    late GeneratorConfig config;
    late ProtocolDefinition protocol;

    setUpAll(() {
      config = GeneratorConfigBuilder()
          .withName('my_module')
          .withPackageType(PackageType.module)
          .build();
      protocol = ProtocolDefinition(
        endpoints: [],
        models: [],
        futureCalls: [
          FutureCallDefinitionBuilder().withName('cleanup').withMethods([
            FutureCallMethodDefinitionBuilder()
                .withName('run')
                .buildMethodCallDefinition(),
          ]).build(),
        ],
      );
    });

    group('when generating its server code,', () {
      late String futureCalls;
      late String endpoints;

      setUpAll(() {
        final files = const DartServerCodeGenerator().generateProtocolCode(
          protocolDefinition: protocol,
          config: config,
        );
        futureCalls =
            files[path.join(
              'lib',
              'src',
              'generated',
              'future_calls.dart',
            )]!;
        endpoints =
            files[path.join(
              'lib',
              'src',
              'generated',
              'endpoints.dart',
            )]!;
      });

      test('then the getter and its extension are module-specific.', () {
        expect(
          futureCalls,
          contains('extension MyModuleFutureCallsGetter on '),
        );
        expect(
          futureCalls,
          contains('FutureCalls get myModuleFutureCalls => FutureCalls();'),
        );
        expect(futureCalls, isNot(contains('get futureCalls =>')));
      });

      test('then the module exports its own future calls extension.', () {
        expect(
          endpoints,
          contains(
            "export 'future_calls.dart' show MyModuleFutureCallsGetter;",
          ),
        );
      });
    });
  });
}

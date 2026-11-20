import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as test_module;
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given the project endpoints which hook up the serverpod_auth module before the serverpod_test_module module,',
    () {
      late Protocol protocol;
      late Endpoints endpoints;
      late ServerpodConfig config;

      setUpAll(() {
        protocol = Protocol();
        endpoints = Endpoints();
        config = ServerpodConfig(
          apiServer: ServerConfig(
            port: 0,
            publicScheme: 'http',
            publicHost: 'localhost',
            publicPort: 0,
          ),
        );
      });

      group('when initializing them,', () {
        late Serverpod pod;
        late List<String> modulesHookedUpWhenInitialized;

        setUpAll(() {
          pod = Serverpod([], protocol, endpoints, config: config);

          final testModule = pod.endpoints.modules['serverpod_test_module']!;
          final moduleEndpoint =
              testModule.connectors['module']!.endpoint
                  as test_module.ModuleEndpoint;
          modulesHookedUpWhenInitialized = moduleEndpoint
              .modulesHookedUpWhenInitialized
              .toList();
        });

        tearDownAll(() async {
          await pod.shutdown(exitProcess: false);
        });

        test(
          'then the serverpod_test_module endpoints are initialized with the serverpod_auth module already hooked up.',
          () {
            expect(modulesHookedUpWhenInitialized, ['serverpod_auth']);
          },
        );
      });
    },
  );
}

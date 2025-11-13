import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:system_resources/system_resources.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Serverpod server instance', () {
    late Serverpod server;

    setUp(() {
      server = IntegrationTestServer.create();
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
    });

    // This test had to be coupled to the underlying implementation of the
    // HealthCheckManager (depending on `SystemResources`) due to it being the
    // cause for server start issued on Windows.
    test(
      'when starting Serverpod on any platform, then no error occurs.',
      () async {
        await server.start();

        // Await singleton `_libsysres` that causes `ProcessException` zoned
        // exception in Windows due to missing "uname" command.
        try {
          await SystemResources.init();
        } catch (e) {
          // If the init has been called from the `start` method, the exception
          // will not take place here and will throw. Otherwise, if the server
          // starts with success, the exception will happen here and be ignored.
        }
      },
      timeout: Timeout(Duration(seconds: 10)),
    );

    test(
      'when starting Serverpod multiple times, then no error occurs.',
      () async {
        await server.start();
        await server.shutdown(exitProcess: false);
        await server.start();
      },
      timeout: Timeout(Duration(seconds: 10)),
    );
  });
}

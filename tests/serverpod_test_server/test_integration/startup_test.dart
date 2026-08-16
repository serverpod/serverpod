import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Serverpod server instance', () {
    late Serverpod server;

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.ensureDatabase();
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
    });

    test(
      'when starting Serverpod on any platform, then no error occurs.',
      () async {
        await server.start();
      },
      // First-use provisioning in setUp: embedded-PG launch + create + migrate.
      timeout: Timeout(Duration(seconds: 120)),
    );

    test(
      'when starting Serverpod multiple times, then no error occurs.',
      () async {
        await server.start();
        await server.shutdown(exitProcess: false);
        await server.start();
      },
      // First-use provisioning in setUp: embedded-PG launch + create + migrate.
      timeout: Timeout(Duration(seconds: 120)),
    );
  });
}

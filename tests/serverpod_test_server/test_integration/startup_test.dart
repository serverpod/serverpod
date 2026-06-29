import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
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

    test(
      'when starting Serverpod on any platform, then no error occurs.',
      () async {
        await IntegrationTestServer.start(server);
      },
      timeout: Timeout(Duration(seconds: 10)),
    );

    test(
      'when starting Serverpod multiple times, then no error occurs.',
      () async {
        await IntegrationTestServer.start(server);
        await server.shutdown(exitProcess: false);
        await IntegrationTestServer.start(server);
      },
      timeout: Timeout(Duration(seconds: 10)),
    );
  });
}

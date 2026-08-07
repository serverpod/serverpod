import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a Serverpod host with a module Module hook', () {
    late Serverpod server;

    setUp(() async {
      TestModuleModule.reset();
      server = IntegrationTestServer.create();
      await server.ensureDatabase();
    });

    tearDown(() async {
      TestModuleModule.reset();
      await server.shutdown(exitProcess: false);
    });

    test(
      'when starting Serverpod, then the module onStartup hook runs once.',
      () async {
        await server.start();

        expect(TestModuleModule.startupCount, 1);
      },
      timeout: Timeout(Duration(seconds: 120)),
    );

    test(
      'when starting Serverpod twice, then the module onStartup hook runs again.',
      () async {
        await server.start();
        await server.shutdown(exitProcess: false);
        await server.start();

        expect(TestModuleModule.startupCount, 2);
      },
      timeout: Timeout(Duration(seconds: 120)),
    );

    test(
      'when module onStartup throws, then start fails.',
      () async {
        TestModuleModule.throwOnStartup = StateError('module startup failed');

        await expectLater(
          server.start(runInGuardedZone: false),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              'module startup failed',
            ),
          ),
        );
        expect(TestModuleModule.startupCount, 0);
      },
      timeout: Timeout(Duration(seconds: 120)),
    );
  });
}

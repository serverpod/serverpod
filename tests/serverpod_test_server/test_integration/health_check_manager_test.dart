import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart' as e;
import 'package:serverpod_test_server/src/generated/protocol.dart' as p;
import 'package:test/test.dart';

void main() {
  group(
    'Given a running server',
    () {
      var client = Client('http://localhost:8065/');
      late Serverpod server;
      late Session session;

      setUp(() async {
        server = Serverpod(
          ['-m', 'production'],
          p.Protocol(),
          e.Endpoints(),
          config: ServerpodConfig(
            runMode: ServerpodRunMode.production,
            apiServer: ServerConfig(
              port: 8065,
              publicScheme: 'http',
              publicHost: 'localhost',
              publicPort: 8065,
            ),
            database: DatabaseConfig(
              host: 'postgres',
              port: 5432,
              user: 'postgres',
              password: 'password',
              name: 'serverpod_test',
            ),
            healthCheckInterval: const Duration(seconds: 1),
          ),
        );

        await server.start();
        session = await server.createSession();

        await server.clearHealthChecks(session);
      });

      tearDown(() async {
        await server.clearHealthChecks(session);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test('when server starts then no health checks are recorded.', () async {
        final healthChecks = await server.countHealthChecks(session);
        expect(healthChecks, equals(0));
      });

      test(
        'while no endpoint calls are made then no health checks are recorded.',
        () async {
          await Future.delayed(const Duration(seconds: 3));
          final healthChecks = await server.countHealthChecks(session);
          expect(healthChecks, equals(0));
        },
      );

      test(
        'when an endpoint call is made then a health check is recorded.',
        () async {
          await client.listParameters.returnStringList(['a', 'b', 'c']);
          await Future.delayed(const Duration(seconds: 4));
          final healthChecks = await server.countHealthChecks(session);
          expect(healthChecks, greaterThanOrEqualTo(1));
        },
      );

      test(
        'when a streaming endpoint is called then a health check is recorded.',
        () async {
          await client.logging.streamEmpty(Stream.fromIterable([1, 2, 3]));
          await Future.delayed(const Duration(seconds: 4));
          final healthChecks = await server.countHealthChecks(session);
          expect(healthChecks, greaterThanOrEqualTo(1));
        },
      );
    },
  );
}

extension on Serverpod {
  Future<int> countHealthChecks(Session session) async {
    return ServerHealthConnectionInfo.db.count(
      session,
      where: (t) => t.serverId.equals(serverId),
    );
  }

  Future<void> clearHealthChecks(Session session) async {
    await ServerHealthConnectionInfo.db.deleteWhere(
      session,
      where: (t) => t.serverId.equals(serverId),
    );
  }
}

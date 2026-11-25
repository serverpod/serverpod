import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/health_check_manager.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given a running server',
    () {
      late Client client;
      late Serverpod server;
      late Session session;

      setUp(() async {
        server = IntegrationTestServer.create(
          config: ServerpodConfig(
            runMode: ServerpodRunMode.production,
            serverId: Uuid().v4(),
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

        // Provision this suite's database before clearing health checks, a
        // pre-start write that would otherwise hit a not-yet-created database.
        await server.ensureDatabase();
        session = await server.createSession();
        await server.clearHealthChecks(session);
        await server.start();
        client = Client(server.apiUrl);

        // Await the first health check to be performed.
        await Future.delayed(const Duration(seconds: 3));
      });

      tearDown(() async {
        await server.clearHealthChecks(session);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when server starts then one health check is recorded.',
        () async {
          final healthChecks = await server.countHealthChecks(session);
          expect(healthChecks, equals(1));
        },
        skip: 'Test is flaky on the CI. Should be fixed with #4465.',
      );

      test(
        'while no endpoint calls are made then only the first health check exists.',
        () async {
          await Future.delayed(const Duration(seconds: 3));
          final healthChecks = await server.countHealthChecks(session);
          expect(healthChecks, equals(1));
        },
        skip: 'Test is flaky on the CI. Should be fixed with #4465.',
      );

      test(
        'when an endpoint call is made after the first health check then another health check is recorded.',
        () async {
          await client.listParameters.returnStringList(['a', 'b', 'c']);
          await Future.delayed(const Duration(seconds: 3));
          final healthChecks = await server.countHealthChecks(session);
          expect(healthChecks, equals(2));
        },
        skip: 'Test is flaky on the CI. Should be fixed with #4465.',
      );

      test(
        'when a streaming endpoint is called after the first health check then another health check is recorded.',
        () async {
          await client.logging.streamEmpty(Stream.fromIterable([1, 2, 3]));
          await Future.delayed(const Duration(seconds: 3));
          final healthChecks = await server.countHealthChecks(session);
          expect(healthChecks, equals(2));
        },
        skip: 'Test is flaky on the CI. Should be fixed with #4465.',
      );
    },
  );

  test(
    'Given an existing health metric when a check contains the same metric '
    'then it preserves the original and records the remaining results',
    () async {
      final handlerCalled = Completer<void>();
      late DateTime timestamp;
      final server = IntegrationTestServer.create(
        config: ServerpodConfig(
          serverId: Uuid().v4(),
          apiServer: ServerConfig(
            port: 0,
            publicScheme: 'http',
            publicHost: 'localhost',
            publicPort: 0,
          ),
          database: DatabaseConfig(
            host: 'postgres',
            port: 5432,
            user: 'postgres',
            password: 'password',
            name: 'serverpod_test',
          ),
          healthCheckInterval: Duration.zero,
        ),
        healthCheckHandler: (pod, time) async {
          timestamp = time;
          final metric = ServerHealthMetric(
            serverId: pod.serverId,
            name: 'custom_existing',
            timestamp: time,
            value: 1,
            isHealthy: true,
            granularity: 1,
          );
          final session = await pod.createSession();
          try {
            await ServerHealthMetric.db.insertRow(session, metric);
          } finally {
            await session.close();
          }
          handlerCalled.complete();
          return [
            metric.copyWith(id: null, value: 2),
            metric.copyWith(id: null, name: 'custom_new', value: 3),
          ];
        },
      );
      addTearDown(() => server.shutdown(exitProcess: false));
      await server.startWithDatabase();
      final session = await server.createSession();
      addTearDown(session.close);
      final manager = HealthCheckManager(
        server,
        () {},
        interval: const Duration(seconds: 1),
      );
      addTearDown(manager.stop);

      await manager.start();
      await handlerCalled.future;
      // Await the pending check instead of relying on a fixed delay.
      await manager.stop();

      final metrics = await ServerHealthMetric.db.find(
        session,
        where: (t) => t.serverId.equals(server.serverId),
      );
      expect(
        metrics.where((m) => m.name == 'custom_existing').map((m) => m.value),
        [1],
      );
      expect(
        metrics.where((m) => m.name == 'custom_new').map((m) => m.value),
        [3],
      );
      final connections = await ServerHealthConnectionInfo.db.find(
        session,
        where: (t) => t.serverId.equals(server.serverId),
      );
      expect(connections, hasLength(1));
      expect(connections.single.timestamp, timestamp);
    },
    skip: Platform.isWindows ? 'Health checks are disabled on Windows.' : false,
  );

  group('Given a running server with health check interval set to zero', () {
    late Serverpod server;
    late Session session;

    setUp(() async {
      server = IntegrationTestServer.create(
        config: ServerpodConfig(
          runMode: ServerpodRunMode.production,
          serverId: Uuid().v4(),
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
          healthCheckInterval: Duration.zero,
        ),
      );

      // Provision this suite's database before clearing health checks, a
      // pre-start write that would otherwise hit a not-yet-created database.
      await server.ensureDatabase();
      session = await server.createSession();
      await server.clearHealthChecks(session);
      await server.start();

      // Await the first health check to be performed.
      await Future.delayed(const Duration(seconds: 3));
    });

    tearDown(() async {
      await server.clearHealthChecks(session);
      await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
      'when server starts then no health check is recorded.',
      () async {
        await Future.delayed(const Duration(seconds: 3));
        final healthChecks = await server.countHealthChecks(session);
        expect(healthChecks, equals(0));
      },
    );
  });
}

extension on Serverpod {
  Future<int> countHealthChecks(Session session) async {
    return ServerHealthConnectionInfo.db.count(
      session,
      where: (t) => t.serverId.equals(serverId),
    );
  }

  Future<void> clearHealthChecks(Session session) async {
    await ServerHealthMetric.db.deleteWhere(
      session,
      where: (t) => t.serverId.equals(serverId),
    );

    await ServerHealthConnectionInfo.db.deleteWhere(
      session,
      where: (t) => t.serverId.equals(serverId),
    );
  }
}

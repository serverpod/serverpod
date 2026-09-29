import 'dart:async';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

const _interval = Duration(seconds: 1);
const _deadline = Duration(seconds: 10);
const _pollInterval = Duration(milliseconds: 50);
// Span two complete scheduling intervals, regardless of the initial phase.
const _idleWindow = Duration(seconds: 3);

typedef _Snapshot = ({int count, DateTime? lastOperation});

void main() {
  group(
    'Given a running server with scheduled health checks',
    () {
      late _Fixture fixture;

      setUp(() async {
        fixture = await _Fixture.start(_interval);
        await fixture.waitForCheckAfter(0);
      });

      test('startup records a health check and then becomes idle', () async {
        final snapshot = await fixture.waitUntilIdle();
        expect(snapshot.count, greaterThan(0));
      });

      test(
        'idle checks and observer reads do not access the server database',
        () async {
          final idle = await fixture.waitUntilIdle();
          await fixture.expectIdle(idle);
        },
      );

      test(
        'an ordinary endpoint call records a new check and returns to idle',
        () async {
          final before = await fixture.waitUntilIdle();
          expect(
            await fixture.client.listParameters
                .returnStringList(['a', 'b', 'c'])
                .timeout(_deadline),
            ['a', 'b', 'c'],
          );
          await fixture.waitForClosedSession(
            'listParameters',
            'returnStringList',
          );
          await fixture.waitForCheckAfter(before.count);
          final after = await fixture.waitUntilIdle();
          expect(after.count, greaterThan(before.count));
          await fixture.expectIdle(after);
        },
      );

      test(
        'a completed stream records a new check and returns to idle',
        () async {
          final before = await fixture.waitUntilIdle();
          expect(
            await fixture.client.logging
                .streamEmpty(Stream.fromIterable([1, 2, 3]))
                .toList()
                .timeout(_deadline),
            [1, 2, 3],
          );
          // Client stream completion alone does not prove that the server has
          // finalized the session and persisted its activity.
          await fixture.waitForClosedSession('logging', 'streamEmpty');
          await fixture.waitForCheckAfter(before.count);
          final after = await fixture.waitUntilIdle();
          expect(after.count, greaterThan(before.count));
          await fixture.expectIdle(after);
        },
      );
    },
    onPlatform: {
      'windows': Skip(
        'HealthCheckManager does not schedule checks on Windows.',
      ),
    },
  );

  test('a zero health check interval records no checks', () async {
    final fixture = await _Fixture.start(Duration.zero);
    final before = await fixture.waitUntilIdle();
    expect(before.count, 0);
    await fixture.expectIdle(before);
  });
}

class _Fixture {
  final Serverpod server;
  final Session observer;
  final Client client;

  _Fixture(this.server, this.observer, this.client);

  static Future<_Fixture> start(Duration interval) async {
    final config = ServerpodConfig(
      runMode: ServerpodRunMode.production,
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
      healthCheckInterval: interval,
      futureCallExecutionEnabled: false,
      sessionLogs: SessionLogConfig(
        persistentEnabled: true,
        consoleEnabled: false,
        cleanupInterval: null,
        retentionPeriod: null,
        retentionCount: null,
      ),
    );

    // A separate pool is essential: even SELECTs through the tested server
    // update its lastDatabaseOperationTime and wake the next health check.
    // Construct the observer first so Serverpod.instance remains the server
    // under test. It never starts listeners or background services.
    final observerPod = IntegrationTestServer.create(
      config: config.copyWith(
        serverId: Uuid().v4(),
        healthCheckInterval: Duration.zero,
        sessionLogs: config.sessionLogs.copyWith(persistentEnabled: false),
      ),
    );
    addTearDown(
      () => observerPod.shutdown(exitProcess: false).timeout(_deadline),
    );
    await observerPod.ensureDatabase();
    final observer = await observerPod.createSession(enableLogging: false);
    addTearDown(() => observer.close().timeout(_deadline));

    final server = IntegrationTestServer.create(config: config);
    addTearDown(() => server.shutdown(exitProcess: false).timeout(_deadline));
    await server.start().timeout(_deadline);
    // These endpoints perform no queries themselves. Persisting their session
    // logs supplies the database activity whose health checks we exercise.
    await server
        .updateRuntimeSettings(RuntimeSettingsBuilder().build())
        .timeout(_deadline);
    final client = Client(server.apiUrl);
    addTearDown(() async {
      try {
        await client
            .closeStreamingMethodConnections(exception: null)
            .timeout(_deadline);
      } finally {
        client.close();
      }
    });
    return _Fixture(server, observer, client);
  }

  Future<_Snapshot> snapshot([Duration timeout = _deadline]) async {
    final count = await ServerHealthConnectionInfo.db
        .count(
          observer,
          where: (t) => t.serverId.equals(server.serverId),
        )
        .timeout(timeout);
    return (count: count, lastOperation: server.lastDatabaseOperationTime);
  }

  Future<void> waitForCheckAfter(int count) async {
    await _waitFor(
      'a health check after count $count',
      snapshot,
      (current) => current.count > count,
    );
  }

  Future<void> waitForClosedSession(String endpoint, String method) async {
    await _waitFor(
      'a closed session for $endpoint.$method',
      (remaining) => SessionLogEntry.db
          .count(
            observer,
            where: (t) =>
                t.serverId.equals(server.serverId) &
                t.endpoint.equals(endpoint) &
                t.method.equals(method) &
                t.isOpen.equals(false),
          )
          .timeout(remaining),
      (count) => count > 0,
    );
  }

  Future<_Snapshot> waitUntilIdle() {
    final quiet = Stopwatch();
    _Snapshot? last;
    return _waitFor('settled database activity', snapshot, (current) {
      if (current != last) {
        last = current;
        quiet
          ..reset()
          ..start();
      }
      return quiet.elapsed >= _idleWindow;
    });
  }

  // Pass the remaining budget into each query so a slow read cannot extend
  // the readiness deadline by another full operation timeout.
  Future<T> _waitFor<T>(
    String description,
    Future<T> Function(Duration remaining) read,
    bool Function(T) ready,
  ) async {
    final timer = Stopwatch()..start();
    T? last;
    while (timer.elapsed < _deadline) {
      try {
        final current = await read(_deadline - timer.elapsed);
        last = current;
        if (ready(current)) return current;
      } on TimeoutException {
        break;
      }
      final remaining = _deadline - timer.elapsed;
      if (remaining <= Duration.zero) break;
      await Future<void>.delayed(
        remaining < _pollInterval ? remaining : _pollInterval,
      );
    }
    fail('Timed out waiting for $description within $_deadline; last: $last');
  }

  Future<void> expectIdle(_Snapshot expected) async {
    final timer = Stopwatch()..start();
    while (timer.elapsed < _idleWindow) {
      await Future<void>.delayed(_pollInterval);
      expect(
        await snapshot(),
        expected,
        reason:
            'Idle health checks and observer reads must neither persist '
            'checks nor advance the tested pool activity timestamp.',
      );
    }
  }
}

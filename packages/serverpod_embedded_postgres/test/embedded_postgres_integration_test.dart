@Tags(['integration'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

/// Public-API end-to-end: EmbeddedPostgres.start -> endpoint -> SELECT 1
/// -> stop. The smaller integration tests already cover BinaryStore,
/// ClusterStore, and Supervisor in isolation; this one proves the facade
/// wires them together correctly.
void main() {
  late Directory tmpRoot;

  setUp(() {
    tmpRoot = Directory.systemTemp.createTempSync('embedded_pg_facade_');
  });

  tearDown(() {
    if (tmpRoot.existsSync()) tmpRoot.deleteSync(recursive: true);
  });

  // Default transport is UnixTransport. Skip on platforms without Dart UDS
  // support (Windows < Dart 3.11).
  var udsSkip = hasUnixSocketSupport()
      ? null
      : 'Unix domain sockets not available on this Dart/platform';

  group('Given a fresh project layout', skip: udsSkip, () {
    test(
      'when EmbeddedPostgres.start runs with UnixTransport defaults '
      'then endpoint connects, SELECT 1 returns 1, and stop() releases the pidfile.',
      () async {
        var pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));

        var pg_ = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            detach: true, // skip parent-exit hooks under the test runner
          ),
        );

        expect(pg_.isRunning, isTrue);
        expect(pg_.pid, isNotNull);

        var conn = await pg.Connection.open(
          pg_.endpoint,
          settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
        );
        var rs = await conn.execute('SELECT 1');
        expect(rs.first.first, 1);

        // The created database matches options.databaseName.
        var dbRow = await conn.execute('SELECT current_database()');
        expect(dbRow.first.first, 'projectname');

        await conn.close();
        await pg_.stop();

        expect(pg_.isRunning, isFalse);
        expect(
          File(p.join(tmpRoot.path, '.serverpod', 'postgres.pid')).existsSync(),
          isFalse,
          reason: 'pidfile should be removed after stop()',
        );
      },
      timeout: const Timeout(Duration(seconds: 120)),
    );

    test(
      'when start runs twice in a row (no-op data dir) '
      'then the second start re-uses the same cluster (warm initdb skip) and reaches ready in <5s.',
      () async {
        var pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));

        var first = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            detach: true,
          ),
        );
        await first.stop();

        var sw = Stopwatch()..start();
        var second = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            detach: true,
          ),
        );
        sw.stop();

        expect(second.isRunning, isTrue);
        expect(
          sw.elapsedMilliseconds,
          lessThan(5000),
          reason: 'warm start (binary + cluster cached) must be <5s',
        );

        await second.stop();
      },
      timeout: const Timeout(Duration(seconds: 120)),
    );

    test(
      'when reset() runs then a subsequent start initdbs a fresh cluster.',
      () async {
        var pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));

        var pg_ = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            detach: true,
          ),
        );
        await pg_.reset();

        expect(pgDataDir.existsSync(), isFalse);
        expect(
          File(p.join(tmpRoot.path, '.serverpod', 'postgres.pid')).existsSync(),
          isFalse,
        );

        var pg2 = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            detach: true,
          ),
        );
        expect(pg2.isRunning, isTrue);
        await pg2.stop();
      },
      timeout: const Timeout(Duration(seconds: 180)),
    );
  });
}

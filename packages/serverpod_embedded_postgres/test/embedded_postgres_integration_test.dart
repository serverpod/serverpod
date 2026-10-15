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

  group('Given a fresh project layout,', () {
    test(
      'when EmbeddedPostgres.start runs with transport defaults '
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
        expect(pg_.endpoint.isUnixSocket, hasUnixSocketSupport());

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
      'when a default cluster is restarted with TcpTransport '
      'then TCP auth succeeds using its generated password.',
      () async {
        var pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));

        var unix = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            detach: true,
          ),
        );
        await unix.stop();

        var tcp = await EmbeddedPostgres.start(
          EmbeddedPostgresOptions(
            dataDir: pgDataDir,
            databaseName: 'projectname',
            transport: const TcpTransport(),
            detach: true,
          ),
        );
        var conn = await pg.Connection.open(
          tcp.endpoint,
          settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
        );
        var rs = await conn.execute('SELECT 1');
        expect(rs.first.first, 1);
        await conn.close();
        await tcp.stop();
      },
      timeout: const Timeout(Duration(seconds: 180)),
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

  test(
    'Given a stopped cluster last started over its Unix socket, '
    'when it is restarted with TcpTransport and a password, '
    'then TCP auth succeeds with that password',
    () async {
      final pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));
      final unix = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          transport: const UnixTransport(),
          detach: true,
        ),
      );
      await unix.stop();

      final tcp = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          transport: const TcpTransport(password: 'dev-db-password'),
          detach: true,
        ),
      );
      addTearDown(tcp.stop);

      final connection = await pg.Connection.open(
        pg.Endpoint(
          host: tcp.endpoint.host,
          port: tcp.endpoint.port,
          database: 'projectname',
          username: 'postgres',
          password: 'dev-db-password',
        ),
        settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
      );
      addTearDown(connection.close);
      final result = await connection.execute('SELECT 1');
      expect(result.first.first, 1);
    },
    timeout: const Timeout(Duration(seconds: 180)),
  );

  test(
    'Given a project layout with a leftover postgres.password sidecar, '
    'when a cluster is started, '
    'then the sidecar is removed',
    () async {
      var pgDataDir = Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata'));
      var sidecar = File(
        p.join(tmpRoot.path, '.serverpod', 'postgres.password'),
      )..createSync(recursive: true);

      var pg_ = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          detach: true,
        ),
      );
      try {
        expect(sidecar.existsSync(), isFalse);
      } finally {
        await pg_.stop();
      }
    },
    timeout: const Timeout(Duration(seconds: 120)),
  );
}

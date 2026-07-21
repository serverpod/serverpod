@Tags(['integration'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:test/test.dart';

/// Validates the detach + attach round-trip: a postmaster started with
/// detach: true survives the original handle being dropped (no shutdown
/// hooks fired), and a fresh attach() can re-acquire it via the persisted
/// pidfile + state.json.
void main() {
  late Directory tmpRoot;

  setUp(() {
    tmpRoot = Directory.systemTemp.createTempSync('embedded_pg_attach_');
  });

  tearDown(() {
    if (tmpRoot.existsSync()) tmpRoot.deleteSync(recursive: true);
  });

  test(
    'Given a postmaster started with detach enabled, '
    'when the original handle is dropped and the data directory is reattached, '
    'then queries succeed and stopping the attached handle releases the PID file.',
    () async {
      var pgDataDir = Directory(
        p.join(tmpRoot.path, '.serverpod', 'pgdata'),
      );

      // Start with detach: true so the postmaster survives this handle
      // going out of scope (we never call stop() on `started`).
      var started = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          detach: true,
        ),
      );
      var startedPid = started.pid;
      expect(startedPid, isNotNull);

      // Drop the handle without stopping. State + pidfile should remain.
      // (No stop() call here.)
      expect(
        File(
          p.join(tmpRoot.path, '.serverpod', 'postgres.pid'),
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          p.join(
            tmpRoot.path,
            '.serverpod',
            'embedded_postgres_state.json',
          ),
        ).existsSync(),
        isTrue,
      );

      // Reattach.
      var attached = await EmbeddedPostgres.attach(pgDataDir);
      expect(
        attached.pid,
        startedPid,
        reason: 'attach must re-acquire the original PID',
      );
      expect(attached.isRunning, isTrue);

      var conn = await pg.Connection.open(
        attached.endpoint,
        settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
      );
      var rs = await conn.execute('SELECT 1');
      expect(rs.first.first, 1);
      await conn.close();

      await attached.stop();

      expect(
        File(
          p.join(tmpRoot.path, '.serverpod', 'postgres.pid'),
        ).existsSync(),
        isFalse,
        reason: 'attached.stop() should release the pidfile',
      );
    },
    timeout: const Timeout(Duration(seconds: 120)),
  );

  test(
    'Given a data directory owned by a live detached postmaster, '
    'when another postmaster is started on the same data directory, '
    'then PostmasterLockBusyException is thrown with the existing PID.',
    () async {
      var pgDataDir = Directory(
        p.join(tmpRoot.path, '.serverpod', 'pgdata'),
      );

      var started = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          detach: true,
        ),
      );

      try {
        await expectLater(
          EmbeddedPostgres.start(
            EmbeddedPostgresOptions(
              dataDir: pgDataDir,
              databaseName: 'projectname',
              detach: true,
              repairStaleLocks: true,
            ),
          ),
          throwsA(
            isA<PostmasterLockBusyException>().having(
              (e) => e.existingPid,
              'existingPid',
              started.pid,
            ),
          ),
        );
      } finally {
        var attached = await EmbeddedPostgres.attach(pgDataDir);
        await attached.stop();
      }
    },
    timeout: const Timeout(Duration(seconds: 180)),
  );

  test(
    'Given a detached TCP postmaster, '
    'when its data directory is reattached, '
    'then the endpoint retains its password and queries succeed.',
    () async {
      var pgDataDir = Directory(
        p.join(tmpRoot.path, '.serverpod', 'pgdata'),
      );

      var started = await EmbeddedPostgres.start(
        EmbeddedPostgresOptions(
          dataDir: pgDataDir,
          databaseName: 'projectname',
          transport: const TcpTransport(),
          detach: true,
        ),
      );
      var origPw = started.endpoint.password!;
      var origPort = started.endpoint.port;

      var attached = await EmbeddedPostgres.attach(pgDataDir);
      expect(
        attached.endpoint.password,
        origPw,
        reason: 'persisted password must round-trip across attach',
      );
      expect(attached.endpoint.port, origPort);

      var conn = await pg.Connection.open(
        attached.endpoint,
        settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
      );
      var rs = await conn.execute('SELECT 1');
      expect(rs.first.first, 1);
      await conn.close();

      await attached.stop();
    },
    timeout: const Timeout(Duration(seconds: 180)),
  );

  test(
    'Given a postmaster launched by startOrAttach on a shared data directory, '
    'when startOrAttach is called again on the same data directory, '
    'then it attaches to the running postmaster instead of launching.',
    () async {
      var opts = EmbeddedPostgresOptions(
        dataDir: Directory(p.join(tmpRoot.path, '.serverpod', 'pgdata')),
        databaseName: 'projectname',
        detach: true,
        repairStaleLocks: true,
      );
      var first = await EmbeddedPostgres.startOrAttach(opts);
      addTearDown(() async {
        if (first.launched && first.handle.isRunning) {
          await first.handle.stop();
        }
      });

      expect(
        first.launched,
        isTrue,
        reason: 'the first caller spawns the postmaster',
      );
      expect(first.handle.pid, isNotNull);

      var second = await EmbeddedPostgres.startOrAttach(opts);
      expect(
        second.launched,
        isFalse,
        reason:
            'a live postmaster already owns the dataDir, so the '
            'second caller attaches as a client',
      );
      expect(
        second.handle.pid,
        first.handle.pid,
        reason: 'attach must re-acquire the original PID',
      );
    },
    timeout: const Timeout(Duration(seconds: 180)),
  );

  test(
    'Given a data directory that was never started, '
    'when attach is called, '
    'then an AttachException is thrown.',
    () async {
      var pgDataDir = Directory(
        p.join(tmpRoot.path, '.serverpod', 'pgdata'),
      );

      await expectLater(
        EmbeddedPostgres.attach(pgDataDir),
        throwsA(isA<AttachException>()),
      );
    },
  );
}

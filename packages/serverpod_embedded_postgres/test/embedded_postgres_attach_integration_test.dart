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

  group(
    'Given a detached postmaster',
    () {
      test(
        'when start runs with detach: true, the original handle is dropped, and attach is called on the same dataDir '
        'then the SELECT 1 round trip works on the reattached handle and stop() releases the pidfile.',
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
        'when start is called on a dataDir that already has a live postmaster '
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
        'when detached TCP postmaster is reattached '
        'then the libpq URI still carries the persisted password and SELECT 1 works.',
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
    },
  );

  group(
    'Given a dataDir that was never started',
    () {
      test(
        'when attach is called '
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
    },
  );
}

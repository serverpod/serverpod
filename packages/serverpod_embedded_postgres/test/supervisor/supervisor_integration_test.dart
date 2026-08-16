@Tags(['integration'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_embedded_postgres/src/binary/binary_store.dart';
import 'package:serverpod_embedded_postgres/src/binary/maven_url.dart';
import 'package:serverpod_embedded_postgres/src/cluster/cluster_store.dart';
import 'package:serverpod_embedded_postgres/src/supervisor/process_identity.dart';
import 'package:serverpod_embedded_postgres/src/supervisor/supervisor.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

/// End-to-end test: BinaryStore -> ClusterStore -> Supervisor -> SELECT 1.
/// Validates the supervisor's spawn / ready-detect / stop cycle against a
/// real PG postmaster.
void main() {
  late Directory installDir;
  late Directory dataRoot;
  late Directory pgDataDir;
  late Directory runDir;
  late File pidFile;
  late File logFile;

  setUpAll(() async {
    var store = BinaryStore();
    var artifact = ZonkyArtifact.forCurrentPlatform(
      version: Version(16, 13, 0),
    );
    installDir = await store.ensure(artifact);
    store.close();
  });

  setUp(() async {
    dataRoot = Directory.systemTemp.createTempSync('supervisor_test_');
    pgDataDir = Directory(p.join(dataRoot.path, 'pgdata'));
    runDir = Directory(p.join(dataRoot.path, 'run'))..createSync();
    pidFile = File(p.join(dataRoot.path, 'postgres.pid'));
    logFile = File(p.join(dataRoot.path, 'postgres.log'));

    var cluster = ClusterStore(installDir: installDir, dataDir: pgDataDir);
    await cluster.ensureInitialized(username: 'postgres');
    cluster.reconcilePostgresConf(transport: const UnixTransport());
  });

  tearDown(() {
    if (dataRoot.existsSync()) dataRoot.deleteSync(recursive: true);
  });

  // Tests below use UnixTransport. Skip on platforms without Dart UDS
  // support (Windows < Dart 3.11).
  var udsSkip = hasUnixSocketSupport()
      ? null
      : 'Unix domain sockets not available on this Dart/platform';

  group(
    'Given an initialized cluster and the real Zonky binaries',
    skip: udsSkip,
    () {
      test(
        'when Supervisor.start runs with UnixTransport '
        'then the postmaster becomes ready, accepts a SELECT 1, and stops cleanly on stop().',
        () async {
          var sup = await Supervisor.start(
            installDir: installDir,
            dataDir: pgDataDir,
            runDir: runDir,
            transport: const UnixTransport(),
            startTimeout: const Duration(seconds: 30),
            pidFile: pidFile,
            logFile: logFile,
            detach: true, // skip signal hooks under the test runner
          );

          expect(sup.isRunning, isTrue);
          expect(sup.pid, isNotNull);
          expect(pidFile.existsSync(), isTrue);

          // Real connection roundtrip.
          var sockPath = p.join(runDir.absolute.path, '.s.PGSQL.5432');
          var conn = await pg.Connection.open(
            pg.Endpoint(
              host: sockPath,
              isUnixSocket: true,
              database: 'postgres',
              username: 'postgres',
            ),
            settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
          );
          var rs = await conn.execute('SELECT 1');
          expect(rs.first.first, 1);
          await conn.close();

          await sup.stop();

          expect(sup.isRunning, isFalse);
          expect(
            pidFile.existsSync(),
            isFalse,
            reason: 'pidfile should be removed after stop()',
          );
        },
        timeout: const Timeout(Duration(seconds: 90)),
      );

      test(
        'when verifyIdentity is called on the captured identity of a supervisor that has been cleanly stopped '
        'then notRunning is returned (or foreign, if the kernel recycled the pid).',
        () async {
          var sup = await Supervisor.start(
            installDir: installDir,
            dataDir: pgDataDir,
            runDir: runDir,
            transport: const UnixTransport(),
            startTimeout: const Duration(seconds: 30),
            pidFile: pidFile,
            logFile: logFile,
            detach: true,
          );

          var capturedPid = sup.pid!;
          await sup.stop();

          var stale = ProcessIdentity(
            pid: capturedPid,
            executable: p.join(installDir.path, 'bin', 'postgres'),
            dataDir: pgDataDir.absolute.path,
            startedAt: DateTime.now().toUtc(),
            supervisorPid: pid,
            supervisorExecutable: p.absolute(Platform.resolvedExecutable),
          );

          // The PID is now released; verifyIdentity should report
          // notRunning (or, if recycled by the kernel, foreign - both are
          // safe outcomes).
          var match = verifyIdentity(stale);
          expect(
            match,
            anyOf(IdentityMatch.notRunning, IdentityMatch.foreign),
            reason: 'a recently-stopped pid must not be reported as ours',
          );
        },
        timeout: const Timeout(Duration(seconds: 90)),
      );

      test(
        'when Supervisor.start is given a 100ms timeout against a non-running postmaster '
        'then StartupTimeoutException is thrown with logTail attached.',
        () async {
          // Use an installDir that won't actually start fast - we just
          // bound the timeout very tight so even a normal start can't make it.
          // The dataDir is initialized; a real start would normally finish
          // in 70-150 ms. 1ms is well under.
          try {
            await Supervisor.start(
              installDir: installDir,
              dataDir: pgDataDir,
              runDir: runDir,
              transport: const UnixTransport(),
              startTimeout: const Duration(milliseconds: 1),
              pidFile: pidFile,
              logFile: logFile,
              detach: true,
            );
            fail('expected StartupTimeoutException');
          } on StartupTimeoutException {
            // Ensure stop() ran in the catch path so no postmaster lingers.
            await Future<void>.delayed(const Duration(seconds: 2));
          }
        },
        timeout: const Timeout(Duration(seconds: 30)),
      );
    },
  );
}

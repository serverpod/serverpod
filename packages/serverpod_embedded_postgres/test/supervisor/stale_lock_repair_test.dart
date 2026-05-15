import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_embedded_postgres/src/supervisor/process_identity.dart';
import 'package:serverpod_embedded_postgres/src/supervisor/stale_lock_repair.dart';
import 'package:test/test.dart';

/// PIDs in this range should not exist as real processes on CI / dev hosts.
const int _unlikelyLivePid = 999999999;

void main() {
  late Directory root;
  late Directory pgData;
  late File serverpodPidFile;
  late File fakePostgres;
  final spawnedPids = <int>{};

  setUp(() {
    root = Directory.systemTemp.createTempSync('stale_lock_repair_');
    pgData = Directory(p.join(root.path, 'pgdata'))..createSync();
    serverpodPidFile = File(p.join(root.path, 'postgres.pid'));
    fakePostgres = File(p.join(root.path, 'postgres'));
    fakePostgres.writeAsStringSync(
      '#!/bin/sh\n'
      "trap 'exit 0' INT TERM\n"
      'while true; do\n'
      '  sleep 1\n'
      'done\n',
    );
    Process.runSync('chmod', ['+x', fakePostgres.path]);
  });

  tearDown(() async {
    for (var trackedPid in spawnedPids) {
      if (processPidIsLive(trackedPid)) {
        Process.killPid(trackedPid, ProcessSignal.sigkill);
        await _waitForProcessToStop(trackedPid);
      }
    }
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  test(
    'Given a postmaster.pid pointing at a dead PID, '
    'when repairing embedded postgres locks, '
    'then the postmaster.pid file is removed.',
    () async {
      File(p.join(pgData.path, 'postmaster.pid')).writeAsStringSync(
        '$_unlikelyLivePid\n'
        '${pgData.path}\n'
        '1284356094\n'
        '5432\n'
        '${p.join(pgData.parent.path, 'run')}\n',
      );

      await repairStaleEmbeddedPostgresLocks(
        pgDataDir: pgData,
        serverpodPidFile: serverpodPidFile,
      );

      expect(
        File(p.join(pgData.path, 'postmaster.pid')).existsSync(),
        isFalse,
      );
    },
  );

  test(
    'Given a postgres.pid pointing at a dead supervised PID, '
    'when repairing embedded postgres locks, '
    'then postgres.pid is removed.',
    () async {
      ProcessIdentity.writeAtomic(
        serverpodPidFile,
        ProcessIdentity(
          pid: _unlikelyLivePid,
          executable: '/abs/postgres',
          dataDir: p.absolute(pgData.path),
          startedAt: DateTime.utc(2026, 5, 14),
          supervisorPid: pid,
          supervisorExecutable: p.absolute(Platform.resolvedExecutable),
        ),
      );

      await repairStaleEmbeddedPostgresLocks(
        pgDataDir: pgData,
        serverpodPidFile: serverpodPidFile,
      );

      expect(serverpodPidFile.existsSync(), isFalse);
    },
  );

  test(
    'Given no lock files exist, '
    'when repairing embedded postgres locks, '
    'then repair completes without throwing.',
    () async {
      await repairStaleEmbeddedPostgresLocks(
        pgDataDir: pgData,
        serverpodPidFile: serverpodPidFile,
      );

      expect(serverpodPidFile.existsSync(), isFalse);
    },
  );

  test(
    'Given a postmaster.pid with a malformed first line, '
    'when repairing embedded postgres locks, '
    'then the file is left in place.',
    () async {
      final nativePid = File(p.join(pgData.path, 'postmaster.pid'));
      nativePid.writeAsStringSync('not-a-pid\n');

      await repairStaleEmbeddedPostgresLocks(
        pgDataDir: pgData,
        serverpodPidFile: serverpodPidFile,
      );

      expect(nativePid.existsSync(), isTrue);
    },
  );

  test(
    'Given a live postmaster still parented by this Dart process, '
    'when repairing embedded postgres locks, '
    'then the running postmaster and both pidfiles are left in place.',
    () async {
      final postmaster = await Process.start(fakePostgres.path, [
        '-D',
        pgData.path,
      ]);
      spawnedPids.add(postmaster.pid);

      _writeNativePidFile(pgData: pgData, postmasterPid: postmaster.pid);
      ProcessIdentity.writeAtomic(
        serverpodPidFile,
        ProcessIdentity(
          pid: postmaster.pid,
          executable: fakePostgres.path,
          dataDir: p.absolute(pgData.path),
          startedAt: DateTime.utc(2026, 5, 14),
          supervisorPid: pid,
          supervisorExecutable: p.absolute(Platform.resolvedExecutable),
        ),
      );

      await repairStaleEmbeddedPostgresLocks(
        pgDataDir: pgData,
        serverpodPidFile: serverpodPidFile,
      );

      expect(processPidIsLive(postmaster.pid), isTrue);
      expect(serverpodPidFile.existsSync(), isTrue);
      expect(File(p.join(pgData.path, 'postmaster.pid')).existsSync(), isTrue);
    },
    onPlatform: const {
      'windows': Skip('POSIX parent-process verification only'),
    },
  );

  test(
    'Given a live postmaster whose recorded Dart supervisor is gone, '
    'when repairing embedded postgres locks, '
    'then the orphaned postmaster and both pidfiles are removed.',
    () async {
      final orphanPid = _spawnOrphanedFakePostmaster(
        executable: fakePostgres,
        pgData: pgData,
      );
      spawnedPids.add(orphanPid);

      _writeNativePidFile(pgData: pgData, postmasterPid: orphanPid);
      ProcessIdentity.writeAtomic(
        serverpodPidFile,
        ProcessIdentity(
          pid: orphanPid,
          executable: fakePostgres.path,
          dataDir: p.absolute(pgData.path),
          startedAt: DateTime.utc(2026, 5, 14),
          supervisorPid: _unlikelyLivePid,
          supervisorExecutable: p.absolute(Platform.resolvedExecutable),
        ),
      );

      await repairStaleEmbeddedPostgresLocks(
        pgDataDir: pgData,
        serverpodPidFile: serverpodPidFile,
      );

      expect(await _waitForProcessToStop(orphanPid), isTrue);
      expect(serverpodPidFile.existsSync(), isFalse);
      expect(File(p.join(pgData.path, 'postmaster.pid')).existsSync(), isFalse);
      spawnedPids.remove(orphanPid);
    },
    onPlatform: const {
      'windows': Skip('POSIX parent-process verification only'),
    },
  );

  test(
    'Given a live postmaster reparented to init and no supervisor pidfile, '
    'when repairing embedded postgres locks, '
    'then the orphaned postmaster is removed from postmaster.pid alone.',
    () async {
      final orphanPid = _spawnOrphanedFakePostmaster(
        executable: fakePostgres,
        pgData: pgData,
      );
      spawnedPids.add(orphanPid);
      _writeNativePidFile(pgData: pgData, postmasterPid: orphanPid);

      await repairStaleEmbeddedPostgresLocks(
        pgDataDir: pgData,
        serverpodPidFile: serverpodPidFile,
      );

      expect(await _waitForProcessToStop(orphanPid), isTrue);
      expect(serverpodPidFile.existsSync(), isFalse);
      expect(File(p.join(pgData.path, 'postmaster.pid')).existsSync(), isFalse);
      spawnedPids.remove(orphanPid);
    },
    onPlatform: const {
      'windows': Skip('POSIX parent-process verification only'),
    },
  );
}

void _writeNativePidFile({
  required Directory pgData,
  required int postmasterPid,
}) {
  File(p.join(pgData.path, 'postmaster.pid')).writeAsStringSync(
    '$postmasterPid\n'
    '${pgData.path}\n'
    '1284356094\n'
    '5432\n'
    '${p.join(pgData.parent.path, 'run')}\n',
  );
}

int _spawnOrphanedFakePostmaster({
  required File executable,
  required Directory pgData,
}) {
  final result = Process.runSync('sh', [
    '-c',
    'nohup "\$1" -D "\$2" >/dev/null 2>&1 & echo \$!',
    'sh',
    executable.path,
    pgData.path,
  ]);
  expect(
    result.exitCode,
    0,
    reason: 'failed to spawn orphaned fake postmaster',
  );

  final stdout = (result.stdout as String).trim();
  final orphanPid = int.tryParse(stdout);
  expect(orphanPid, isNotNull, reason: 'expected spawned PID from shell');
  return orphanPid!;
}

Future<bool> _waitForProcessToStop(int processId) async {
  final deadline = DateTime.now().add(const Duration(seconds: 5));
  while (DateTime.now().isBefore(deadline)) {
    if (!processPidIsLive(processId)) {
      return true;
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  return !processPidIsLive(processId);
}

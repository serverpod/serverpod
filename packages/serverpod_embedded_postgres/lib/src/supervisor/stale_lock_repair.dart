import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/serverpod_shared.dart';

import 'process_identity.dart';

/// Best-effort cleanup of embedded-Postgres lock state after an abrupt exit
/// (debugger stop, orphaned VM, etc.).
///
/// Sync steps:
/// - Deletes Serverpod supervisor `postgres.pid` when it references a dead PID
///   ([IdentityMatch.notRunning]).
/// - Deletes PostgreSQL's `postmaster.pid` in [pgDataDir] when its first-line
///   PID is not running.
///
/// Async step (POSIX only; skipped on Windows): if both pidfiles still point
/// at the same live postmaster and that postmaster has been reparented away
/// from the recorded Dart supervisor:
/// 1. Prefer [`pg_ctl stop`](https://www.postgresql.org/docs/current/app-pg-ctl.html)
///    when [pgCtlExecutable] exists (same Zonky `bin/` as `postgres`) so
///    backends exit and SysV shared memory is released cleanly.
/// 2. Fall back to SIGTERM/SIGKILL on the postmaster. PG's SIGTERM handler
///    propagates to its backends; if both that and pg_ctl fail, orphan
///    backends keep the shared-memory grip and the user has to clean up.
Future<void> repairStaleEmbeddedPostgresLocks({
  required Directory pgDataDir,
  required File serverpodPidFile,
  File? pgCtlExecutable,
}) async {
  _repairServerpodPidfile(serverpodPidFile);
  _repairNativePostmasterPidfileIfDeadPid(pgDataDir);
  await _terminateLiveOrphanPostmasterIfVerifiedPosix(
    pgDataDir,
    serverpodPidFile: serverpodPidFile,
    pgCtlExecutable: pgCtlExecutable,
  );
  _repairNativePostmasterPidfileIfDeadPid(pgDataDir);
}

void _repairServerpodPidfile(File serverpodPidFile) {
  final identity = ProcessIdentity.read(serverpodPidFile);
  if (identity == null) return;

  switch (verifyIdentity(identity)) {
    case IdentityMatch.notRunning:
      _tryDelete(serverpodPidFile);
    case IdentityMatch.foreign:
    case IdentityMatch.matchesOurs:
      break;
  }
}

void _repairNativePostmasterPidfileIfDeadPid(Directory pgDataDir) {
  final file = File(p.join(pgDataDir.path, 'postmaster.pid'));
  if (!file.existsSync()) return;

  final pid = readPostmasterPidFile(file);
  if (pid == null) return;

  if (!isProcessAlive(pid)) {
    _tryDelete(file);
  }
}

Future<void> _terminateLiveOrphanPostmasterIfVerifiedPosix(
  Directory pgDataDir, {
  required File serverpodPidFile,
  File? pgCtlExecutable,
}) async {
  if (Platform.isWindows) return;

  final identity = ProcessIdentity.read(serverpodPidFile);
  if (identity == null) return;

  final file = File(p.join(pgDataDir.path, 'postmaster.pid'));
  final pid = readPostmasterPidFile(file);
  if (pid == null || !isProcessAlive(pid)) return;
  if (pid != identity.pid) return;
  if (verifyIdentity(identity) != IdentityMatch.matchesOurs) return;
  if (verifySupervisorRelationship(identity) !=
      SupervisorRelationship.orphaned) {
    return;
  }

  // Prefer pg_ctl so shared memory is released; fall back to subtree kill
  // if PG hasn't exited.
  if (pgCtlExecutable != null && pgCtlExecutable.existsSync()) {
    await _tryPgCtlStop(pgCtlExecutable, pgDataDir);
  }
  if (isProcessAlive(pid)) {
    await _killPostmasterPosix(pid);
  }

  _tryDelete(serverpodPidFile);
  _repairNativePostmasterPidfileIfDeadPid(pgDataDir);
  await _delayForIpcTeardown();
}

Future<void> _delayForIpcTeardown() async {
  await Future<void>.delayed(const Duration(milliseconds: 150));
}

/// Tries `pg_ctl stop` so shared memory is released (orphan recovery only).
///
/// Uses **immediate** mode with a **short** `-t` budget: this path is for dev
/// recovery after bad exits, not graceful production shutdown. A `fast` stop
/// can block on checkpoints and, combined with two `-t 30` passes, stalled
/// `setUpAll` for up to ~60s between test groups.
Future<void> _tryPgCtlStop(File pgCtl, Directory pgDataDir) async {
  if (!pgCtl.existsSync()) return;

  String dataPath;
  try {
    dataPath = p.normalize(
      Directory(pgDataDir.absolute.path).resolveSymbolicLinksSync(),
    );
  } on FileSystemException {
    dataPath = p.normalize(p.absolute(pgDataDir.path));
  }

  try {
    Process.runSync(pgCtl.path, [
      'stop',
      '-D',
      dataPath,
      '-m',
      'immediate',
      '-w',
      '-t',
      '10',
      '-s',
    ]);
  } on ProcessException {
    // Fall through; subtree kill may still help.
  }
  await Future<void>.delayed(const Duration(milliseconds: 80));
}

/// SIGTERM-then-SIGKILL the postmaster. PG's own SIGTERM handler propagates
/// to its backends, so we do not walk the subtree ourselves. If pg_ctl ALSO
/// failed and SIGTERM doesn't bring PG down within 3s, SIGKILL leaves orphan
/// backends with the SysV shared-memory segment held; recoverable manually
/// with `rm -rf .serverpod/pgdata` or a real `pg_ctl stop`.
Future<void> _killPostmasterPosix(int pid) async {
  _signalPid(pid, ProcessSignal.sigterm);
  if (await _waitForPidExit(pid, const Duration(seconds: 3))) return;
  _signalPid(pid, ProcessSignal.sigkill);
  await _waitForPidExit(pid, const Duration(seconds: 3));
}

void _signalPid(int pid, ProcessSignal sig) {
  try {
    Process.killPid(pid, sig);
  } catch (_) {}
}

Future<bool> _waitForPidExit(int pid, Duration budget) async {
  final deadline = DateTime.now().add(budget);
  while (DateTime.now().isBefore(deadline)) {
    if (!isProcessAlive(pid)) return true;
    await Future<void>.delayed(const Duration(milliseconds: 80));
  }
  return !isProcessAlive(pid);
}

void _tryDelete(File file) {
  try {
    if (file.existsSync()) {
      file.deleteSync();
    }
  } on FileSystemException {
    // Best-effort only.
  }
}

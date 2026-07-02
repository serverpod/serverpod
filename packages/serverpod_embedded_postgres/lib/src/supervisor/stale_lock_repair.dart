import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/process_io.dart';

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
/// Async step: if both pidfiles still point at the same live postmaster
/// whose original Dart supervisor is gone:
/// 1. Prefer [`pg_ctl stop`](https://www.postgresql.org/docs/current/app-pg-ctl.html)
///    when [pgCtlExecutable] exists (same Zonky `bin/` as `postgres`) so
///    backends exit and SysV shared memory is released cleanly.
/// 2. Fall back to SIGTERM/SIGKILL on the postmaster (TerminateProcess on
///    Windows). PG's SIGTERM handler propagates to its backends; if both
///    that and pg_ctl fail, orphan backends keep the shared-memory grip
///    and the user has to clean up.
Future<void> repairStaleEmbeddedPostgresLocks({
  required Directory pgDataDir,
  required File serverpodPidFile,
  File? pgCtlExecutable,
}) async {
  _repairServerpodPidfile(serverpodPidFile);
  _repairNativePostmasterPidfileIfDeadPid(pgDataDir);
  await _terminateLiveOrphanPostmaster(
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

Future<void> _terminateLiveOrphanPostmaster(
  Directory pgDataDir, {
  required File serverpodPidFile,
  File? pgCtlExecutable,
}) async {
  final identity = ProcessIdentity.read(serverpodPidFile);
  if (identity == null) return;

  final file = File(p.join(pgDataDir.path, 'postmaster.pid'));
  final pid = readPostmasterPidFile(file);
  if (pid == null || !isProcessAlive(pid)) return;
  if (pid != identity.pid) return;
  if (!isPostmasterOrphan(identity)) return;

  // Prefer pg_ctl so shared memory is released cleanly; fall back to
  // SIGTERM/SIGKILL on the postmaster.
  if (pgCtlExecutable != null && pgCtlExecutable.existsSync()) {
    await _tryPgCtlStop(pgCtlExecutable, pgDataDir);
  }
  if (isProcessAlive(pid)) {
    await _killPostmaster(pid);
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

/// SIGTERM-then-SIGKILL the postmaster (Process.killPid maps to
/// TerminateProcess on Windows, so this works cross-platform). PG's own
/// SIGTERM handler propagates to its backends; if pg_ctl ALSO failed and
/// SIGTERM doesn't bring PG down within 3s, SIGKILL leaves orphan backends
/// with the SysV shared-memory segment held - recoverable manually with
/// `rm -rf .serverpod/pgdata` or a real `pg_ctl stop`.
Future<void> _killPostmaster(int pid) async {
  _signalPid(pid, ProcessSignal.sigterm);
  if (await waitForPidExit(pid, const Duration(seconds: 3))) return;
  _signalPid(pid, ProcessSignal.sigkill);
  await waitForPidExit(pid, const Duration(seconds: 3));
}

void _signalPid(int pid, ProcessSignal sig) {
  try {
    Process.killPid(pid, sig);
  } catch (_) {}
}

/// Polls until [pid] is gone, up to [budget] (80ms cadence). Returns whether
/// the process had exited by the deadline. Shared by stale-lock cleanup and the
/// pre-launch wait for a previous postmaster to release its socket lock.
Future<bool> waitForPidExit(int pid, Duration budget) async {
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

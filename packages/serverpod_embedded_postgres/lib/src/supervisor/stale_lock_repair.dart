import 'dart:io';

import 'package:path/path.dart' as p;

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
/// at the same **live** postmaster and that postmaster has been reparented
/// away from the recorded Dart supervisor, OR if only `postmaster.pid`
/// remains and its live postmaster has already been reparented to an init-like
/// process:
/// 1. Prefer [`pg_ctl stop`](https://www.postgresql.org/docs/current/app-pg-ctl.html)
///    when [pgCtlExecutable] exists (same **Zonky** `bin/` as `postgres`) so
///    backends exit and **SysV shared memory** is released.
/// 2. Otherwise escalate signals on the **entire process subtree** (Linux:
///    `/proc` - killing only the postmaster can leave children holding the
///    cluster's shared memory block).
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

  if (!processPidIsLive(pid)) {
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
  if (pid == null || !processPidIsLive(pid)) return;
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
  if (processPidIsLive(pid)) {
    await _killPostgresClusterPosix(pid);
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

/// Stops [rootPid] and (on Linux) every descendant so no backend keeps the
/// cluster's shared memory segment. Recovery-only: a checkpoint-graceful
/// SIGINT is pure latency when the caller already decided this is an orphan.
Future<void> _killPostgresClusterPosix(int rootPid) async {
  final tree = _collectProcessTree(rootPid);

  for (final pid in tree) {
    _signalPid(pid, ProcessSignal.sigterm);
  }
  if (await _waitUntilAllNotLive(tree, const Duration(seconds: 3))) return;

  for (final pid in tree) {
    if (processPidIsLive(pid)) {
      _signalPid(pid, ProcessSignal.sigkill);
    }
  }
  await _waitUntilAllNotLive(tree, const Duration(seconds: 3));
}

void _signalPid(int pid, ProcessSignal sig) {
  try {
    Process.killPid(pid, sig);
  } catch (_) {}
}

Future<bool> _waitUntilAllNotLive(Set<int> pids, Duration budget) async {
  final deadline = DateTime.now().add(budget);
  while (DateTime.now().isBefore(deadline)) {
    if (pids.every((p) => !processPidIsLive(p))) {
      return true;
    }
    await Future<void>.delayed(const Duration(milliseconds: 80));
  }
  return pids.every((p) => !processPidIsLive(p));
}

Set<int> _collectProcessTree(int rootPid) {
  if (Platform.isLinux) {
    return _linuxSubtreePids(rootPid);
  }
  return {rootPid};
}

/// All PIDs under [root] (inclusive) via `/proc` parent links (Linux).
Set<int> _linuxSubtreePids(int root) {
  final all = <int>{};

  void visit(int pid) {
    if (!all.add(pid)) {
      return;
    }
    for (final c in _linuxDirectChildren(pid)) {
      visit(c);
    }
  }

  visit(root);
  return all;
}

List<int> _linuxDirectChildren(int ppid) {
  final out = <int>[];
  final proc = Directory('/proc');
  if (!proc.existsSync()) {
    return out;
  }

  Directory ent;
  for (final entity in proc.listSync(followLinks: false)) {
    if (entity is! Directory) continue;
    ent = entity;
    final name = p.basename(ent.path);
    final pid = int.tryParse(name);
    if (pid == null) {
      continue;
    }
    try {
      final status = File(p.join(ent.path, 'status')).readAsStringSync();
      for (final line in status.split('\n')) {
        if (line.startsWith('PPid:')) {
          final parent = int.tryParse(line.substring(5).trim());
          if (parent == ppid) {
            out.add(pid);
          }
          break;
        }
      }
    } on FileSystemException {
      // Process vanished; skip.
    }
  }
  return out;
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

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
///    `/proc` — killing only the postmaster can leave children holding the
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

  final pid = _readFirstLinePid(file);
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

  final file = File(p.join(pgDataDir.path, 'postmaster.pid'));
  if (!file.existsSync()) return;

  var pid = _readFirstLinePid(file);
  if (pid == null || !processPidIsLive(pid)) return;

  final identity = ProcessIdentity.read(serverpodPidFile);
  var shouldTerminate = false;

  if (identity != null) {
    if (verifyIdentity(identity) != IdentityMatch.matchesOurs) return;
    if (pid != identity.pid) return;
    shouldTerminate =
        verifySupervisorRelationship(identity) ==
        SupervisorRelationship.orphaned;
  } else {
    shouldTerminate = _isLiveInitReparentedPostmasterForDataDir(pid, pgDataDir);
  }

  if (!shouldTerminate) return;

  if (pgCtlExecutable != null && pgCtlExecutable.existsSync()) {
    await _tryPgCtlStop(pgCtlExecutable, pgDataDir);
    _repairNativePostmasterPidfileIfDeadPid(pgDataDir);
    if (!file.existsSync()) {
      if (identity != null) {
        _tryDelete(serverpodPidFile);
      }
      await _delayForIpcTeardown();
      return;
    }
    pid = _readFirstLinePid(file);
    if (pid == null) {
      if (identity != null) {
        _tryDelete(serverpodPidFile);
      }
      return;
    }
    if (identity != null) {
      if (pid != identity.pid) {
        _tryDelete(serverpodPidFile);
        return;
      }
      if (verifyIdentity(identity) != IdentityMatch.matchesOurs) {
        _tryDelete(serverpodPidFile);
        _repairNativePostmasterPidfileIfDeadPid(pgDataDir);
        await _delayForIpcTeardown();
        return;
      }
      if (verifySupervisorRelationship(identity) !=
          SupervisorRelationship.orphaned) {
        return;
      }
    } else if (!_isLiveInitReparentedPostmasterForDataDir(pid, pgDataDir)) {
      return;
    }
  }

  if (await _terminatePostgresClusterPosix(pid)) {
    if (identity != null) {
      _tryDelete(serverpodPidFile);
    }
    _repairNativePostmasterPidfileIfDeadPid(pgDataDir);
    await _delayForIpcTeardown();
  }
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
/// cluster's shared memory segment.
Future<bool> _terminatePostgresClusterPosix(int rootPid) async {
  final tree = _collectProcessTree(rootPid);
  final order = _depthDescendingKillOrder(tree, rootPid);

  // SIGINT the postmaster first so PostgreSQL can attempt a coordinated
  // shutdown when the tree is still intact.
  _signalPid(rootPid, ProcessSignal.sigint);
  if (await _waitUntilAllNotLive(tree, const Duration(seconds: 12))) {
    return true;
  }

  for (final pid in order) {
    _signalPid(pid, ProcessSignal.sigterm);
  }
  if (await _waitUntilAllNotLive(tree, const Duration(seconds: 10))) {
    return true;
  }

  for (final pid in tree) {
    if (processPidIsLive(pid)) {
      _signalPid(pid, ProcessSignal.sigkill);
    }
  }
  return _waitUntilAllNotLive(tree, const Duration(seconds: 8));
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

/// Deepest descendants first so we do not kill the postmaster while workers
/// still rely on IPC it owns (when signals are escalated cluster-wide).
List<int> _depthDescendingKillOrder(Set<int> tree, int root) {
  if (!Platform.isLinux || tree.length <= 1) {
    return tree.toList();
  }

  final depth = <int, int>{};
  void assignDepth(int pid, int d) {
    depth[pid] = d;
    for (final c in _linuxDirectChildren(pid)) {
      if (tree.contains(c)) assignDepth(c, d + 1);
    }
  }

  assignDepth(root, 0);

  final list = tree.toList()
    ..sort((a, b) => (depth[b] ?? 0).compareTo(depth[a] ?? 0));
  return list;
}

/// PostgreSQL writes the postmaster PID on the first line of `postmaster.pid`.
int? _readFirstLinePid(File file) {
  try {
    final lines = file.readAsLinesSync();
    if (lines.isEmpty) {
      return null;
    }
    final first = lines.first.trim();
    if (first.isEmpty) {
      return null;
    }
    final token = first.split(RegExp(r'\s+')).first;
    return int.tryParse(token);
  } on FileSystemException {
    return null;
  } on FormatException {
    return null;
  }
}

bool _isLiveInitReparentedPostmasterForDataDir(int pid, Directory pgDataDir) {
  if (!verifyPostmasterPidForDataDir(pid, pgDataDir.path)) {
    return false;
  }

  final parentPid = readPosixParentPid(pid);
  if (parentPid == null) return false;
  return _isLikelyInitLikeProcess(parentPid);
}

bool _isLikelyInitLikeProcess(int pid) {
  if (pid == 1) {
    return true;
  }

  final cmdline = readPosixProcessCmdline(pid);
  if (cmdline == null || cmdline.isEmpty) {
    return false;
  }

  final executable = p.basename(cmdline.split(RegExp(r'\s+')).first);
  return executable == 'init' ||
      executable == 'systemd' ||
      executable == 'launchd';
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

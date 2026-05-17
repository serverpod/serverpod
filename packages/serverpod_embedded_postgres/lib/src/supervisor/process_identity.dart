import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Snapshot of a postmaster's identity at supervisor-start time.
///
/// Persisted in JSON to `.serverpod/postgres.pid` so a later [start] /
/// [attach] can decide whether a live process is OUR postmaster (reuse)
/// or a foreign one (refuse to touch). Identity is verified via cmdline +
/// cwd at attach time, NOT just by PID - PIDs get recycled and we must
/// never SIGKILL a foreign process.
class ProcessIdentity {
  /// OS process ID of the postmaster.
  final int pid;

  /// Absolute path to the `postgres` executable.
  final String executable;

  /// Absolute path to PGDATA, used to disambiguate same-binary postmasters
  /// owning different clusters on the same host.
  final String dataDir;

  /// ISO-8601 UTC timestamp of when the supervisor wrote this record.
  final DateTime startedAt;

  /// PID of the Dart supervisor process that spawned the postmaster.
  ///
  /// Used by stale-lock repair to detect when the postmaster survived but its
  /// original parent VM did not.
  final int supervisorPid;

  /// Absolute path to the supervisor executable (`dart`, `flutter_tester`,
  /// etc.).
  final String supervisorExecutable;

  /// Creates an identity record. Most callers should use [capture] rather
  /// than constructing directly.
  ProcessIdentity({
    required this.pid,
    required this.executable,
    required this.dataDir,
    required this.startedAt,
    required this.supervisorPid,
    required this.supervisorExecutable,
  });

  /// Captures the identity of a freshly spawned [Process] for [executable]
  /// against [dataDir].
  factory ProcessIdentity.capture({
    required Process process,
    required String executable,
    required Directory dataDir,
  }) {
    return ProcessIdentity(
      pid: process.pid,
      executable: p.absolute(executable),
      dataDir: p.absolute(dataDir.path),
      startedAt: DateTime.now().toUtc(),
      supervisorPid: _currentProcessPid(),
      supervisorExecutable: p.absolute(Platform.resolvedExecutable),
    );
  }

  /// JSON representation written to the pidfile.
  Map<String, Object?> toJson() => {
    'pid': pid,
    'executable': executable,
    'dataDir': dataDir,
    'startedAt': startedAt.toIso8601String(),
    'supervisorPid': supervisorPid,
    'supervisorExecutable': supervisorExecutable,
  };

  /// Inverse of [toJson]; throws [FormatException] if any required field
  /// is missing or malformed.
  factory ProcessIdentity.fromJson(Map<String, Object?> json) {
    var pid = json['pid'];
    var exe = json['executable'];
    var data = json['dataDir'];
    var started = json['startedAt'];
    var supervisorPid = json['supervisorPid'];
    var supervisorExecutable = json['supervisorExecutable'];
    if (pid is! int ||
        exe is! String ||
        data is! String ||
        started is! String ||
        supervisorPid is! int ||
        supervisorExecutable is! String) {
      throw const FormatException('malformed ProcessIdentity JSON');
    }
    return ProcessIdentity(
      pid: pid,
      executable: exe,
      dataDir: data,
      startedAt: DateTime.parse(started),
      supervisorPid: supervisorPid,
      supervisorExecutable: supervisorExecutable,
    );
  }

  /// Atomically writes [identity] to [pidFile] (write `.tmp`, then rename).
  static void writeAtomic(File pidFile, ProcessIdentity identity) {
    var tmp = File('${pidFile.path}.tmp');
    tmp.parent.createSync(recursive: true);
    tmp.writeAsStringSync(jsonEncode(identity.toJson()));
    tmp.renameSync(pidFile.path);
  }

  /// Returns the identity recorded in [pidFile], or null if the file is
  /// missing or unreadable.
  static ProcessIdentity? read(File pidFile) {
    if (!pidFile.existsSync()) return null;
    try {
      var raw = jsonDecode(pidFile.readAsStringSync());
      if (raw is! Map) return null;
      return ProcessIdentity.fromJson(raw.cast<String, Object?>());
    } on FormatException {
      return null;
    }
  }
}

/// Result of comparing a recorded [ProcessIdentity] against the live
/// process at the same PID.
enum IdentityMatch {
  /// PID isn't a live process. Pidfile is stale; safe to remove.
  notRunning,

  /// PID is alive AND its argv matches our expected postmaster against
  /// the same PGDATA. Safe to reuse / safe to signal.
  matchesOurs,

  /// PID is alive but argv doesn't match - the OS has recycled the PID
  /// to a foreign process. We must NEVER signal it.
  foreign,
}

/// Relationship between a recorded postmaster and the Dart supervisor that
/// originally spawned it.
enum SupervisorRelationship {
  /// The postmaster is still parented by the recorded supervisor process.
  attached,

  /// The postmaster still matches our recorded identity, but its original
  /// Dart supervisor is gone and it has been reparented.
  orphaned,

  /// There isn't enough trustworthy information to decide.
  indeterminate,
}

/// Whether OS-level checks report [pid] as a running process.
///
/// Used by stale-lock repair and [verifyIdentity]. Semantics match
/// `kill(pid, 0)` on POSIX via `ps`; see [_isProcessAlive] implementation.
bool processPidIsLive(int pid) => _isProcessAlive(pid);

/// Verifies the live process at [identity.pid] is the postmaster we
/// originally started.
///
/// On POSIX, `ps -p <pid> -o args=` is queried and matched against the
/// expected `<executable> -D <dataDir>` argv. Windows is handled by
/// [_isProcessAlive] returning `notRunning` when the process can't be
/// signalled, plus a host-specific identity check in phase 9 (FFI to
/// `QueryFullProcessImageName`).
IdentityMatch verifyIdentity(ProcessIdentity identity) {
  if (!_isProcessAlive(identity.pid)) return IdentityMatch.notRunning;

  if (Platform.isWindows) {
    // Phase 9 will replace this with QueryFullProcessImageName via FFI.
    // For now treat alive Windows processes as foreign so we never accidentally
    // signal the wrong one.
    return IdentityMatch.foreign;
  }

  if (_livePosixProcessMatches(
    identity.pid,
    executable: identity.executable,
    dataDir: identity.dataDir,
  )) {
    return IdentityMatch.matchesOurs;
  }
  return IdentityMatch.foreign;
}

/// Whether the live postmaster still belongs to the Dart supervisor that
/// originally spawned it.
///
/// Returns [SupervisorRelationship.orphaned] only when the postmaster still
/// matches [identity], its current parent PID no longer matches the recorded
/// supervisor, and the recorded supervisor no longer looks alive.
SupervisorRelationship verifySupervisorRelationship(ProcessIdentity identity) {
  if (Platform.isWindows) return SupervisorRelationship.indeterminate;
  if (verifyIdentity(identity) != IdentityMatch.matchesOurs) {
    return SupervisorRelationship.indeterminate;
  }

  var parentPid = readPosixParentPid(identity.pid);
  if (parentPid == null) return SupervisorRelationship.indeterminate;
  if (parentPid == identity.supervisorPid) {
    return SupervisorRelationship.attached;
  }

  if (_isRecordedSupervisorStillAlive(
    supervisorPid: identity.supervisorPid,
    supervisorExecutable: identity.supervisorExecutable,
  )) {
    return SupervisorRelationship.indeterminate;
  }

  return SupervisorRelationship.orphaned;
}

bool _isProcessAlive(int pid) {
  if (Platform.isWindows) {
    // tasklist with a filter is cross-Windows; for phase 4 we just say
    // "alive if tasklist lists it" and refine in phase 9.
    var result = Process.runSync(
      'tasklist',
      ['/FI', 'PID eq $pid', '/NH'],
    );
    return result.exitCode == 0 && result.stdout.toString().contains('$pid');
  }
  // POSIX: kill(pid, 0) returns 0 for alive (& signalable), -1 with EPERM
  // for alive but not ours, -1 with ESRCH for not alive. Dart's
  // Process.killPid maps to kill(2); a `false` return is unreliable for
  // distinguishing the two errno cases, so we shell out to `ps` instead.
  var result = Process.runSync('ps', ['-p', '$pid']);
  return result.exitCode == 0;
}

/// Parent PID for [pid] (POSIX), or null if unavailable.
int? readPosixParentPid(int pid) => _readPosixParentPid(pid);

bool _isRecordedSupervisorStillAlive({
  required int supervisorPid,
  required String supervisorExecutable,
}) {
  if (!_isProcessAlive(supervisorPid)) return false;
  return _livePosixProcessMatchesExecutable(
    supervisorPid,
    executable: supervisorExecutable,
  );
}

bool _livePosixProcessMatches(
  int pid, {
  required String executable,
  required String dataDir,
}) {
  var argv = _readPosixArgv(pid);
  if (argv == null || argv.isEmpty) return false;
  return _argvContainsExecutable(argv, executable) &&
      _argvContainsDataDir(argv, dataDir);
}

bool _livePosixProcessMatchesExecutable(
  int pid, {
  required String executable,
}) {
  var argv = _readPosixArgv(pid);
  if (argv == null || argv.isEmpty) return false;
  return _argvContainsExecutable(argv, executable);
}

bool _argvContainsExecutable(List<String> argv, String executable) {
  var expected = _normalizedPathForms(executable);
  var expectedBasename = p.basename(executable);
  for (var arg in argv) {
    if (_normalizedPathForms(arg).intersection(expected).isNotEmpty) {
      return true;
    }
    if (p.basename(arg) == expectedBasename) {
      return true;
    }
  }
  return false;
}

bool _argvContainsDataDir(List<String> argv, String dataDir) {
  var expected = _normalizedPathForms(dataDir);
  for (var i = 0; i < argv.length; i++) {
    var arg = argv[i];
    if (arg == '-D' && i + 1 < argv.length) {
      if (_normalizedPathForms(argv[i + 1]).intersection(expected).isNotEmpty) {
        return true;
      }
      continue;
    }

    if (!arg.startsWith('-D') || arg.length <= 2) continue;
    if (_normalizedPathForms(
      arg.substring(2),
    ).intersection(expected).isNotEmpty) {
      return true;
    }
  }
  return false;
}

Set<String> _normalizedPathForms(String path) {
  var forms = <String>{};
  var absolute = p.normalize(p.absolute(path));
  forms.add(absolute);

  try {
    FileSystemEntity entity;
    if (Directory(path).existsSync()) {
      entity = Directory(path);
    } else {
      entity = File(path);
    }
    forms.add(p.normalize(entity.resolveSymbolicLinksSync()));
  } on FileSystemException {
    // Path may not exist or may not be readable; absolute normalized form is
    // still useful.
  }

  return forms;
}

List<String>? _readPosixArgv(int pid) {
  if (Platform.isLinux) {
    var f = File('/proc/$pid/cmdline');
    if (!f.existsSync()) return null;
    var raw = f.readAsBytesSync();
    if (raw.isEmpty) return null;
    return utf8
        .decode(raw, allowMalformed: true)
        .split('\x00')
        .where((token) => token.isNotEmpty)
        .toList();
  }

  var result = Process.runSync('ps', ['-p', '$pid', '-o', 'args=']);
  if (result.exitCode != 0) return null;
  var out = (result.stdout as String).trim();
  if (out.isEmpty) return null;
  return out.split(RegExp(r'\s+'));
}

int? _readPosixParentPid(int pid) {
  if (Platform.isLinux) {
    var status = File('/proc/$pid/status');
    if (!status.existsSync()) return null;
    try {
      for (var line in status.readAsLinesSync()) {
        if (!line.startsWith('PPid:')) continue;
        return int.tryParse(line.substring(5).trim());
      }
    } on FileSystemException {
      return null;
    }
    return null;
  }

  var result = Process.runSync('ps', ['-p', '$pid', '-o', 'ppid=']);
  if (result.exitCode != 0) return null;
  return int.tryParse((result.stdout as String).trim());
}

int _currentProcessPid() => pid;

/// PostgreSQL writes the postmaster PID on the first whitespace-delimited
/// token of [postmasterPidFile]'s first line. Returns null when the file is
/// missing, empty, or unparseable.
int? readPostmasterPidFile(File postmasterPidFile) {
  List<String> lines;
  try {
    lines = postmasterPidFile.readAsLinesSync();
  } on FileSystemException {
    return null;
  }
  if (lines.isEmpty) return null;
  return int.tryParse(lines.first.trim().split(RegExp(r'\s+')).first);
}

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/process_io.dart';

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

/// Verifies the live process at [identity.pid] is the postmaster we
/// originally started.
///
/// POSIX (Linux/macOS): argv-matched against the expected
/// `<executable> -D <dataDir>` form. Windows: exe-path equality via
/// [readProcessExecutable]; no dataDir check because reading another
/// process's command line on Windows requires PEB reading.
IdentityMatch verifyIdentity(ProcessIdentity identity) {
  if (!isProcessAlive(identity.pid)) return IdentityMatch.notRunning;

  if (Platform.isWindows) {
    var exe = readProcessExecutable(identity.pid);
    if (exe != null && p.equals(exe, identity.executable)) {
      return IdentityMatch.matchesOurs;
    }
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

/// Whether the live process at [identity.pid] is OUR postmaster AND its
/// recorded supervisor is no longer alive (i.e. an orphan we may reclaim).
///
/// Conservative on the supervisor check: if [isProcessAlive] reports the
/// supervisor PID as live - which on a long-running host may be because the
/// PID was recycled to some foreign process - this returns `false` and the
/// caller leaves the postmaster alone. Killing the wrong process is a much
/// worse failure mode than leaving an orphan the user can manually clean.
bool isPostmasterOrphan(ProcessIdentity identity) {
  return verifyIdentity(identity) == IdentityMatch.matchesOurs &&
      !isProcessAlive(identity.supervisorPid);
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

bool _argvContainsExecutable(List<String> argv, String executable) {
  var basename = p.basename(executable);
  return argv.any((arg) => arg == executable || p.basename(arg) == basename);
}

bool _argvContainsDataDir(List<String> argv, String dataDir) {
  for (var i = 0; i < argv.length; i++) {
    var arg = argv[i];
    if (arg == '-D' && i + 1 < argv.length && argv[i + 1] == dataDir) {
      return true;
    }
    if (arg.startsWith('-D') && arg.length > 2 && arg.substring(2) == dataDir) {
      return true;
    }
  }
  return false;
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

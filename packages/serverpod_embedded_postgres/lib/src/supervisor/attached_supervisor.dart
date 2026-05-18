import 'dart:async';
import 'dart:io';

import 'process_identity.dart';
import 'supervised_process.dart';

/// SupervisedProcess backed only by a recorded ProcessIdentity, used when
/// reattaching to a postmaster started by a previous Dart VM run with
/// `detach: true`.
///
/// We don't have the original [Process] handle (it died with the previous
/// VM), so we signal via [Process.killPid] and detect liveness via
/// [verifyIdentity]. Log tail is read from the persisted log file rather
/// than streamed from stdout/stderr.
class AttachedSupervisor implements SupervisedProcess {
  /// Identity recorded in the pidfile by the supervisor that originally
  /// spawned this postmaster.
  final ProcessIdentity identity;

  final File _pidFile;
  final File _logFile;

  Future<void>? _stopFuture;

  AttachedSupervisor._({
    required this.identity,
    required File pidFile,
    required File logFile,
  }) : _pidFile = pidFile,
       _logFile = logFile;

  /// Reads [pidFile] and returns an [AttachedSupervisor] if the recorded
  /// PID is alive AND its argv matches our postmaster (verified via
  /// `ps -p <pid> -o args=` or `/proc/<pid>/cmdline`).
  ///
  /// Returns null when:
  ///   - the pidfile is absent or unreadable;
  ///   - the recorded PID is not alive (the pidfile is removed in this
  ///     case to ease the next start);
  ///   - the recorded PID is alive but argv doesn't match (PID was
  ///     recycled by the OS and is now a foreign process - we never
  ///     touch it).
  static AttachedSupervisor? tryAttach({
    required File pidFile,
    required File logFile,
  }) {
    var identity = ProcessIdentity.read(pidFile);
    if (identity == null) return null;

    var match = verifyIdentity(identity);
    switch (match) {
      case IdentityMatch.notRunning:
        if (pidFile.existsSync()) {
          try {
            pidFile.deleteSync();
          } on FileSystemException {
            // Best-effort cleanup; non-fatal.
          }
        }
        return null;
      case IdentityMatch.foreign:
        return null;
      case IdentityMatch.matchesOurs:
        return AttachedSupervisor._(
          identity: identity,
          pidFile: pidFile,
          logFile: logFile,
        );
    }
  }

  @override
  int? get pid => _stopFuture != null ? null : identity.pid;

  @override
  bool get isRunning {
    if (_stopFuture != null) return false;
    return verifyIdentity(identity) == IdentityMatch.matchesOurs;
  }

  @override
  List<String> get logTail {
    if (!_logFile.existsSync()) return const [];
    try {
      var lines = _logFile.readAsLinesSync();
      return lines.length > 200 ? lines.sublist(lines.length - 200) : lines;
    } on FileSystemException {
      return const [];
    }
  }

  @override
  Future<void> stop({Duration timeout = const Duration(seconds: 10)}) =>
      _stopFuture ??= _stop(timeout);

  Future<void> _stop(Duration timeout) async {
    Process.killPid(identity.pid, ProcessSignal.sigint);

    var halfway = timeout ~/ 2;
    var stopped = await _waitForExit(deadline: halfway);
    if (!stopped) {
      Process.killPid(identity.pid, ProcessSignal.sigterm);
      stopped = await _waitForExit(deadline: timeout - halfway);
      if (!stopped) {
        Process.killPid(identity.pid, ProcessSignal.sigkill);
        await _waitForExit(deadline: const Duration(seconds: 5));
      }
    }

    if (_pidFile.existsSync()) {
      try {
        _pidFile.deleteSync();
      } on FileSystemException {
        // Best-effort.
      }
    }
  }

  Future<bool> _waitForExit({required Duration deadline}) async {
    var until = DateTime.now().add(deadline);
    while (DateTime.now().isBefore(until)) {
      if (verifyIdentity(identity) != IdentityMatch.matchesOurs) {
        return true;
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    return verifyIdentity(identity) != IdentityMatch.matchesOurs;
  }
}

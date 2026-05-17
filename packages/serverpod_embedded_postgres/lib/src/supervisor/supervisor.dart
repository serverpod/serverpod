import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../exceptions.dart';
import '../transport.dart';
import 'log_buffer.dart';
import 'process_identity.dart';
import 'supervised_process.dart';

/// Owns a running `postgres` process: spawning it, tailing its log,
/// detecting ready, escalating shutdown signals, and persisting an
/// identity record so a later attach can verify the process is still ours.
///
/// Constructed only via [start] (fresh boot) or [tryAttach] (reattach to
/// an already-running postmaster from a `detach: true` previous run).
class Supervisor implements SupervisedProcess {
  final Process _process;

  /// Captured at spawn time and persisted to the pidfile. Used by
  /// [tryAttach] to verify a future caller is reattaching to the same
  /// postmaster (and not a PID-recycled foreign process).
  final ProcessIdentity identity;
  final File _pidFile;
  final LogBuffer _ring;
  final IOSink _logSink;
  final List<StreamSubscription<ProcessSignal>> _signalSubs;
  final Completer<int> _exitCompleter = Completer();

  Future<void>? _stopFuture;

  Supervisor._({
    required Process process,
    required this.identity,
    required File pidFile,
    required LogBuffer ring,
    required IOSink logSink,
    required List<StreamSubscription<ProcessSignal>> signalSubs,
  }) : _process = process,
       _pidFile = pidFile,
       _ring = ring,
       _logSink = logSink,
       _signalSubs = signalSubs {
    unawaited(_process.exitCode.then(_exitCompleter.complete));
  }

  /// PID of the running postmaster, or null once [stop] has been called.
  @override
  int? get pid => _stopFuture != null ? null : _process.pid;

  /// True between [start] and [stop].
  @override
  bool get isRunning => _stopFuture == null && !_exitCompleter.isCompleted;

  /// Captured tail of the postmaster's stdout + stderr (most recent first
  /// 200 lines, per the spec).
  @override
  List<String> get logTail => _ring.snapshot();

  /// Spawns `<installDir>/bin/postgres -D <dataDir>` and waits for the
  /// postmaster to become ready (socket accepts connections for UDS, port
  /// accepts TCP connections for TCP).
  ///
  /// Throws [StartupTimeoutException] if [startTimeout] elapses without
  /// readiness, or [CrashedException] if the postmaster exits before
  /// becoming ready.
  static Future<Supervisor> start({
    required Directory installDir,
    required Directory dataDir,
    required Directory runDir,
    required Transport transport,
    required Duration startTimeout,
    required File pidFile,
    required File logFile,
    required bool detach,
  }) async {
    var executable = p.join(installDir.path, 'bin', 'postgres');

    _rotateLog(logFile);
    var ring = LogBuffer();
    var logSink = logFile.openWrite(mode: FileMode.append);
    logSink.writeln(
      '\n=== supervisor start @ ${DateTime.now().toIso8601String()} ===',
    );

    var process = await Process.start(
      executable,
      ['-D', dataDir.path],
      mode: ProcessStartMode.normal,
    );

    void handleLine(String line) {
      logSink.writeln(line);
      ring.add(line);
    }

    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(handleLine);
    process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(handleLine);

    var identity = ProcessIdentity.capture(
      process: process,
      executable: executable,
      dataDir: dataDir,
    );
    ProcessIdentity.writeAtomic(pidFile, identity);

    var signalSubs = <StreamSubscription<ProcessSignal>>[];
    var supervisor = Supervisor._(
      process: process,
      identity: identity,
      pidFile: pidFile,
      ring: ring,
      logSink: logSink,
      signalSubs: signalSubs,
    );

    if (!detach) {
      void hookSignal(ProcessSignal sig) {
        signalSubs.add(
          sig.watch().listen((_) async {
            await supervisor.stop();
            exit(128 + (sig == ProcessSignal.sigint ? 2 : 15));
          }),
        );
      }

      hookSignal(ProcessSignal.sigint);
      if (!Platform.isWindows) {
        hookSignal(ProcessSignal.sigterm);
      }
    }

    try {
      await _waitForReady(supervisor: supervisor, timeout: startTimeout);
    } catch (_) {
      // Best-effort cleanup so a failed start doesn't leave a postmaster
      // running and an inconsistent pidfile around.
      await supervisor.stop().catchError((_) {});
      rethrow;
    }

    return supervisor;
  }

  /// Smart shutdown of the postmaster:
  ///   1. SIGINT (PG fast smart-shutdown).
  ///   2. After [timeout]/2, SIGTERM (immediate fast-shutdown).
  ///   3. After [timeout], SIGKILL (last resort).
  ///
  /// Removes the pidfile and closes the log sink. Idempotent: subsequent
  /// callers share the first call's future and only return once the
  /// underlying work is fully done.
  @override
  Future<void> stop({Duration timeout = const Duration(seconds: 10)}) =>
      _stopFuture ??= _stop(timeout);

  Future<void> _stop(Duration timeout) async {
    for (var sub in _signalSubs) {
      await sub.cancel();
    }

    if (!_exitCompleter.isCompleted) {
      _process.kill(ProcessSignal.sigint);
    }

    var halfway = timeout ~/ 2;
    var firstWait = await _waitWithDeadline(_exitCompleter.future, halfway);
    if (firstWait == null && !_exitCompleter.isCompleted) {
      _process.kill(ProcessSignal.sigterm);
      var secondWait = await _waitWithDeadline(
        _exitCompleter.future,
        timeout - halfway,
      );
      if (secondWait == null && !_exitCompleter.isCompleted) {
        _process.kill(ProcessSignal.sigkill);
        await _exitCompleter.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () => -1,
        );
      }
    }

    if (_pidFile.existsSync()) {
      try {
        _pidFile.deleteSync();
      } on FileSystemException {
        // Best-effort; concurrent supervisor on the same dataDir is the
        // user's problem (they got the orphan-detection mismatch already).
      }
    }
    await _logSink.flush();
    await _logSink.close();
  }
}

void _rotateLog(File logFile) {
  if (!logFile.existsSync()) return;
  var rotated = File('${logFile.path}.1');
  if (rotated.existsSync()) rotated.deleteSync();
  logFile.renameSync(rotated.path);
}

Future<T?> _waitWithDeadline<T>(Future<T> future, Duration deadline) async {
  try {
    return await future.timeout(deadline);
  } on TimeoutException {
    return null;
  }
}

/// Polls for postmaster readiness at 50ms intervals up to [timeout]. Throws
/// [StartupTimeoutException] / [CrashedException] from the supervisor's
/// log tail.
Future<void> _waitForReady({
  required Supervisor supervisor,
  required Duration timeout,
}) async {
  var deadline = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(deadline)) {
    if (supervisor._exitCompleter.isCompleted) {
      var code = await supervisor._exitCompleter.future;
      // Race window: another postmaster grabbed the lock between our
      // pre-spawn check and this child's startup. PG's own message is
      // localised, so the grep is best-effort - but converging on a typed
      // exception here keeps callers off the log text.
      if (_logTailIndicatesLockBusy(supervisor.logTail)) {
        throw const PostmasterLockBusyException(
          'postmaster.pid was acquired by another process between '
          'pre-spawn check and supervisor start.',
        );
      }
      throw CrashedException(
        'postgres exited with code $code before becoming ready.',
        code,
        supervisor.logTail,
      );
    }

    if (_isReady(supervisor)) return;

    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  throw StartupTimeoutException(
    'postgres did not become ready within ${timeout.inSeconds}s.',
    supervisor.logTail,
  );
}

/// Postmaster readiness: scan the captured log tail for PG's own
/// declaration that it's ready to accept connections.
///
/// We do NOT use "can I open a TCP/UDS socket" - PG opens its listen
/// socket EARLY in startup, well before it's actually ready to serve
/// queries. Connecting in that window returns SQLSTATE 57P03
/// ("the database system is starting up"), which the caller's first
/// query (or our own _ensureDatabase / CREATE DATABASE) hits as a
/// non-retryable error.
///
/// PG emits the trigger line at the end of startup, after WAL replay
/// and before the postmaster starts accepting client backends. The
/// exact phrase has been stable across PG 9.x through current; we
/// substring-match to tolerate locale and severity-prefix variations
/// (e.g. `LOG:  database system is ready to accept connections`).
bool _isReady(Supervisor supervisor) {
  for (var line in supervisor.logTail) {
    if (line.contains('database system is ready to accept connections')) {
      return true;
    }
  }
  return false;
}

/// Heuristic for the PG-side "another postmaster owns this PGDATA" failure.
/// Localised by PG itself, so this is best-effort; the en_US phrase has
/// been stable across modern PG versions. Used only as a race-window
/// fallback for the precheck in `EmbeddedPostgresImpl.start`.
bool _logTailIndicatesLockBusy(List<String> logTail) {
  for (var line in logTail) {
    var lower = line.toLowerCase();
    if (lower.contains('postmaster.pid') && lower.contains('already exists')) {
      return true;
    }
  }
  return false;
}

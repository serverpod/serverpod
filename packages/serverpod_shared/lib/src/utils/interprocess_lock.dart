import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'process_alive.dart';

/// A cross-process, cross-isolate advisory lock backed by an atomically
/// created lock file (`O_CREAT | O_EXCL`).
///
/// Unlike `RandomAccessFile.lock`, whose POSIX advisory locks are owned per
/// process (so several isolates in one process all acquire the "exclusive"
/// lock), the lock file's existence *is* the lock, owned by whoever creates it
/// first. It therefore serializes separate processes and sibling isolates
/// uniformly - the case that matters when `dart test` runs suites as isolates
/// sharing one process.
///
/// An abandoned lock is reclaimed per [StaleLockPolicy]. The file holds a
/// unique per-acquisition token, so reclaim and [release] only ever delete the
/// lock they actually hold, never one a different acquirer has since taken.
class InterProcessLock {
  InterProcessLock._(this._file, this._token);

  final File _file;
  final String _token;
  Timer? _heartbeat;

  static int _tokenCounter = 0;
  static final Random _tokenRandom = Random();

  /// A token unique to this acquisition across isolates and processes: the PID
  /// (parsed back out by [StaleLockPolicy.processLiveness]) plus a random nonce
  /// and a per-isolate counter to distinguish sibling isolates sharing the PID.
  static String _mintToken() =>
      '$pid:${_tokenRandom.nextInt(1 << 32)}:${_tokenCounter++}';

  /// Acquires the lock at [path], blocking until it is held.
  ///
  /// Polls a held lock from [pollInterval], doubling up to [maxPollInterval].
  /// If [heartbeatInterval] is set, the file's modified time is refreshed while
  /// the lock is held so [StaleLockPolicy.age] backstops measure idle time, not
  /// time spent doing the guarded work.
  ///
  /// Throws [TimeoutException] if the lock cannot be acquired within [timeout].
  static Future<InterProcessLock> acquire(
    String path, {
    required StaleLockPolicy staleWhen,
    Duration timeout = const Duration(minutes: 6),
    Duration pollInterval = const Duration(milliseconds: 50),
    Duration maxPollInterval = const Duration(seconds: 1),
    Duration? heartbeatInterval,
  }) async {
    final file = File(path);
    final token = _mintToken();
    final elapsed = Stopwatch()..start();

    // Backoff doubles from pollInterval up to maxPollInterval while waiting.
    var backoff = pollInterval;
    while (true) {
      try {
        file.createSync(exclusive: true);
        file.writeAsStringSync(token);
        final lock = InterProcessLock._(file, token);
        if (heartbeatInterval != null) lock._startHeartbeat(heartbeatInterval);
        return lock;
      } on FileSystemException {
        // Read once so the staleness check and the reclaim target the same lock.
        final observed = _readOrEmpty(file);
        if (_isStale(file, observed, staleWhen)) {
          _tryDeleteIfMatches(file, observed);
          continue;
        }
        if (elapsed.elapsed > timeout) {
          throw TimeoutException(
            'Timed out acquiring the lock at ${file.path}',
            timeout,
          );
        }
        await Future<void>.delayed(backoff);
        backoff = Duration(
          microseconds: min(
            backoff.inMicroseconds * 2,
            maxPollInterval.inMicroseconds,
          ),
        );
      }
    }
  }

  /// Acquires the lock at [path], runs [action], and releases it afterwards
  /// (even if [action] throws). See [acquire] for the parameters.
  static Future<T> withLock<T>(
    String path,
    Future<T> Function() action, {
    required StaleLockPolicy staleWhen,
    Duration timeout = const Duration(minutes: 6),
    Duration pollInterval = const Duration(milliseconds: 50),
    Duration maxPollInterval = const Duration(seconds: 1),
    Duration? heartbeatInterval,
  }) async {
    final lock = await acquire(
      path,
      staleWhen: staleWhen,
      timeout: timeout,
      pollInterval: pollInterval,
      maxPollInterval: maxPollInterval,
      heartbeatInterval: heartbeatInterval,
    );
    try {
      return await action();
    } finally {
      await lock.release();
    }
  }

  /// Releases the lock. Safe to call more than once. Only removes the file if
  /// it still holds our token, so a lock another acquirer has since reclaimed
  /// is never deleted out from under them.
  Future<void> release() async {
    _heartbeat?.cancel();
    _heartbeat = null;
    _tryDeleteIfMatches(_file, _token);
  }

  /// Refreshes the lock file's modified time on an interval so a live holder is
  /// never mistaken for a leaked one by an age-based [StaleLockPolicy]. Guarded
  /// work awaits async I/O, so the isolate's event loop is free to fire this.
  void _startHeartbeat(Duration interval) {
    _heartbeat = Timer.periodic(interval, (_) {
      try {
        _file.setLastModifiedSync(DateTime.now());
      } on FileSystemException {
        // File is gone (reclaimed or released); stop heartbeating.
        _heartbeat?.cancel();
        _heartbeat = null;
      }
    });
  }

  static bool _isStale(File file, String observed, StaleLockPolicy policy) {
    final FileStat stat;
    try {
      stat = file.statSync();
    } on FileSystemException {
      return false;
    }
    if (stat.type == FileSystemEntityType.notFound) return false;
    return policy.isStale(stat, observed);
  }

  static String _readOrEmpty(File file) {
    try {
      return file.readAsStringSync();
    } on FileSystemException {
      return '';
    }
  }

  /// Deletes [file] only if its current content still equals [expected], so a
  /// lock reclaimed and re-taken (different token) is left untouched.
  static void _tryDeleteIfMatches(File file, String expected) {
    try {
      if (!file.existsSync()) return;
      if (file.readAsStringSync() != expected) return;
      file.deleteSync();
    } on FileSystemException {
      // Lost a race to read/delete; nothing to do.
    }
  }
}

/// Decides whether a waiter may reclaim an existing [InterProcessLock] file
/// whose holder appears to have abandoned it.
abstract interface class StaleLockPolicy {
  /// Reclaims a lock whose recorded process is dead, with an age backstop for a
  /// holder that leaked the lock while its process stayed alive (e.g. a hung
  /// sibling isolate sharing the PID). Pair with [InterProcessLock.acquire]'s
  /// `heartbeatInterval` so the backstop measures idle time, not work time.
  const factory StaleLockPolicy.processLiveness({
    required Duration staleAfter,
  }) = _ProcessLivenessPolicy;

  /// Reclaims once the lock file's modified time is older than [staleAfter].
  ///
  /// Dart reads mtime back at whole-second resolution (dart-lang/sdk#51937), so
  /// [staleAfter] should stay comfortably above one second.
  const factory StaleLockPolicy.age(Duration staleAfter) = _AgePolicy;

  /// Never reclaims; the caller guarantees the holder finishes or fails fast.
  const factory StaleLockPolicy.never() = _NeverPolicy;

  /// Whether the lock with the given [stat] and file [content] is abandoned.
  bool isStale(FileStat stat, String content);
}

class _ProcessLivenessPolicy implements StaleLockPolicy {
  const _ProcessLivenessPolicy({required this.staleAfter});

  final Duration staleAfter;

  @override
  bool isStale(FileStat stat, String content) {
    final holderPid = int.tryParse(content.split(':').first.trim());
    if (holderPid != null && !isProcessAlive(holderPid)) return true;
    return DateTime.now().difference(stat.modified) > staleAfter;
  }
}

class _AgePolicy implements StaleLockPolicy {
  const _AgePolicy(this.staleAfter);

  final Duration staleAfter;

  @override
  bool isStale(FileStat stat, String content) =>
      DateTime.now().difference(stat.modified) > staleAfter;
}

class _NeverPolicy implements StaleLockPolicy {
  const _NeverPolicy();

  @override
  bool isStale(FileStat stat, String content) => false;
}

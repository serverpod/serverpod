import 'dart:io';

import 'package:serverpod_cli/src/runner/runner_paths.dart';

/// Thrown when a runner is already holding the lock for a server package.
class RunnerLockedException implements Exception {
  const RunnerLockedException(this.lockPath);

  final String lockPath;

  @override
  String toString() =>
      'Another serverpod runner is already running for this server package '
      '(lock: $lockPath).';
}

/// The exclusive advisory lock that admits one runner per server package.
///
/// On Linux and macOS, closing any descriptor for the file drops the lock, so
/// the runner process must never call [isHeld].
class RunnerLock {
  RunnerLock._(this._file, this.lockPath);

  final RandomAccessFile _file;

  final String lockPath;

  bool _released = false;

  /// Takes the lock for [serverDir], or throws [RunnerLockedException] at once.
  static Future<RunnerLock> acquire(String serverDir) async {
    final lockPath = serverpodRunnerLockPath(serverDir);
    final file = File(lockPath);
    await file.parent.create(recursive: true);

    final handle = await file.open(mode: FileMode.writeOnlyAppend);
    try {
      await handle.lock(FileLock.exclusive);
    } on FileSystemException {
      await handle.close();
      throw RunnerLockedException(lockPath);
    }
    return RunnerLock._(handle, lockPath);
  }

  /// Whether a runner holds the lock, taking and releasing it when free.
  static Future<bool> isHeld(String serverDir) async {
    final RunnerLock probe;
    try {
      probe = await acquire(serverDir);
    } on RunnerLockedException {
      return true;
    }
    await probe.release();
    return false;
  }

  /// Releases the lock and closes the file, idempotently.
  Future<void> release() async {
    if (_released) return;
    _released = true;
    try {
      await _file.unlock();
    } on FileSystemException {
      // Already unlocked, or the file is gone.
    }
    await _file.close();
  }
}

import 'dart:io';

import 'package:path/path.dart' as p;

/// Cross-process exclusive lock on the binary cache root.
///
/// Two parallel `serverpod_cli start` invocations on the same machine must
/// not race each other into the same `<cache>/<bom>/<platform>/` extract -
/// the partial-extract scenario produces a half-populated install dir that
/// later runs would then "cache hit" and try to use.
///
/// Backed by `RandomAccessFile.lock`, which maps to `flock(2)` on POSIX
/// and `LockFileEx` on Windows. Holds for the lifetime of the [CacheLock]
/// handle until [release] is called (or [withLock] unwinds).
class CacheLock {
  final RandomAccessFile _raf;

  CacheLock._(this._raf);

  /// Acquires an exclusive lock at `<cacheRoot>/.lock`. Creates [cacheRoot]
  /// if missing. Blocks the calling isolate until the lock can be taken.
  static Future<CacheLock> acquire(Directory cacheRoot) async {
    cacheRoot.createSync(recursive: true);
    var lockFile = File(p.join(cacheRoot.path, '.lock'));
    var raf = await lockFile.open(mode: FileMode.write);
    try {
      await raf.lock(FileLock.blockingExclusive);
    } catch (_) {
      await raf.close();
      rethrow;
    }
    return CacheLock._(raf);
  }

  bool _released = false;

  /// Releases the lock. Idempotent; safe to call after [withLock] has
  /// already unwound the holder.
  Future<void> release() async {
    if (_released) return;
    _released = true;
    try {
      await _raf.unlock();
    } finally {
      await _raf.close();
    }
  }

  /// Acquires the lock, runs [action], releases it - including on error.
  ///
  /// Most callers want this rather than the lower-level [acquire] /
  /// [release] pair.
  static Future<T> withLock<T>(
    Directory cacheRoot,
    Future<T> Function() action,
  ) async {
    var lock = await acquire(cacheRoot);
    try {
      return await action();
    } finally {
      await lock.release();
    }
  }
}

import '../utils/isolated_object.dart';
import 'log_types.dart';

/// A [LogWriter] that wraps any [LogWriter] in a dedicated isolate.
///
/// This ensures that timer-driven animations (e.g. progress spinners) keep
/// updating even when the calling isolate's event loop is blocked by heavy
/// synchronous work.
///
/// All operations are forwarded to the isolate and awaited; the caller
/// chooses whether to await the returned future.
class IsolatedLogWriter extends IsolatedObject<LogWriter> implements LogWriter {
  final Set<Future<void>> _inflight = {};

  /// Creates an [IsolatedLogWriter] that runs the writer produced by
  /// [factory] on a dedicated isolate.
  IsolatedLogWriter(super.factory);

  @override
  Future<void> log(LogEntry entry) async {
    if (isClosed) return;
    final Future<void> f = evaluate((w) => w.log(entry));
    _inflight.add(f);
    try {
      await f;
    } finally {
      _inflight.remove(f);
    }
  }

  @override
  Future<void> close() async {
    // Drain in-flight log writes before tearing the isolate down, so
    // fire-and-forget callers (Log.call does not await the returned
    // Future) do not see their pending writes reject with StateError
    // from [IsolatedObject.close].
    await _inflight.wait;
    await super.close();
  }

  @override
  Future<void> openScope(LogScope scope) async {
    await evaluate((w) => w.openScope(scope));
  }

  @override
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    await evaluate(
      (w) => w.closeScope(
        scope,
        success: success,
        duration: duration,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }
}

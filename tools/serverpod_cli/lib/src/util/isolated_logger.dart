import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
// ignore: implementation_imports
import 'package:cli_tools/src/logger/helpers/progress.dart';

import 'isolated_object.dart';

/// A [Logger] whose output operations run in a dedicated isolate.
///
/// This ensures that timer-driven animations (like progress spinners) keep
/// updating even when the calling isolate's event loop is blocked by heavy
/// synchronous async work (e.g. the Dart analyzer).
///
/// Simple log methods fire-and-forget into the isolate. The [progress] method
/// runs the spinner in the isolate while executing the work callback in the
/// calling isolate.
final class IsolatedLogger extends IsolatedObject<StdOutLogger>
    implements Logger {
  /// Holds a reference to the active [Progress] inside the logger isolate.
  /// This is a static field so it's accessible from evaluate closures that
  /// run in the isolate. Each isolate has its own copy of static state.
  static Progress? _activeProgress;

  /// Creates an [IsolatedLogger] backed by a [StdOutLogger] in a separate
  /// isolate.
  IsolatedLogger(
    LogLevel logLevel, {
    Map<String, String>? replacements,
  }) : _logLevel = logLevel,
       super(() => StdOutLogger(logLevel, replacements: replacements));

  @override
  int? get wrapTextColumn => stdout.hasTerminal ? stdout.terminalColumns : null;

  void _voidEvaluate(void Function(StdOutLogger) function) async {
    if (isClosed) return; // ignore trace after close
    await evaluate(function);
  }

  LogLevel _logLevel;
  @override
  LogLevel get logLevel => _logLevel;
  @override
  set logLevel(LogLevel level) => _setLogLevel(level);
  void _setLogLevel(LogLevel level) async {
    await evaluate((l) => l.logLevel = level);
    _logLevel = level; // don't set until in effect
  }

  @override
  void debug(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _voidEvaluate(
      (l) => l.debug(message, newParagraph: newParagraph, type: type),
    );
  }

  @override
  void info(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _voidEvaluate(
      (l) => l.info(message, newParagraph: newParagraph, type: type),
    );
  }

  @override
  void warning(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _voidEvaluate(
      (l) => l.warning(message, newParagraph: newParagraph, type: type),
    );
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType type = TextLogType.normal,
  }) {
    _voidEvaluate(
      (l) => l.error(
        message,
        newParagraph: newParagraph,
        stackTrace: stackTrace,
        type: type,
      ),
    );
  }

  @override
  void log(
    String message,
    LogLevel level, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) {
    _voidEvaluate(
      (l) => l.log(message, level, newParagraph: newParagraph, type: type),
    );
  }

  @override
  void write(
    String message,
    LogLevel logLevel, {
    bool newParagraph = false,
    bool newLine = true,
  }) {
    _voidEvaluate(
      (l) => l.write(
        message,
        logLevel,
        newParagraph: newParagraph,
        newLine: newLine,
      ),
    );
  }

  @override
  Future<bool> progress(
    String message,
    Future<bool> Function() runner, {
    bool newParagraph = false,
  }) async {
    if (logLevel.index > LogLevel.info.index) {
      return runner();
    }

    // Start the progress spinner in the logger isolate.
    // We can't use StdOutLogger.progress directly because its runner callback
    // would need to cross the isolate boundary with a Completer (unsendable).
    // Instead, we start/complete the progress manually via two evaluate calls.
    //
    // We store the Progress in _activeProgress (a static field accessed only
    // from the isolate) so we can always complete/fail it at the end, even if
    // StdOutLogger._stopAnimationInProgress cleared trackedAnimationInProgress
    // due to an intervening log message.
    await evaluate((l) {
      _activeProgress?.complete();
      _activeProgress = null;
      l.trackedAnimationInProgress = null;
      if (newParagraph) {
        l.write('', LogLevel.info, newParagraph: false, newLine: true);
      }
      // Create a Progress directly - its Timer.periodic will run on the
      // isolate's unblocked event loop, keeping the spinner animating.
      final p = Progress(message, stdout);
      l.trackedAnimationInProgress = p;
      _activeProgress = p;
    });

    bool success = false;
    try {
      // Run the actual work in the calling isolate.
      success = await runner();
    } finally {
      // Complete or fail the progress in the logger isolate.
      // This always writes the final ✓/✗ status line, even if the spinner
      // was interrupted by other log output during the run.
      await evaluate((l) {
        l.trackedAnimationInProgress = null;
        final p = _activeProgress;
        _activeProgress = null;
        success ? p?.complete() : p?.fail();
      });
    }
    return success;
  }

  @override
  Future<void> flush() => evaluate((l) => l.flush());

  @override
  Future<void> close() async {
    scheduleMicrotask(() async {
      await flush(); // flush before close, and leave no gap!
      await super.close();
    });
  }
}

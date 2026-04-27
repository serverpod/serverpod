import 'dart:async';
import 'dart:io';

import 'log_types.dart';

const _clearLine = '\u001b[2K\r';
const _brailleFrames = '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏';

/// Whether stdout is an interactive terminal.
bool isInteractiveTerminal = stdout.hasTerminal;

/// Format a duration for display in spinner/completion lines.
String formatElapsed(Duration d) {
  final ms = d.inMilliseconds;
  if (ms < 100) return '${ms}ms';
  return '${(ms / 1000).toStringAsFixed(1)}s';
}

/// State for a single in-progress scope with a braille spinner.
class ActiveScope {
  /// Tracks [scope] and starts a stopwatch for its elapsed-time display.
  ActiveScope(this.scope) : stopwatch = Stopwatch()..start();

  /// The scope being rendered.
  final LogScope scope;

  /// Measures how long the scope has been open; read by the spinner
  /// formatter to display elapsed time next to the label.
  final Stopwatch stopwatch;
}

/// A [LogWriter] base class that manages braille progress spinners.
///
/// When stdout is a terminal, [openScope]/[closeScope] animate a spinner
/// on the last line. Log messages print above the spinner, which redraws
/// after each line.
///
/// Subclasses override [writeLogLine] to format log output and
/// [formatSpinner]/[formatScopeComplete] to customize spinner appearance.
abstract class SpinnerLogWriter extends LogWriter {
  /// Stack of currently-open scopes, innermost last. The innermost entry
  /// drives the active spinner line.
  final List<ActiveScope> scopeStack = [];
  Timer? _timer;
  int _frameIndex = 0;

  /// Write a single log entry to the terminal. Called after the spinner
  /// line has been cleared and before it is redrawn.
  void writeLogLine(LogEntry entry);

  /// Format the spinner text for the currently active scope.
  /// Default uses green braille frames with gray elapsed time.
  String formatSpinner(String frame, ActiveScope active) {
    return '$frame ${active.scope.label}... (${formatElapsed(active.stopwatch.elapsed)})';
  }

  /// Format the scope completion line.
  /// Default uses ✓/✗ with the label and elapsed time.
  String formatScopeComplete(LogScope scope, bool success, Duration duration) {
    final icon = success ? '\u2713' : '\u2717';
    return '$icon ${scope.label} (${formatElapsed(duration)})';
  }

  /// Format the scope label for non-interactive (pipe) output.
  String formatScopeStart(LogScope scope) => '${scope.label}...';

  /// Format the scope completion for non-interactive output.
  String formatScopeEnd(LogScope scope, bool success, Duration duration) {
    final status = success ? 'done' : 'failed';
    return '${scope.label} $status. (${formatElapsed(duration)})';
  }

  @override
  Future<void> log(LogEntry entry) async {
    _clearSpinnerLine();
    writeLogLine(entry);
    _drawSpinner();
  }

  @override
  Future<void> openScope(LogScope scope) async {
    if (isInteractiveTerminal) {
      _clearSpinnerLine();
      scopeStack.add(ActiveScope(scope));
      _drawSpinner();
      _startTimer();
    } else {
      stdout.writeln(formatScopeStart(scope));
    }
  }

  @override
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    if (isInteractiveTerminal) {
      _clearSpinnerLine();
      scopeStack.removeWhere((s) => s.scope.id == scope.id);
      if (scopeStack.isEmpty) _stopTimer();

      stdout.writeln(formatScopeComplete(scope, success, duration));

      _drawSpinner();
    } else {
      stdout.writeln(formatScopeEnd(scope, success, duration));
    }
  }

  void _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      _drawSpinner();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _drawSpinner() {
    if (scopeStack.isEmpty || !isInteractiveTerminal) return;
    final active = scopeStack.last;
    _frameIndex++;
    final frame = _brailleFrames[_frameIndex % _brailleFrames.length];
    stdout.write('$_clearLine${formatSpinner(frame, active)}');
  }

  void _clearSpinnerLine() {
    if (isInteractiveTerminal && scopeStack.isNotEmpty) {
      stdout.write(_clearLine);
    }
  }
}

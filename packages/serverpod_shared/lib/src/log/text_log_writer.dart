import 'dart:io';

import 'log_types.dart';
import 'spinner_log_writer.dart';

bool get _ansiSupported => isInteractiveTerminal && stdout.supportsAnsiEscapes;

String _green(String text) => _ansiSupported ? '\x1B[92m$text\x1B[0m' : text;
String _yellow(String text) => _ansiSupported ? '\x1B[93m$text\x1B[0m' : text;
String _red(String text) => _ansiSupported ? '\x1B[91m$text\x1B[0m' : text;
String _gray(String text) => _ansiSupported ? '\x1B[90m$text\x1B[0m' : text;
String _cyan(String text) => _ansiSupported ? '\x1B[36m$text\x1B[0m' : text;

/// A [SpinnerLogWriter] that writes formatted text to stdout/stderr.
///
/// Log messages are prefixed with the level (DEBUG, WARNING, ERROR).
/// Errors and stack traces are written to stderr.
class TextLogWriter extends SpinnerLogWriter {
  @override
  void writeLogLine(LogEntry entry) {
    final prefix = switch (entry.level) {
      LogLevel.debug => _gray('DEBUG: '),
      LogLevel.info => '',
      LogLevel.warning => _yellow('WARNING: '),
      LogLevel.error || LogLevel.fatal => _red('ERROR: '),
    };
    final output = '$prefix${entry.message}';
    if (entry.level.index >= LogLevel.error.index) {
      stderr.writeln(output);
      if (entry.error != null) stderr.writeln('${entry.error}');
      if (entry.stackTrace != null) stderr.writeln('${entry.stackTrace}');
    } else {
      stdout.writeln(output);
    }
  }

  @override
  String formatSpinner(String frame, ActiveScope active) {
    final elapsed = _gray('(${formatElapsed(active.stopwatch.elapsed)})');
    return '${_cyan(frame)} ${active.scope.label}... $elapsed';
  }

  @override
  String formatScopeComplete(LogScope scope, bool success, Duration duration) {
    final elapsed = _gray('(${formatElapsed(duration)})');
    final icon = success ? _green('\u2713') : _red('\u2717');
    return '$icon ${scope.label} $elapsed';
  }
}

import 'dart:io';

/// Logs an error to stderr.
void logError(var e, {StackTrace? stackTrace}) {
  stderr.writeln('ERROR: $e');
  if (stackTrace != null) {
    stderr.writeln('$stackTrace');
  }
}

/// Logs a message to stdout.
void logDebug(String msg) {
  stdout.writeln(msg);
}

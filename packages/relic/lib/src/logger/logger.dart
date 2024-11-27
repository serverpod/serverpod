import 'dart:io';

import 'package:stack_trace/stack_trace.dart';

typedef Logger = void Function(
  String message, {
  StackTrace? stackTrace,
  bool isError,
});

/// Logs an error message to the standard error stream.
void logError(
  String message, {
  StackTrace? stackTrace,
  bool isError = true,
}) {
  var chain = Chain.current();

  if (stackTrace != null) {
    chain = Chain.forTrace(stackTrace)
        .foldFrames((frame) => frame.isCore || frame.package == 'relic')
        .terse;
  }

  if (isError) {
    stderr.writeln('ERROR - ${DateTime.now()}');
    stderr.writeln(message);
    stderr.writeln(chain);
  } else {
    stdout.writeln('WARN - ${DateTime.now()}');
    stdout.writeln(message);
    stdout.writeln(chain);
  }
}

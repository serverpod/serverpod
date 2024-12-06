import 'dart:io';

import 'package:stack_trace/stack_trace.dart';

typedef Logger = void Function(
  String message, {
  StackTrace? stackTrace,
  LoggerType type,
});

enum LoggerType {
  error,
  warn,
  info,
}

/// Logs an error message to the standard error stream.
void loggMessage(
  String message, {
  StackTrace? stackTrace,
  LoggerType type = LoggerType.info,
}) {
  var chain = Chain.current();

  if (stackTrace != null) {
    chain = Chain.forTrace(stackTrace)
        .foldFrames((frame) => frame.isCore || frame.package == 'relic')
        .terse;
  }

  switch (type) {
    case LoggerType.error:
      stderr.writeln('ERROR - ${DateTime.now()}');
      stderr.writeln(message);
      stderr.writeln(chain);
      break;
    case LoggerType.warn:
      stdout.writeln('WARN - ${DateTime.now()}');
      stdout.writeln(message);
      stdout.writeln(chain);
      break;
    case LoggerType.info:
      stdout.writeln('INFO - ${DateTime.now()}');
      stdout.writeln(message);
      break;
  }
}

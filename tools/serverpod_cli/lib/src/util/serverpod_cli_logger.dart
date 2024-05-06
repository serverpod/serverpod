import 'dart:io';

import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/logger/loggers/std_out_logger.dart';

/// Singleton instance of logger.
Logger? _logger;

/// Initializer for logger singleton.
/// Runs checks to pick the best suitable logger for the environment.
/// This should only be called once from runtime entry points.
void initializeLogger() {
  assert(
    _logger == null,
    'Only one logger initialization is allowed.',
  );

  _logger = Platform.isWindows
      ? WindowsStdOutLogger(LogLevel.info)
      : StdOutLogger(LogLevel.info);
}

/// Initializer for logger singleton.
/// Uses passed in [logger] to initialize the singleton.
/// This should only be called once from runtime entry points.
void initializeLoggerWith(Logger logger) {
  assert(
    _logger == null,
    'Only one logger initialization is allowed.',
  );

  _logger = logger;
}

/// Singleton accessor for logger.
/// Default initializes a [StdOutLogger] if initialization is not run before
/// this call.
Logger get log {
  if (_logger == null) {
    initializeLogger();
  }

  return _logger!;
}

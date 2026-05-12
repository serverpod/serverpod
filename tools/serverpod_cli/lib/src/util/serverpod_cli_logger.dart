import 'dart:io';

import 'package:cli_tools/cli_tools.dart' as cli;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_shared/log_io.dart';

import 'std_out_log_writer.dart';

// ---------------------------------------------------------------------------
// ServerpodCliLogger - bridges cli_tools.Logger to the serverpod_shared Log
// ---------------------------------------------------------------------------

/// A [cli.Logger] that delegates to a serverpod_shared [Log].
///
/// This bridges the cli_tools logging interface with the serverpod_shared
/// log writer architecture, allowing multi-backend logging (terminal, TUI,
/// file, etc.) via [LogWriter] and [MultiLogWriter].
///
/// [cli.LogType] is preserved by stashing it in [LogEntry.metadata]
/// under [logTypeKey], so writers like [StdOutLogWriter] can format
/// output accordingly.
class ServerpodCliLogger extends cli.Logger {
  final Log _log;
  final LogWriter _writer;

  ServerpodCliLogger(LogWriter writer, {LogLevel logLevel = LogLevel.info})
    : _writer = writer,
      _log = Log(writer, logLevel: logLevel),
      super(_mapLevel(logLevel));

  /// Releases any resources held by the underlying writer. Without this
  /// an [IsolatedLogWriter] would keep its background isolate alive and
  /// prevent the Dart process from exiting.
  Future<void> close() async {
    await _log.close();
    await _writer.close();
  }

  @override
  set logLevel(cli.LogLevel level) {
    super.logLevel = level;
    if (level == cli.LogLevel.nothing) return;
    _log.logLevel = _mapLogLevel(level);
  }

  @override
  int? get wrapTextColumn => stdout.hasTerminal ? stdout.terminalColumns : null;

  @override
  void debug(
    String message, {
    bool newParagraph = false,
    cli.LogType type = cli.TextLogType.normal,
  }) {
    _call(LogLevel.debug, message, type: type);
  }

  @override
  void info(
    String message, {
    bool newParagraph = false,
    cli.LogType type = cli.TextLogType.normal,
  }) {
    _call(LogLevel.info, message, type: type);
  }

  @override
  void warning(
    String message, {
    bool newParagraph = false,
    cli.LogType type = cli.TextLogType.normal,
  }) {
    _call(LogLevel.warning, message, type: type);
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    cli.LogType type = cli.TextLogType.normal,
  }) {
    final msg = stackTrace != null
        ? '$message\n${stackTrace.toString()}'
        : message;
    _call(LogLevel.error, msg, type: type);
  }

  @override
  void log(
    String message,
    cli.LogLevel level, {
    bool newParagraph = false,
    cli.LogType type = cli.TextLogType.normal,
  }) {
    _call(_mapLogLevel(level), message, type: type);
  }

  @override
  void write(
    String message,
    cli.LogLevel logLevel, {
    bool newParagraph = false,
    bool newLine = true,
  }) {
    _call(_mapLogLevel(logLevel), message);
  }

  @override
  Future<bool> progress(
    String message,
    Future<bool> Function() runner, {
    bool newParagraph = false,
  }) {
    if (_silent) return runner();
    return _log.progress(message, runner);
  }

  @override
  Future<void> flush() => _log.flush();

  void _call(LogLevel level, String message, {cli.LogType? type}) {
    if (_silent) return;
    _log(
      level,
      () => LogEntry(
        time: DateTime.now(),
        level: level,
        message: message,
        scope: _log.currentScope,
        metadata: type != null ? {logTypeKey: type} : null,
      ),
    );
  }

  // serverpod_shared LogLevel has no "nothing" sentinel - its lowest-passing
  // level is fatal, and the filter check is strict-`<` so fatal still leaks
  // through. Progress / scope events bypass logLevel entirely. So when the
  // caller sets cli.LogLevel.nothing we gate at the bridge instead of mapping
  // through to _log.logLevel.
  bool get _silent => super.logLevel == cli.LogLevel.nothing;

  static cli.LogLevel _mapLevel(LogLevel level) => switch (level) {
    LogLevel.debug => cli.LogLevel.debug,
    LogLevel.info => cli.LogLevel.info,
    LogLevel.warning => cli.LogLevel.warning,
    LogLevel.error || LogLevel.fatal => cli.LogLevel.error,
  };

  static LogLevel _mapLogLevel(cli.LogLevel level) => switch (level) {
    cli.LogLevel.debug => LogLevel.debug,
    cli.LogLevel.info => LogLevel.info,
    cli.LogLevel.warning => LogLevel.warning,
    cli.LogLevel.error => LogLevel.error,
    // The setter early-returns before reaching here, so this branch only
    // fires from log() / write() being called with nothing as a message
    // level - which is a programmer error worth surfacing.
    cli.LogLevel.nothing => throw ArgumentError.value(
      level,
      'level',
      'cli.LogLevel.nothing is a filter sentinel; it cannot be used as a '
          'message level',
    ),
  };
}

// ---------------------------------------------------------------------------
// Singleton logger
// ---------------------------------------------------------------------------

/// Singleton instance of logger.
cli.Logger? _logger;

/// Replacements for emojis that are not supported on Windows.
final Map<String, String> _windowsLoggerReplacements = {
  '🥳': '=D',
  '✅': cli.AnsiStyle.bold.wrap(cli.AnsiStyle.lightGreen.wrap('✓')),
  '🚀': '',
  '📦': '',
};

/// Initializer for logger singleton.
/// Runs checks to pick the best suitable logger for the environment.
/// This should only be called once from runtime entry points.
void initializeLogger() {
  assert(
    _logger == null,
    'Only one logger initialization is allowed.',
  );

  _logger = ServerpodCliLogger(
    IsolatedLogWriter(
      () => StdOutLogWriter(
        replacements: Platform.isWindows ? _windowsLoggerReplacements : null,
      ),
    ),
  );
}

/// Replaces the logger singleton with the given [logger].
///
/// Preserves the current log level if a logger was already set.
void initializeLoggerWith(cli.Logger logger) {
  final previous = _logger;
  if (previous != null) {
    logger.logLevel = previous.logLevel;
  }
  _logger = logger;
}

/// Singleton accessor for logger.
/// Default initializes a [ServerpodCliLogger] if initialization is not run
/// before this call.
cli.Logger get log {
  if (_logger == null) {
    initializeLogger();
  }

  return _logger!;
}

extension SourceSpanExceptionLogger on cli.Logger {
  /// Display a [SourceSpanException] to the user.
  /// Commands should use this to log [SourceSpanException] with
  /// enhanced highlighting if possible.
  void sourceSpanException(
    SourceSpanException sourceSpan, {
    bool newParagraph = false,
  }) {
    var logLevel = cli.LogLevel.error;
    bool isHint = false;

    if (sourceSpan is SourceSpanSeverityException) {
      var severity = sourceSpan.severity;
      isHint = severity == SourceSpanSeverity.hint;
      logLevel = _SeveritySpanHelpers.severityToLogLevel(severity);
    }

    if (!(logLevel.index >= log.logLevel.index)) return;

    var highlightAnsiCode = _SeveritySpanHelpers.highlightAnsiCode(
      logLevel,
      isHint,
    );
    var message = sourceSpan.toString(color: highlightAnsiCode);

    write(message, logLevel, newParagraph: newParagraph);
  }
}

abstract class _SeveritySpanHelpers {
  static cli.LogLevel severityToLogLevel(SourceSpanSeverity severity) {
    switch (severity) {
      case SourceSpanSeverity.error:
        return cli.LogLevel.error;
      case SourceSpanSeverity.warning:
        return cli.LogLevel.warning;
      case SourceSpanSeverity.info:
      case SourceSpanSeverity.hint:
        return cli.LogLevel.info;
    }
  }

  static String highlightAnsiCode(cli.LogLevel severity, bool isHint) {
    if (severity == cli.LogLevel.info && isHint) {
      return cli.AnsiStyle.cyan.ansiCode;
    }

    switch (severity) {
      case cli.LogLevel.nothing:
        assert(
          severity != cli.LogLevel.nothing,
          'Log level nothing should never be used for a log message',
        );
        return cli.AnsiStyle.terminalDefault.ansiCode;
      case cli.LogLevel.error:
        return cli.AnsiStyle.red.ansiCode;
      case cli.LogLevel.warning:
        return cli.AnsiStyle.yellow.ansiCode;
      case cli.LogLevel.info:
        return cli.AnsiStyle.blue.ansiCode;
      case cli.LogLevel.debug:
        return cli.AnsiStyle.cyan.ansiCode;
    }
  }
}

/// Shuts down and closes the logger, releasing any isolate resources.
Future<void> closeLogger() async {
  final logger = _logger;
  _logger = null;
  if (logger == null) return;
  await logger.flush();
  if (logger is ServerpodCliLogger) {
    await logger.close();
  }
}

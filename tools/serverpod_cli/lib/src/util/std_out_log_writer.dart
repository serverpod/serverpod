import 'package:cli_tools/cli_tools.dart' as cli;
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_shared/log_io.dart';

/// Metadata key used to pass [cli.LogType] through [LogEntry.metadata].
const logTypeKey = 'serverpod:logType';

/// A [SpinnerLogWriter] that delegates log formatting to a cli_tools
/// [cli.StdOutLogger] for [cli.LogType]-aware output (bullets, headers,
/// boxes, etc.).
///
/// Spinner animation is handled by the [SpinnerLogWriter] base class.
///
/// [cli.LogType] is read from [LogEntry.metadata] using [logTypeKey].
class StdOutLogWriter extends SpinnerLogWriter {
  final cli.StdOutLogger _logger;

  StdOutLogWriter({
    Map<String, String>? replacements,
  }) : _logger = cli.StdOutLogger(
         // Accept all levels - filtering is done by Log, not the writer.
         cli.LogLevel.debug,
         replacements: replacements,
       );

  @override
  void writeLogLine(LogEntry entry) {
    final cliLevel = _mapLevel(entry.level);
    final type =
        entry.metadata?[logTypeKey] as cli.LogType? ?? cli.TextLogType.normal;
    _logger.log(entry.message, cliLevel, type: type);
  }

  @override
  String formatSpinner(String frame, ActiveScope active) {
    final elapsed = cli.AnsiStyle.darkGray.wrap(
      '(${formatElapsed(active.stopwatch.elapsed)})',
    );
    return '${cli.AnsiStyle.lightGreen.wrap(frame)} '
        '${active.scope.label}... $elapsed';
  }

  @override
  String formatScopeComplete(LogScope scope, bool success, Duration duration) {
    final elapsed = cli.AnsiStyle.darkGray.wrap('(${formatElapsed(duration)})');
    final icon = success
        ? cli.AnsiStyle.lightGreen.wrap('\u2713')
        : cli.AnsiStyle.red.wrap('\u2717');
    return '$icon ${scope.label} $elapsed';
  }

  static cli.LogLevel _mapLevel(LogLevel level) => switch (level) {
    LogLevel.debug => cli.LogLevel.debug,
    LogLevel.info => cli.LogLevel.info,
    LogLevel.warning => cli.LogLevel.warning,
    LogLevel.error || LogLevel.fatal => cli.LogLevel.error,
  };
}

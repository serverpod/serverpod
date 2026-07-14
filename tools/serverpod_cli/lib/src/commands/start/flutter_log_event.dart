import 'package:serverpod_shared/log.dart' show LogLevel;

/// Transport that produced a Flutter log event.
enum FlutterLogSource {
  appLog,
  daemon,
  vmLogging,
  vmStdout,
  vmStderr,
  processStdout,
  processStderr,
  flutterError,
}

/// A Flutter log before it is flattened into terminal output.
class FlutterLogEvent {
  const FlutterLogEvent({
    required this.time,
    required this.level,
    required this.message,
    required this.source,
    this.loggerName,
    this.error,
    this.stackTrace,
    this.metadata,
    this.levelIsInferred = false,
    this.timestampIsInferred = false,
    this.canCoalesce = false,
  });

  final DateTime time;
  final LogLevel level;
  final String message;
  final FlutterLogSource source;
  final String? loggerName;
  final String? error;
  final String? stackTrace;
  final Map<String, Object?>? metadata;

  /// Whether [level] was derived from a stream or boolean error marker rather
  /// than supplied as a real severity by the source.
  final bool levelIsInferred;

  /// Whether [time] records when the CLI received the event because the source
  /// did not supply a timestamp.
  final bool timestampIsInferred;

  /// Whether adjacent events from the same raw source may be combined.
  ///
  /// This is false for transports that already provide semantic event
  /// boundaries, even when their level or timestamp is inferred.
  final bool canCoalesce;
}

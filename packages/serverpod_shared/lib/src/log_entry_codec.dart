import 'package:serverpod_logging/serverpod_logging.dart';

/// The VM service extension event the pod posts each log entry and scope
/// transition on.
///
/// A contract between two packages. The pod posts on it and the CLI subscribes
/// to it. As a literal on each side, a rename would compile and silently stop
/// the CLI seeing the pod's logs.
///
/// The payload carries no version, and one would not help, since a globally
/// activated CLI meets whatever `serverpod` the project pins. Add keys rather
/// than rename them, and keep reading the old spelling where one was renamed.
const serverpodLogEvent = 'ext.serverpod.log';

/// Encodes [entry] as the JSON the pod posts and the runner forwards.
///
/// The scope goes whole rather than as an id. The label is what a renderer
/// shows, and a consumer in another process cannot resolve an id it never saw
/// opened.
///
/// `timestamp` is written beside `time` for one release, being the spelling a
/// released CLI reads.
Map<String, Object?> encodeLogEntry(LogEntry entry) => {
  'type': 'log',
  'time': entry.time.toUtc().toIso8601String(),
  'timestamp': entry.time.toUtc().toIso8601String(),
  'level': entry.level.name,
  'message': entry.message,
  'scope': {
    'id': entry.scope.id,
    'label': entry.scope.label,
    'startTime': entry.scope.startTime.toUtc().toIso8601String(),
  },
  if (entry.error != null) 'error': entry.error.toString(),
  if (entry.stackTrace != null) 'stackTrace': entry.stackTrace.toString(),
  ...?_metadataField(entry.metadata),
};

/// Decodes what [encodeLogEntry] produced.
///
/// Every field is optional on the way in. This decodes what another process
/// sent, and a missing field costs that field, not the entry. A field of the
/// wrong type still throws, since every read is a cast.
///
/// `timestamp` is read as [LogEntry.time] when `time` is absent, which is what
/// a pod older than this codec sends. See [serverpodLogEvent].
///
/// [fallbackScopeLabel] names the scope when the payload carries none, absent
/// or empty. The pod's session writer sends an empty label on purpose.
LogEntry decodeLogEntry(
  Map<String, Object?> json, {
  String fallbackScopeLabel = '',
}) {
  final scope = json['scope'];
  final stackTrace = json['stackTrace'] as String?;
  return LogEntry(
    time: _time(json['time'] ?? json['timestamp']),
    level: parseLogLevel(json['level'] as String?),
    message: json['message'] as String? ?? '',
    scope: scope is Map
        ? LogScope(
            id: scope['id'] as String? ?? 'root',
            label: _label(scope['label'], fallbackScopeLabel),
            startTime: _time(scope['startTime']),
          )
        : LogScope(
            id: json['scopeId'] as String? ?? 'root',
            label: fallbackScopeLabel,
            startTime: _time(json['time'] ?? json['timestamp']),
          ),
    error: json['error']?.toString(),
    stackTrace: stackTrace == null || stackTrace.isEmpty
        ? null
        : StackTrace.fromString(stackTrace),
    metadata: json['metadata'] is Map
        ? Map<String, Object?>.from(json['metadata'] as Map)
        : null,
  );
}

/// The [LogLevel] [name] denotes, defaulting to [LogLevel.info].
///
/// `warn` counts as `warning`. Several logging front-ends emit it, and an
/// unrecognized level demotes to info.
LogLevel parseLogLevel(String? name) => switch (name) {
  'debug' => LogLevel.debug,
  'warning' || 'warn' => LogLevel.warning,
  'error' => LogLevel.error,
  'fatal' => LogLevel.fatal,
  _ => LogLevel.info,
};

/// Returns `{'metadata': ...}` with every value reduced to something
/// `jsonEncode` accepts, or null when nothing survives.
///
/// Metadata is an open map: the CLI logger stashes a `LogType` in it, and the
/// pod and Flutter apps put their own objects there. One non-encodable value
/// would otherwise throw out of the JSON layer and take the whole connection
/// down, so anything unrecognized is carried as its `toString()` rather than
/// dropping the entry or the connection.
Map<String, Object?>? _metadataField(Map<String, Object?>? metadata) {
  if (metadata == null || metadata.isEmpty) return null;
  return {
    'metadata': {
      for (final entry in metadata.entries) entry.key: _jsonSafe(entry.value),
    },
  };
}

Object? _jsonSafe(Object? value) => switch (value) {
  null || bool() || num() || String() => value,
  final List<Object?> list => [for (final item in list) _jsonSafe(item)],
  final Map<Object?, Object?> map => {
    for (final entry in map.entries) '${entry.key}': _jsonSafe(entry.value),
  },
  _ => value.toString(),
};

DateTime _time(Object? value) =>
    DateTime.tryParse(value is String ? value : '') ?? DateTime.now();

String _label(Object? value, String fallback) =>
    value is String && value.isNotEmpty ? value : fallback;

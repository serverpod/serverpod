import 'package:serverpod_logging/serverpod_logging.dart';

/// The VM service extension event the pod posts each log entry and scope
/// transition on.
///
/// Stated here because it is a contract between two packages. The pod posts on
/// it and the CLI subscribes to it. Spelled as a literal on both sides, as it
/// was, a rename compiles cleanly and silently stops the CLI seeing the pod's
/// logs at all.
///
/// The payload carries no version, and one would not help, since a globally
/// activated CLI meets whatever `serverpod` the project pins. Add keys rather
/// than rename them, and keep reading the old spelling where one was renamed.
const serverpodLogEvent = 'ext.serverpod.log';

/// Encodes [entry] as the JSON the pod posts and the runner forwards.
///
/// `LogEntry` in `serverpod_logging` carries no codec of its own, so both the
/// pod's VM service writer and the runner's attach protocol had grown one.
/// They had drifted into two shapes for the same data - `timestamp` against
/// `time`, a bare `scopeId` against a nested `scope` - and the receiving side
/// of each had a decoder to match. This is the one shape.
///
/// The scope is carried whole rather than as an id: the label is what a
/// renderer would show, and a consumer in another process cannot resolve an id
/// it never saw opened.
Map<String, Object?> encodeLogEntry(LogEntry entry) => {
  'type': 'log',
  'time': entry.time.toUtc().toIso8601String(),
  'level': entry.level.name,
  'message': entry.message,
  'scope': {
    'id': entry.scope.id,
    'label': entry.scope.label,
    'startTime': entry.scope.startTime.toUtc().toIso8601String(),
  },
  if (entry.error != null) 'error': entry.error.toString(),
  if (entry.stackTrace != null) 'stackTrace': entry.stackTrace.toString(),
  ...?jsonSafeMetadata(entry.metadata),
};

/// Decodes what [encodeLogEntry] produced.
///
/// Every field is optional on the way in. This decodes what another process
/// sent, and a missing or misshapen field should cost that field rather than
/// the entry, or on a JSON-RPC transport, the connection.
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
        : LogScope.root(fallbackScopeLabel),
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
/// `warn` is accepted alongside `warning`: it is what several logging
/// front-ends emit, and an unrecognized level would otherwise silently demote
/// a warning to info.
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
Map<String, Object?>? jsonSafeMetadata(Map<String, Object?>? metadata) {
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

import 'package:serverpod_logging/serverpod_logging.dart';

/// The VM service extension event carrying the pod's log entries and scopes.
///
/// The payload has no version, and a global CLI meets any pinned `serverpod`.
/// Add keys, never rename them.
const serverpodLogEvent = 'ext.serverpod.log';

/// Encodes [entry] as the JSON the pod posts and the runner forwards.
///
/// The scope goes whole, since another process cannot resolve a bare id.
/// `timestamp` duplicates `time` for CLIs that read only `timestamp`.
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

/// Decodes what [encodeLogEntry], or a pod older than it, produced.
///
/// A missing field costs only that field. A mistyped one can throw.
/// [fallbackScopeLabel] names a scope that arrives without a label.
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

/// The [LogLevel] that [name] denotes, or [LogLevel.info] if none does.
LogLevel parseLogLevel(String? name) => switch (name) {
  'debug' => LogLevel.debug,
  'warning' || 'warn' => LogLevel.warning,
  'error' => LogLevel.error,
  'fatal' => LogLevel.fatal,
  _ => LogLevel.info,
};

/// Carries non-JSON values as `toString()`, which `jsonEncode` would reject.
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

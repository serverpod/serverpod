/// JSON for the entries a runner's log history holds, so a client in another
/// process can render the same buffers.
///
/// `LogEntry` in `serverpod_logging` carries no codec of its own, and the MCP
/// `tail_server_logs` tool needed one first; this is that encoding, made
/// symmetric so attach can decode it too.
library;

import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart'
    show CompletedOperation, TrackedOperation;

/// Encodes one entry of the runner's server history, which holds [LogEntry]
/// and [CompletedOperation].
///
/// An entry of neither type is encoded as `unknown` rather than dropped, so an
/// older client meeting a newer runner shows something instead of a hole.
Map<String, Object?> encodeLogHistoryItem(Object item) {
  if (item is LogEntry) {
    return {
      'type': 'log',
      'time': item.time.toIso8601String(),
      'level': item.level.name,
      'message': item.message,
      'scope': {'id': item.scope.id, 'label': item.scope.label},
      if (item.error != null) 'error': item.error.toString(),
      if (item.stackTrace != null) 'stackTrace': item.stackTrace.toString(),
      if (item.metadata != null) 'metadata': ?_jsonSafeMap(item.metadata),
    };
  }
  if (item is CompletedOperation) {
    return {
      'type': 'operation',
      'label': item.label,
      'success': item.success,
      'durationMs': item.duration.inMilliseconds,
      'completedAt': item.completedAt.toIso8601String(),
    };
  }
  if (item is String) {
    return {'type': 'line', 'value': item};
  }
  return {'type': 'unknown', 'value': item.toString()};
}

/// Returns [metadata] with every value reduced to something `jsonEncode`
/// accepts, or null when nothing survives.
///
/// Metadata is an open map: the CLI logger stashes a `LogType` in it, and the
/// pod and Flutter apps put their own objects there. One non-encodable value
/// would otherwise throw out of the JSON-RPC layer and take the whole attach
/// connection down, so anything unrecognized is carried as its `toString()`
/// rather than dropping the entry or the connection.
Map<String, Object?>? _jsonSafeMap(Map<String, Object?>? metadata) {
  if (metadata == null || metadata.isEmpty) return null;
  return {
    for (final entry in metadata.entries) entry.key: _jsonSafe(entry.value),
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

/// Decodes what [encodeLogHistoryItem] produced, or `null` for an entry this
/// client does not understand.
Object? decodeLogHistoryItem(Map<String, Object?> json) =>
    switch (json['type']) {
      'log' => decodeLogEntry(json),
      'line' => json['value'] as String? ?? '',
      'operation' => CompletedOperation(
        label: json['label'] as String? ?? '',
        success: json['success'] as bool? ?? true,
        duration: Duration(milliseconds: json['durationMs'] as int? ?? 0),
        completedAt: _time(json['completedAt']),
      ),
      _ => null,
    };

/// Decodes a `log` entry.
LogEntry decodeLogEntry(Map<String, Object?> json) {
  final scope = json['scope'];
  final stackTrace = json['stackTrace'] as String?;
  return LogEntry(
    time: _time(json['time']),
    level: parseLogLevel(json['level'] as String? ?? 'info'),
    message: json['message'] as String? ?? '',
    scope: LogScope.root(
      scope is Map ? scope['label'] as String? ?? '' : '',
    ),
    error: json['error'] as String?,
    stackTrace: stackTrace == null || stackTrace.isEmpty
        ? null
        : StackTrace.fromString(stackTrace),
    metadata: switch (json['metadata']) {
      final Map<Object?, Object?> map => Map<String, Object?>.from(map),
      _ => null,
    },
  );
}

/// Encodes an operation that is still running.
///
/// [TrackedOperation] measures elapsed time with a [Stopwatch] it starts on
/// construction, which cannot travel; [startedAt] is what a client needs to
/// show how long an operation it did not witness the start of has been going.
Map<String, Object?> encodeTrackedOperation(
  TrackedOperation operation, {
  required DateTime startedAt,
}) => {
  'id': operation.id,
  'label': operation.label,
  'startedAt': startedAt.toIso8601String(),
};

/// Decodes a tracked operation.
///
/// The reconstructed [TrackedOperation] starts a fresh stopwatch, which is
/// harmless: no widget renders elapsed time for an operation that is still
/// running, and the completed entry the runner emits carries the duration it
/// measured.
({TrackedOperation operation, DateTime startedAt}) decodeTrackedOperation(
  Map<String, Object?> json,
) => (
  operation: TrackedOperation(
    id: json['id'] as String? ?? '',
    label: json['label'] as String? ?? '',
  ),
  startedAt: _time(json['startedAt']),
);

DateTime _time(Object? value) =>
    DateTime.tryParse(value as String? ?? '') ?? DateTime.now();

/// Returns the [LogLevel] named by [level]; unknown names are treated as info.
///
/// Shared by the wire decoder and by the `ext.serverpod.log` reader, which
/// both receive the level as a name rather than an enum.
LogLevel parseLogLevel(String level) {
  return switch (level) {
    'debug' => LogLevel.debug,
    'info' => LogLevel.info,
    'warning' || 'warn' => LogLevel.warning,
    'error' => LogLevel.error,
    'fatal' => LogLevel.fatal,
    _ => LogLevel.info,
  };
}

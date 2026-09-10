/// JSON for a runner's log history, shared by attach and `tail_server_logs`.
library;

import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart'
    show CompletedOperation, TrackedOperation;

/// [entry] as `<local iso8601> [LEVEL] <message>`, then error and stack trace.
///
/// The runner's log file and `serverpod runner attach --no-tui` share it.
String formatLogEntryLine(LogEntry entry) {
  final buffer = StringBuffer()
    ..write(entry.time.toLocal().toIso8601String())
    ..write(' [')
    ..write(entry.level.name.toUpperCase())
    ..write('] ')
    ..write(entry.message);
  if (entry.error != null) buffer.write('\n${entry.error}');
  if (entry.stackTrace != null) buffer.write('\n${entry.stackTrace}');
  return buffer.toString();
}

/// Encodes a [LogEntry] or [CompletedOperation] from the server history.
Map<String, Object?> encodeLogHistoryItem(Object item) => switch (item) {
  LogEntry() => encodeLogEntry(item),
  CompletedOperation() => {
    'type': 'operation',
    'label': item.label,
    'success': item.success,
    'durationMs': item.duration.inMilliseconds,
    'completedAt': item.completedAt.toIso8601String(),
  },
  _ => throw ArgumentError.value(item, 'item', 'Not a log history item'),
};

/// Decodes what [encodeLogHistoryItem] produced, or null for an unknown type.
Object? decodeLogHistoryItem(Map<String, Object?> json) =>
    switch (json['type']) {
      'log' => decodeLogEntry(json),
      'operation' => CompletedOperation(
        label: json['label'] as String? ?? '',
        success: json['success'] as bool? ?? true,
        duration: Duration(milliseconds: json['durationMs'] as int? ?? 0),
        completedAt: _time(json['completedAt']),
      ),
      _ => null,
    };

/// Encodes a running operation with [startedAt], since its stopwatch cannot.
Map<String, Object?> encodeTrackedOperation(
  TrackedOperation operation, {
  required DateTime startedAt,
}) => {
  'id': operation.id,
  'label': operation.label,
  'startedAt': startedAt.toIso8601String(),
};

/// Decodes a tracked operation. Its fresh stopwatch is harmless, as nothing
/// renders it and the completed entry carries the measured duration.
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

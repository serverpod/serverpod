/// JSON for the entries a runner's log history holds, so a client in another
/// process can render the same buffers.
///
/// `LogEntry` in `serverpod_logging` carries no codec of its own. This one is
/// symmetric, so the MCP `tail_server_logs` tool and attach share it.
library;

import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart'
    show CompletedOperation, TrackedOperation;

/// One log entry as a plain-text line: `<iso8601> [LEVEL] <message>`, with the
/// error and stack trace on lines of their own.
///
/// The runner's log file and `serverpod runner attach --no-tui` are meant to be
/// greppable the same way, so the format is stated once rather than in each.
/// The time is local, whichever zone the entry came in.
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

/// Encodes one entry of the runner's server history, which holds [LogEntry]
/// and [CompletedOperation] and nothing else.
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

/// Decodes what [encodeLogHistoryItem] produced, or `null` for an entry this
/// client does not understand.
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

/// Encodes an operation that is still running.
///
/// [TrackedOperation] measures elapsed time with a [Stopwatch] it starts on
/// construction, which cannot travel. [startedAt] is what a client needs to
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

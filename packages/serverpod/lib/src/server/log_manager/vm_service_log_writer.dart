import 'dart:developer' as developer;

import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import 'log_writers.dart';

/// A [LogWriter] that posts structured log events via the VM service extension
/// `ext.serverpod.log`.
///
/// The CLI subscribes to these events via `vmService.onExtensionEvent` to
/// render them in the TUI. Each event carries a `type` field that determines
/// the event kind:
///
/// - `session_start` / `session_end`: Session lifecycle (tracked operations).
/// - `session_log`: Log entry within a session.
/// - `session_query`: Database query within a session.
///
/// This writer is only active when the VM service is enabled (dev mode).
/// Production builds do not have the VM service, so [developer.postEvent]
/// is a no-op.
@internal
class VmServiceLogWriter extends LogWriter {
  final Session _session;
  final int _logId;

  VmServiceLogWriter(this._session) : _logId = _session.sessionId.hashCode;

  @override
  Future<void> openLog(SessionLogEntry entry) async {
    _postEvent({
      'type': 'session_start',
      'id': '$_logId',
      'label': _buildLabel(entry),
      'timestamp': (entry.time).toUtc().toIso8601String(),
    });
  }

  @override
  Future<int> closeLog(SessionLogEntry entry) async {
    _postEvent({
      'type': 'session_end',
      'id': '$_logId',
      'success': entry.error == null,
      'duration': entry.duration,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
    return _logId;
  }

  @override
  Future<void> logEntry(LogEntry entry) async {
    _postEvent({
      'type': 'session_log',
      'sessionId': '$_logId',
      'level': entry.logLevel.name,
      'message': entry.message,
      'error': entry.error,
      'stackTrace': entry.stackTrace,
      'timestamp': entry.time.toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> logQuery(QueryLogEntry entry) async {
    _postEvent({
      'type': 'session_query',
      'sessionId': '$_logId',
      'query': entry.query,
      'duration': entry.duration,
      'numRows': entry.numRows,
      'error': entry.error,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> logMessage(MessageLogEntry entry) async {
    _postEvent({
      'type': 'session_log',
      'sessionId': '$_logId',
      'level': 'info',
      'message': '${entry.messageName} (${entry.endpoint})',
      'error': entry.error,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  }

  String _buildLabel(SessionLogEntry entry) {
    final endpoint = entry.endpoint;
    final method = entry.method;

    return switch (_session) {
      MethodCallSession() =>
        '${endpoint ?? 'unknown'}${method != null ? '.$method' : ''}',
      StreamingSession() || MethodStreamSession() =>
        'STREAM ${endpoint ?? 'unknown'}${method != null ? '.$method' : ''}',
      FutureCallSession s => 'FUTURE ${s.futureCallName}',
      WebCallSession() => 'WEB ${endpoint ?? 'unknown'}',
      InternalSession() => 'INTERNAL',
      _ => endpoint ?? _session.runtimeType.toString(),
    };
  }

  static void _postEvent(Map<String, Object?> data) {
    // Remove null values to keep the payload compact.
    data.removeWhere((_, v) => v == null);
    developer.postEvent('ext.serverpod.log', data);
  }
}

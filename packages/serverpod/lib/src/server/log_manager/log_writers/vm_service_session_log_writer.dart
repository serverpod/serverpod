import 'dart:developer' as developer;

import 'package:serverpod_shared/log.dart';

import '../session_log.dart';

/// Posts typed session events via the VM service extension
/// `ext.serverpod.log`, reusing the same wire format as the framework
/// [VmServiceLogWriter] so existing consumers keep working unchanged.
/// Session-specific fields are namespaced under a top-level `session`
/// object so session-aware consumers can unpack them.
///
/// Mapping:
///
/// - [open] -> `{type: 'scope_start', id, label, timestamp, session: {…}}`
/// - [record] for log/query entries ->
///   `{type: 'log', level, message, scopeId, timestamp, session: {kind, …}}`
/// - [close] -> `{type: 'scope_end', id, success, duration, timestamp, session: {…}}`
///
/// In production where the VM service is disabled, [developer.postEvent]
/// is a no-op.
class VmServiceSessionLogWriter extends SessionLogWriter {
  @override
  Future<void> open(SessionOpen event) async {
    _postEvent({
      'type': 'scope_start',
      'id': event.sessionId,
      'label': event.label,
      'timestamp': event.startTime.toUtc().toIso8601String(),
      'session': {
        'kind': event.kind.name,
        'serverId': event.serverId,
        'endpoint': event.endpoint,
        'method': event.method,
        'futureCallName': event.futureCallName,
      },
    });
  }

  @override
  Future<void> record(SessionEntry entry) async {
    switch (entry) {
      case SessionLogEntry e:
        _postEvent({
          ...encodeLogEntry(
            LogEntry(
              time: e.time,
              level: e.level,
              message: e.message,
              scope: _sessionScope(e.sessionId, e.time),
              error: e.error,
              stackTrace: e.stackTrace,
              metadata: e.metadata,
            ),
          ),
          'session': {
            'kind': 'log',
            'order': e.order,
          },
        });
      case SessionQueryEntry e:
        _postEvent({
          ...encodeLogEntry(
            LogEntry(
              time: e.time,
              level: LogLevel.debug,
              message: e.query,
              scope: _sessionScope(e.sessionId, e.time),
              error: e.error,
              stackTrace: e.stackTrace,
            ),
          ),
          'session': {
            'kind': 'query',
            'order': e.order,
            'duration': e.duration.inMicroseconds / 1000000,
            'numRows': e.numRowsAffected,
            'slow': e.slow,
          },
        });
    }
  }

  @override
  Future<void> close(SessionClose event) async {
    _postEvent({
      'type': 'scope_end',
      'id': event.sessionId,
      'success': event.success,
      'duration': event.duration.inMicroseconds / 1000000,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'error': event.error?.toString(),
      'stackTrace': event.stackTrace?.toString(),
      'session': {
        'authenticatedUserId': event.authenticatedUserId,
        'numQueries': event.numQueries,
        'slow': event.slow,
      },
    });
  }

  /// The scope a session's entries belong to.
  ///
  /// The id is the session id, which is what correlates every entry with the
  /// [SessionOpen] that named it and the [SessionClose] that ends it. The
  /// label was carried by that open event, so it is not repeated per entry.
  static LogScope _sessionScope(String sessionId, DateTime time) =>
      LogScope(id: sessionId, label: '', startTime: time);

  static void _postEvent(Map<String, Object?> data) {
    data.removeWhere((_, v) => v == null);
    if (data['session'] case final Map<String, Object?> session) {
      session.removeWhere((_, v) => v == null);
    }
    developer.postEvent(serverpodLogEvent, data);
  }
}

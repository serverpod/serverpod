import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod_shared/log.dart' show LogLevel;

import '../../../generated/protocol.dart' as protocol;
import '../session_log.dart';

/// A [SessionLogWriter] that emits typed session events as single-line
/// JSON to stdout (stderr for errors/fatal). Every session opens and
/// closes with a [protocol.SessionLogEntry] row; log/query/message
/// entries emit the corresponding protocol rows keyed by a synthetic
/// per-session `sessionLogId` derived from the session id hash.
@internal
class JsonSessionLogWriter extends SessionLogWriter {
  /// Per-session state: synthetic session log id + cached open event
  /// so child rows and the close row can reference them without
  /// round-tripping through scope metadata.
  final Map<String, _OpenState> _sessions = {};

  /// Creates a [JsonSessionLogWriter].
  JsonSessionLogWriter();

  @override
  Future<void> open(SessionOpen event) async {
    final id = event.sessionId.hashCode;
    _sessions[event.sessionId] = _OpenState(event, id);
    _emit(_buildOpenRow(event, id));
  }

  @override
  Future<void> record(SessionEntry entry) async {
    final state = _sessions[entry.sessionId];
    if (state == null) return;

    switch (entry) {
      case SessionLogEntry e:
        _emit(_buildLogRow(e, state));
      case SessionQueryEntry e:
        _emit(_buildQueryRow(e, state));
      case SessionMessageEntry e:
        _emit(_buildMessageRow(e, state));
    }
  }

  @override
  Future<void> close(SessionClose event) async {
    final state = _sessions.remove(event.sessionId);
    if (state == null) return;

    _emit(_buildCloseRow(state.open, event, state.sessionLogId));
  }

  void _emit(Object row) {
    final line = row.toString();
    final isError = switch (row) {
      protocol.SessionLogEntry(:final error) => error != null,
      protocol.LogEntry(:final error, :final logLevel) =>
        error != null ||
            logLevel == protocol.LogLevel.error ||
            logLevel == protocol.LogLevel.fatal,
      protocol.QueryLogEntry(:final error) => error != null,
      protocol.MessageLogEntry(:final error) => error != null,
      _ => false,
    };
    if (isError) {
      stderr.writeln(line);
    } else {
      stdout.writeln(line);
    }
  }

  protocol.SessionLogEntry _buildOpenRow(SessionOpen event, int id) {
    return protocol.SessionLogEntry(
      id: id,
      serverId: event.serverId,
      time: event.startTime,
      // Legacy: module carried the future-call name for future-call
      // sessions.
      module: event.futureCallName,
      endpoint: event.endpoint,
      method: event.method,
      isOpen: true,
      touched: DateTime.now(),
    );
  }

  protocol.SessionLogEntry _buildCloseRow(
    SessionOpen open,
    SessionClose close,
    int id,
  ) {
    return protocol.SessionLogEntry(
      id: id,
      serverId: open.serverId,
      time: open.startTime,
      module: open.futureCallName,
      endpoint: open.endpoint,
      method: open.method,
      duration: close.duration.inMicroseconds / Duration.microsecondsPerSecond,
      numQueries: close.numQueries,
      slow: close.slow,
      error: close.error?.toString(),
      stackTrace: close.stackTrace?.toString(),
      userId: close.authenticatedUserId,
      isOpen: false,
      touched: DateTime.now(),
    );
  }

  protocol.LogEntry _buildLogRow(SessionLogEntry entry, _OpenState state) {
    return protocol.LogEntry(
      sessionLogId: state.sessionLogId,
      serverId: state.open.serverId,
      messageId: entry.messageId,
      time: entry.time,
      logLevel: _toProtocolLogLevel(entry.level),
      message: entry.message,
      error: entry.error,
      stackTrace: entry.stackTrace?.toString(),
      order: entry.order,
    );
  }

  protocol.QueryLogEntry _buildQueryRow(
    SessionQueryEntry entry,
    _OpenState state,
  ) {
    return protocol.QueryLogEntry(
      sessionLogId: state.sessionLogId,
      serverId: state.open.serverId,
      messageId: entry.messageId,
      query: entry.query,
      duration: entry.duration.inMicroseconds / Duration.microsecondsPerSecond,
      numRows: entry.numRowsAffected,
      error: entry.error,
      stackTrace: entry.stackTrace?.toString(),
      slow: entry.slow,
      order: entry.order,
    );
  }

  protocol.MessageLogEntry _buildMessageRow(
    SessionMessageEntry entry,
    _OpenState state,
  ) {
    return protocol.MessageLogEntry(
      sessionLogId: state.sessionLogId,
      serverId: state.open.serverId,
      messageId: entry.messageId!,
      endpoint: entry.endpoint,
      messageName: entry.messageName,
      duration: entry.duration.inMicroseconds / Duration.microsecondsPerSecond,
      error: entry.error,
      stackTrace: entry.stackTrace?.toString(),
      slow: entry.slow,
      order: entry.order,
    );
  }

  protocol.LogLevel _toProtocolLogLevel(LogLevel level) => switch (level) {
    LogLevel.debug => protocol.LogLevel.debug,
    LogLevel.info => protocol.LogLevel.info,
    LogLevel.warning => protocol.LogLevel.warning,
    LogLevel.error => protocol.LogLevel.error,
    LogLevel.fatal => protocol.LogLevel.fatal,
  };
}

class _OpenState {
  _OpenState(this.open, this.sessionLogId);

  final SessionOpen open;
  final int sessionLogId;
}

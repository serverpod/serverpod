import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod_shared/log.dart' show LogLevel;

import '../../../generated/protocol.dart' as protocol;
import '../../session.dart';
import '../session_log.dart';

/// A [SessionLogWriter] that persists typed session events to the
/// `serverpod_session_log` / `serverpod_log` / `serverpod_query_log` /
/// `serverpod_message_log` tables.
///
/// Backed by an internal [Session] attached via [attach]; while
/// detached the writer is a no-op so it can sit in the session-log
/// chain before the database is up.
@internal
class DatabaseSessionLogWriter extends SessionLogWriter {
  /// Set via [attach]; while null, all operations are no-ops so the
  /// writer can sit in the chain before the database is up.
  Session? _internalSession;

  final Map<String, _SessionState> _sessions = {};

  /// In-flight DB write futures, drained by [dispose] before the pool
  /// is torn down.
  final Set<Future<Object?>> _inflight = {};

  /// Once true, new events are dropped; in-flight writes finish via
  /// [dispose]'s bounded drain.
  bool _closing = false;

  /// Upper bound on [dispose] drain. A stuck pool must not hang
  /// shutdown.
  static const _drainTimeout = Duration(seconds: 5);

  /// Creates a detached [DatabaseSessionLogWriter]. Call [attach] once the
  /// internal session is available.
  DatabaseSessionLogWriter();

  /// Attaches the [Session] used to perform writes.
  void attach(Session session) {
    _internalSession = session;
  }

  @override
  Future<void> dispose() async {
    if (_closing) return;
    _closing = true;
    final pending = _inflight.map((f) => f.catchError((_) => null)).toList();
    await Future.wait(pending).timeout(
      _drainTimeout,
      onTimeout: () => const <void>[],
    );
    _internalSession = null;
  }

  @override
  Future<void> open(SessionOpen event) async {
    final session = _internalSession;
    if (session == null || _closing) return;
    if (_sessions.containsKey(event.sessionId)) return;

    final future = _insertOpenRow(session, event);
    _sessions[event.sessionId] = _SessionState(event, future);

    // record / close observe insert failures via the stored future;
    // silence here so open itself stays best-effort.
    await _track(future).catchError((_) => 0);
  }

  Future<int> _insertOpenRow(Session session, SessionOpen event) async {
    final row = _buildOpenRow(event);
    final inserted = await protocol.SessionLogEntry.db.insertRow(session, row);
    final id = inserted.id;
    if (id == null) {
      throw StateError('SessionLogEntry insert returned null id');
    }
    return id;
  }

  @override
  Future<void> record(SessionEntry entry) async {
    final session = _internalSession;
    if (session == null || _closing) return;
    final state = _sessions[entry.sessionId];
    if (state == null) return;

    await _track(_record(session, entry, state));
  }

  Future<void> _record(
    Session session,
    SessionEntry entry,
    _SessionState state,
  ) async {
    int sessionLogId;
    try {
      sessionLogId = await state.sessionLogId;
    } catch (_) {
      return;
    }

    switch (entry) {
      case SessionLogEntry e:
        await protocol.LogEntry.db.insertRow(
          session,
          _buildLogRow(e, sessionLogId, state.open),
        );
      case SessionQueryEntry e:
        state.queryCount++;
        await protocol.QueryLogEntry.db.insertRow(
          session,
          _buildQueryRow(e, sessionLogId, state.open),
        );
      case SessionMessageEntry e:
        await protocol.MessageLogEntry.db.insertRow(
          session,
          _buildMessageRow(e, sessionLogId, state.open),
        );
    }
  }

  @override
  Future<void> close(SessionClose event) async {
    final session = _internalSession;
    if (session == null || _closing) return;
    final state = _sessions.remove(event.sessionId);
    if (state == null) return;

    await _track(_closeSession(session, event, state));
  }

  Future<void> _closeSession(
    Session session,
    SessionClose event,
    _SessionState state,
  ) async {
    int sessionLogId;
    try {
      sessionLogId = await state.sessionLogId;
    } catch (_) {
      return;
    }

    final row = _buildCloseRow(state.open, event, sessionLogId);
    await protocol.SessionLogEntry.db.updateRow(session, row);
  }

  Future<T> _track<T>(Future<T> work) async {
    _inflight.add(work);
    try {
      return await work;
    } finally {
      _inflight.remove(work);
    }
  }

  protocol.SessionLogEntry _buildOpenRow(SessionOpen event) {
    return protocol.SessionLogEntry(
      serverId: event.serverId,
      time: event.startTime,
      // Legacy: `module` carried the future-call name for future-call
      // sessions; preserved so existing readers keep working.
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

  protocol.LogEntry _buildLogRow(
    SessionLogEntry entry,
    int sessionLogId,
    SessionOpen open,
  ) {
    return protocol.LogEntry(
      sessionLogId: sessionLogId,
      serverId: open.serverId,
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
    int sessionLogId,
    SessionOpen open,
  ) {
    return protocol.QueryLogEntry(
      sessionLogId: sessionLogId,
      serverId: open.serverId,
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
    int sessionLogId,
    SessionOpen open,
  ) {
    return protocol.MessageLogEntry(
      sessionLogId: sessionLogId,
      serverId: open.serverId,
      // Session-message entries are required to carry a messageId; the
      // base field is nullable but the constructor enforces non-null.
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

class _SessionState {
  _SessionState(this.open, this.sessionLogId) {
    // Pre-attach a handler so an insert rejection isn't flagged
    // unhandled before _record (or _closeSession) await it.
    sessionLogId.ignore();
  }

  /// Open-time record. Retained so the close row and child entries
  /// can be built without reading back session fields from the close
  /// event.
  final SessionOpen open;

  /// Resolves to the inserted SessionLogEntry row id.
  final Future<int> sessionLogId;

  int queryCount = 0;
}

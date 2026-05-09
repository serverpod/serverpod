import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod_shared/log.dart' show LogLevel;

import '../../generated/protocol.dart' as protocol;
import '../serverpod.dart';
import '../session.dart';
import 'session_log.dart';

const double _microNormalizer = 1000 * 1000;

/// Per-session dispatcher for the typed [SessionLog] chain.
///
/// Each call enqueues through [SessionLog], which serialises writes in
/// invocation order. Long-lived streams with
/// `logStreamingSessionsContinuously: false` buffer entries in memory
/// and flush through the same chain at finalize.
@internal
class SessionLogManager {
  final Session _session;
  final SessionLog _log;
  final protocol.LogSettings Function(Session) _settingsForSession;
  final bool _disableSlowSessionLogging;
  final String _serverId;

  late final SessionOpen _open;

  bool _opened = false;
  bool _closed = false;

  bool _hasBufferedEvents = false;
  final List<SessionEntry> _buffered = [];

  final Stopwatch _stopwatch = Stopwatch();

  /// Monotonic per-session counter, assigned at call time so persisted
  /// order reflects caller order even when writes race downstream.
  int _nextEntryOrder = 0;

  /// Total queries observed, counted before the filter so numQueries on
  /// the session row reflects reality when individual query logging is
  /// off.
  int _queryCount = 0;

  /// Long-lived streaming session with continuous logging off: defer
  /// every write to session close. Evaluated once at construction.
  final bool _bufferStreamingLogs;

  @internal
  SessionLogManager({
    required Session session,
    required protocol.LogSettings Function(Session) settingsForSession,
    required String serverId,
    bool disableSlowSessionLogging = false,
  }) : _session = session,
       _log = sessionLog,
       _settingsForSession = settingsForSession,
       _serverId = serverId,
       _disableSlowSessionLogging = disableSlowSessionLogging,
       _bufferStreamingLogs =
           (session is StreamingSession || session is MethodStreamSession) &&
           !settingsForSession(session).logStreamingSessionsContinuously {
    _open = SessionOpen(
      sessionId: '${_session.sessionId.hashCode}',
      kind: _sessionKind(),
      label: _buildLabel(),
      startTime: session.startTime,
      serverId: _serverId,
      endpoint: session.endpoint,
      method: session.method,
      futureCallName: session is FutureCallSession
          ? session.futureCallName
          : null,
    );

    _stopwatch.start();

    // Skipped for InternalSession: _internalLoggingSession is built
    // before pod.start applies migrations, and an eager INSERT would
    // crash on the missing serverpod_session_log table. Internal
    // sessions still get their row via finalizeLog's ensure-open path.
    if (session is! InternalSession &&
        !_bufferStreamingLogs &&
        settingsForSession(session).logAllSessions) {
      _ensureOpened();
    }
  }

  String _buildLabel() {
    final endpoint = _session.endpoint;
    final method = _session.method;

    return switch (_session) {
      MethodCallSession() => '$endpoint${method != null ? '.$method' : ''}',
      StreamingSession() || MethodStreamSession() =>
        'STREAM $endpoint${method != null ? '.$method' : ''}',
      FutureCallSession s => 'FUTURE ${s.futureCallName}',
      WebCallSession() => 'WEB $endpoint',
      InternalSession() => 'INTERNAL',
      _ => endpoint,
    };
  }

  SessionKind _sessionKind() => switch (_session) {
    MethodCallSession() => SessionKind.method,
    MethodStreamSession() => SessionKind.methodStream,
    StreamingSession() => SessionKind.stream,
    FutureCallSession() => SessionKind.futureCall,
    WebCallSession() => SessionKind.web,
    InternalSession() => SessionKind.internal,
    _ => SessionKind.unknown,
  };

  void _ensureOpened() {
    if (_opened) return;
    _opened = true;
    _log.open(_open);
  }

  LogLevel _toSessionLogLevel(protocol.LogLevel level) => switch (level) {
    protocol.LogLevel.debug => LogLevel.debug,
    protocol.LogLevel.info => LogLevel.info,
    protocol.LogLevel.warning => LogLevel.warning,
    protocol.LogLevel.error => LogLevel.error,
    protocol.LogLevel.fatal => LogLevel.fatal,
  };

  void _dispatch(SessionEntry entry) {
    if (_closed) return;
    if (_bufferStreamingLogs) {
      _buffered.add(entry);
      _hasBufferedEvents = true;
      return;
    }
    _ensureOpened();
    _log.record(entry);
  }

  /// Unawaited so shutdown isn't wedged if the cleanup DB query stalls
  /// while the pool is being torn down. [LogCleanupManager.performCleanup]
  /// guards with its own interval check, so this is a no-op when not due.
  void _triggerCleanup() {
    unawaited(
      _session.serverpod.logCleanupManager?.performCleanup(_session),
    );
  }

  /// Logs an entry within this session.
  @internal
  void logEntry({
    protocol.LogLevel? level,
    required String message,
    String? error,
    StackTrace? stackTrace,
  }) {
    _triggerCleanup();

    final logLevel = level ?? protocol.LogLevel.info;
    final logSettings = _settingsForSession(_session);
    if (logLevel.index < logSettings.logLevel.index) return;

    final order = ++_nextEntryOrder;
    _dispatch(
      SessionLogEntry(
        sessionId: _open.sessionId,
        order: order,
        time: DateTime.now(),
        level: _toSessionLogLevel(logLevel),
        message: message,
        error: error,
        stackTrace: stackTrace,
        messageId: _session.messageId,
      ),
    );
  }

  /// Logs a database query within this session.
  @internal
  void logQuery({
    required String query,
    required Duration duration,
    required int? numRowsAffected,
    required String? error,
    required StackTrace stackTrace,
  }) {
    _triggerCleanup();
    _queryCount++;

    final executionTime = duration.inMicroseconds / _microNormalizer;
    final logSettings = _settingsForSession(_session);
    final slow = executionTime >= logSettings.slowQueryDuration;

    if (!logSettings.logAllQueries &&
        !(logSettings.logSlowQueries && slow) &&
        !(logSettings.logFailedQueries && error != null)) {
      return;
    }

    final order = ++_nextEntryOrder;
    _dispatch(
      SessionQueryEntry(
        sessionId: _open.sessionId,
        order: order,
        time: DateTime.now(),
        query: query,
        duration: duration,
        slow: slow,
        numRowsAffected: numRowsAffected,
        error: error,
        stackTrace: stackTrace,
        messageId: _session.messageId,
      ),
    );
  }

  /// Logs a streaming message within this session.
  @internal
  void logMessage({
    required String endpointName,
    required String messageName,
    required int messageId,
    required Duration duration,
    required String? error,
    required StackTrace? stackTrace,
  }) {
    _triggerCleanup();

    final executionTime = duration.inMicroseconds / _microNormalizer;
    final logSettings = _settingsForSession(_session);
    final slow = executionTime >= logSettings.slowSessionDuration;

    if (!logSettings.logAllSessions &&
        !(logSettings.logSlowSessions && slow) &&
        !(logSettings.logFailedSessions && error != null)) {
      return;
    }

    final order = ++_nextEntryOrder;
    _dispatch(
      SessionMessageEntry(
        sessionId: _open.sessionId,
        order: order,
        time: DateTime.now(),
        endpoint: endpointName,
        messageName: messageName,
        messageId: messageId,
        duration: duration,
        slow: slow,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  /// Drains any in-flight writes without closing the session.
  @internal
  Future<void> flush() => _log.flush();

  /// Finalizes the session log. Called when the session closes.
  @internal
  Future<void> finalizeLog(
    Session session, {
    String? authenticatedUserId,
    String? exception,
    StackTrace? stackTrace,
  }) async {
    _stopwatch.stop();
    final duration = session.duration;
    final logSettings = _settingsForSession(session);

    final slowMicros = (logSettings.slowSessionDuration * _microNormalizer)
        .toInt();
    final isSlow =
        duration > Duration(microseconds: slowMicros) &&
        !_disableSlowSessionLogging;

    final shouldEmit =
        logSettings.logAllSessions ||
        (logSettings.logSlowSessions && isSlow) ||
        (logSettings.logFailedSessions && exception != null) ||
        _opened ||
        _hasBufferedEvents;

    if (shouldEmit) {
      _ensureOpened();
      for (final entry in _buffered) {
        _log.record(entry);
      }
      _buffered.clear();
    }

    _closed = true;
    await _log.flush();

    if (!shouldEmit) return;

    _log.close(
      SessionClose(
        sessionId: _open.sessionId,
        duration: _stopwatch.elapsed,
        success: exception == null,
        slow: isSlow,
        numQueries: _queryCount,
        authenticatedUserId: authenticatedUserId,
        error: exception != null ? Exception(exception) : null,
        stackTrace: stackTrace,
      ),
    );
    await _log.flush();
  }
}

import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod/src/server/log_manager/log_writers.dart';
import 'package:serverpod/src/server/session.dart';
import 'package:synchronized/synchronized.dart';

import '../../generated/protocol.dart';

const double _microNormalizer = 1000 * 1000;

const int _temporarySessionId = -1;

@internal
class SessionLogManager {
  final String _serverId;

  final Session _session;

  final LogWriter _logWriter;

  final bool _disableSlowSessionLogging;

  final LogSettings Function(Session) _settingsForSession;

  final _FutureTaskManager _logTasks;

  int _numberOfQueries;

  int _logOrderId;

  int get _nextLogOrderId => ++_logOrderId;

  bool _isLoggingOpened;

  /// Creates a new [LogManager] from [RuntimeSettings].
  @internal
  SessionLogManager(
    LogWriter logWriter, {
    required Session session,
    required LogSettings Function(Session) settingsForSession,
    required String serverId,
    bool disableLoggingSlowSessions = false,
  })  : _logOrderId = 0,
        _numberOfQueries = 0,
        _logWriter = logWriter,
        _settingsForSession = settingsForSession,
        _serverId = serverId,
        _isLoggingOpened = false,
        _disableSlowSessionLogging = disableLoggingSlowSessions,
        _session = session,
        _logTasks = _FutureTaskManager() {
    var settings = _settingsForSession(session);
    if (!settings.logAllSessions) return;

    unawaited(_openLog(session));
  }

  bool _shouldLogQuery({
    required Session session,
    required bool slow,
    required bool failed,
  }) {
    var logSettings = _settingsForSession(session);
    if (logSettings.logAllQueries) {
      return true;
    }
    if (logSettings.logSlowQueries && slow) {
      return true;
    }
    if (logSettings.logFailedQueries && failed) {
      return true;
    }
    return false;
  }

  bool _shouldLogEntry({
    required Session session,
    required LogEntry entry,
  }) {
    var logSettings = _settingsForSession(session);
    var serverLogLevel = (logSettings.logLevel);

    return entry.logLevel.index >= serverLogLevel.index;
  }

  bool _shouldLogMessage({
    required Session session,
    required String endpoint,
    required bool slow,
    required bool failed,
  }) {
    var logSettings = _settingsForSession(session);
    if (logSettings.logAllSessions) {
      return true;
    }
    if (logSettings.logSlowSessions && slow) {
      return true;
    }
    if (logSettings.logFailedSessions && failed) {
      return true;
    }
    return false;
  }

  /// Logs an entry, depending on the session type it will be logged directly
  /// or stored in the temporary cache until the session is closed.
  /// This method can be called asynchronously.
  @internal
  Future<void> logEntry({
    LogLevel? level,
    required String message,
    String? error,
    StackTrace? stackTrace,
  }) async {
    var entry = LogEntry(
      sessionLogId: _temporarySessionId,
      serverId: _serverId,
      messageId: _session.messageId,
      logLevel: level ?? LogLevel.info,
      message: message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace?.toString(),
      order: _nextLogOrderId,
    );

    if (!_shouldLogEntry(session: _session, entry: entry)) {
      return;
    }

    await _internalLogger(
      'ENTRY',
      _session,
      entry,
      _logWriter.logEntry,
    );
  }

  /// Logs a query, depending on the session type it will be logged directly
  /// or stored in the temporary cache until the session is closed.
  /// This method can be called asynchronously.
  @internal
  Future<void> logQuery({
    required String query,
    required Duration duration,
    required int? numRowsAffected,
    required String? error,
    required StackTrace stackTrace,
  }) async {
    var executionTime = duration.inMicroseconds / _microNormalizer;
    _numberOfQueries++;

    var logSettings = _settingsForSession(_session);

    var slow = executionTime >= logSettings.slowQueryDuration;
    var shouldLog = _shouldLogQuery(
      session: _session,
      slow: slow,
      failed: error != null,
    );

    if (!shouldLog) return;

    var entry = QueryLogEntry(
      sessionLogId: _temporarySessionId,
      serverId: _serverId,
      query: query,
      messageId: _session.messageId,
      duration: executionTime,
      numRows: numRowsAffected,
      error: error,
      stackTrace: stackTrace.toString(),
      slow: slow,
      order: _nextLogOrderId,
    );

    await _internalLogger(
      'QUERY',
      _session,
      entry,
      _logWriter.logQuery,
    );
  }

  /// Logs a message from a stream, depending on the session type it will be
  /// logged directly or stored in the temporary cache until the session is
  /// closed. This method can be called asynchronously.
  @internal
  Future<void> logMessage({
    required String endpointName,
    required String messageName,
    required int messageId,
    required Duration duration,
    required String? error,
    required StackTrace? stackTrace,
  }) async {
    var executionTime = duration.inMicroseconds / _microNormalizer;

    var slow =
        executionTime >= _settingsForSession(_session).slowSessionDuration;

    var shouldLog = _shouldLogMessage(
      session: _session,
      endpoint: endpointName,
      slow: slow,
      failed: error != null,
    );

    if (!shouldLog) return;

    var entry = MessageLogEntry(
      sessionLogId: _temporarySessionId,
      serverId: _serverId,
      messageId: messageId,
      endpoint: endpointName,
      messageName: messageName,
      duration: executionTime,
      order: _nextLogOrderId,
      error: error,
      stackTrace: stackTrace?.toString(),
      slow: slow,
    );

    await _internalLogger(
      'MESSAGE',
      _session,
      entry,
      _logWriter.logMessage,
    );
  }

  Future<void> _internalLogger<T extends TableRow>(
    String type,
    Session session,
    T entry,
    Future<void> Function(T) writeLog,
  ) async {
    // Skip checking the lock if logging is already opened.
    // This makes the execution faster as we skip a roundtrip in the event loop.
    if (!_isLoggingOpened) await _openLog(session);

    try {
      _logTasks.addTask(() => writeLog(entry));
    } catch (exception, stackTrace) {
      stderr.writeln('${DateTime.now().toUtc()} FAILED TO LOG $type');
      stderr.write('ENDPOINT: ${session.endpoint}');
      stderr.writeln('CALL error: $exception');
      stderr.writeln('$stackTrace');
    }
  }

  final Lock _openLogLock = Lock();

  Future<void> _openLog(Session session) async {
    await _openLogLock.synchronized(() async {
      if (_isLoggingOpened) return;

      var now = DateTime.now();

      var sessionLogEntry = SessionLogEntry(
        serverId: _serverId,
        time: now,
        touched: now,
        endpoint: session.endpoint,
        method: session.method,
        isOpen: true,
      );

      await _logWriter.openLog(sessionLogEntry);

      _isLoggingOpened = true;
    });
  }

  /// Called automatically when a session is closed. Writes the session and its
  /// logs to the database, if configuration says so.
  @internal
  Future<int?> finalizeLog(
    Session session, {
    String? authenticatedUserId,
    String? exception,
    StackTrace? stackTrace,
  }) async {
    await _openLogLock.synchronized(() {});
    await _logTasks.awaitAllTasks();

    var duration = session.duration;
    LogSettings logSettings = _settingsForSession(session);

    var slowMicros =
        (logSettings.slowSessionDuration * _microNormalizer).toInt();
    var isSlow = duration > Duration(microseconds: slowMicros) &&
        !_disableSlowSessionLogging;

    if (logSettings.logAllSessions ||
        (logSettings.logSlowSessions && isSlow) ||
        (logSettings.logFailedSessions && exception != null) ||
        _isLoggingOpened) {
      var now = DateTime.now();

      var sessionLogEntry = SessionLogEntry(
        serverId: _serverId,
        time: now,
        touched: now,
        endpoint: session.endpoint,
        method: session.method,
        duration: duration.inMicroseconds / _microNormalizer,
        numQueries: _numberOfQueries,
        isOpen: false,
        slow: isSlow,
        error: exception,
        stackTrace: stackTrace?.toString(),
        // TODO: Support non-`int` user IDs https://github.com/serverpod/serverpod/issues/3448
        authenticatedUserId: authenticatedUserId == null
            ? null
            : int.tryParse(authenticatedUserId),
      );

      try {
        return await _logWriter.closeLog(sessionLogEntry);
      } catch (e, logStackTrace) {
        stderr.writeln('${DateTime.now().toUtc()} FAILED TO LOG SESSION');
        stderr.writeln(
            'CALL: ${session.callName} duration: ${duration.inMilliseconds}ms numQueries: $_numberOfQueries authenticatedUser: $authenticatedUserId');
        if (exception != null) {
          stderr.writeln('CALL error: $exception');
          stderr.writeln('$stackTrace');
        }

        stderr.writeln('LOG ERROR: $e');
        stderr.writeln('$logStackTrace');
      }
    }
    return null;
  }
}

/// The [LogManager] handles logging and logging settings. Typically only used
/// internally by Serverpod.
class LogManager {
  /// The [RuntimeSettings] the log manager retrieves its settings from.
  @Deprecated('Will be removed in 3.0.0')
  final RuntimeSettings runtimeSettings;

  /// Creates a new [LogManager] from [RuntimeSettings].
  LogManager(
    this.runtimeSettings, {
    required String serverId,
  });
}

extension on Session {
  String get callName {
    if (method != null) {
      return '$endpoint.$method';
    }
    return endpoint;
  }
}

typedef _TaskCallback = Future<void> Function();

class _FutureTaskManager {
  final Set<_TaskCallback> _pendingTasks = {};

  Completer<void>? _tasksCompleter;

  /// Synchronously adds a task to the task manager.
  void addTask(_TaskCallback task) {
    _tasksCompleter ??= Completer<void>();
    _pendingTasks.add(task);

    task().then((value) {
      _completeTask(task);
    }).onError((error, stackTrace) {
      _completeTask(task);
      var e = error;
      if (e is Exception) throw e;
      if (e is Error) throw e;
    });
  }

  void _completeTask(_TaskCallback task) {
    _pendingTasks.remove(task);

    var tasksCompleter = _tasksCompleter;
    if (_pendingTasks.isEmpty && tasksCompleter != null) {
      tasksCompleter.complete();
      _tasksCompleter = null;
    }
  }

  Future<void> awaitAllTasks() {
    var completer = _tasksCompleter;

    if (completer == null) {
      return Future.value();
    } else {
      return completer.future;
    }
  }
}

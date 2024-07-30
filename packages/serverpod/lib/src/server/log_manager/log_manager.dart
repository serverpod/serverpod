import 'dart:io';
import 'package:meta/meta.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod/src/server/log_manager/log_writers.dart';
import 'package:serverpod/src/server/session.dart';
import 'package:synchronized/synchronized.dart';

import '../../../server.dart';
import '../../generated/protocol.dart';

const double _microNormalizer = 1000 * 1000;

const int _temporarySessionId = -1;

@internal
class SessionLogManager {
  final String _serverId;

  final LogWriter _logWriter;

  final LogSettings Function(Session) _settingsForSession;

  int _numberOfQueries = 0;

  int _logOrderId;

  bool _isLoggingOpened;

  int get _nextLogOrderId => ++_logOrderId;

  /// Creates a new [LogManager] from [RuntimeSettings].
  @internal
  SessionLogManager(
    LogWriter logWriter, {
    required LogSettings Function(Session) settingsForSession,
    required String serverId,
  })  : _logOrderId = 0,
        _logWriter = logWriter,
        _settingsForSession = settingsForSession,
        _serverId = serverId,
        _isLoggingOpened = false;

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
  Future<void> logEntry(
    Session session, {
    int? messageId,
    LogLevel? level,
    required String message,
    String? error,
    StackTrace? stackTrace,
  }) async {
    var entry = LogEntry(
      sessionLogId: _temporarySessionId,
      serverId: _serverId,
      messageId: messageId,
      logLevel: level ?? LogLevel.info,
      message: message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace?.toString(),
      order: _nextLogOrderId,
    );

    if (session.serverpod.runMode == ServerpodRunMode.development) {
      stdout.writeln('${entry.logLevel.name.toUpperCase()}: ${entry.message}');
      if (entry.error != null) stdout.writeln(entry.error);
      if (entry.stackTrace != null) stdout.writeln(entry.stackTrace);
    }

    if (!_shouldLogEntry(session: session, entry: entry)) {
      return;
    }

    await _internalLogger(
      'ENTRY',
      session,
      entry,
      _logWriter.logEntry,
    );
  }

  /// Logs a query, depending on the session type it will be logged directly
  /// or stored in the temporary cache until the session is closed.
  /// This method can be called asynchronously.
  @internal
  Future<void> logQuery(
    Session session, {
    required String query,
    required Duration duration,
    required int? numRowsAffected,
    required String? error,
    required StackTrace stackTrace,
  }) async {
    var executionTime = duration.inMicroseconds / _microNormalizer;

    var logSettings = _settingsForSession(session);

    var slow = executionTime >= logSettings.slowQueryDuration;
    var shouldLog = _shouldLogQuery(
      session: session,
      slow: slow,
      failed: error != null,
    );

    if (!shouldLog) return;

    var entry = QueryLogEntry(
      sessionLogId: _temporarySessionId,
      serverId: _serverId,
      query: query,
      duration: executionTime,
      numRows: numRowsAffected,
      error: error,
      stackTrace: stackTrace.toString(),
      slow: slow,
      order: _nextLogOrderId,
    );

    await _internalLogger(
      'QUERY',
      session,
      entry,
      _logWriter.logQuery,
    );

    _numberOfQueries++;
  }

  /// Logs a message from a stream, depending on the session type it will be
  /// logged directly or stored in the temporary cache until the session is
  /// closed. This method can be called asynchronously.
  @internal
  Future<void> logMessage(
    Session session, {
    required String endpointName,
    required String messageName,
    required int messageId,
    required Duration duration,
    required String? error,
    required StackTrace? stackTrace,
  }) async {
    var executionTime = duration.inMicroseconds / _microNormalizer;

    var slow =
        executionTime >= _settingsForSession(session).slowSessionDuration;

    var shouldLog = _shouldLogMessage(
      session: session,
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
      session,
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
    if (!_isLoggingOpened) {
      await _openLog(session);
    }
    try {
      await writeLog(entry);
    } catch (exception, stackTrace) {
      stderr.writeln('${DateTime.now().toUtc()} FAILED TO LOG $type');
      stderr.write('ENDPOINT: ${session.endpointName}');
      stderr.writeln('CALL error: $exception');
      stderr.writeln('$stackTrace');
    }
  }

  final Lock _openingLock = Lock();

  Future<void> _openLog(Session session) async {
    await _openingLock.synchronized(() async {
      if (_isLoggingOpened) return;

      var now = DateTime.now();

      var sessionLogEntry = SessionLogEntry(
        serverId: _serverId,
        time: now,
        touched: now,
        endpoint: session.endpointName,
        method: session.methodName,
        isOpen: true,
      );

      await _logWriter.openLog(
        sessionLogEntry,
      );

      _isLoggingOpened = true;
    });
  }

  /// Called automatically when a session is closed. Writes the session and its
  /// logs to the database, if configuration says so.
  @internal
  Future<int?> finalizeSessionLog(
    Session session, {
    int? authenticatedUserId,
    String? exception,
    StackTrace? stackTrace,
  }) async {
    var duration = session.duration;
    LogSettings logSettings = _settingsForSession(session);

    if (session.serverpod.runMode == ServerpodRunMode.development) {
      stdout.writeln(
        'CALL: ${session.callName} duration: ${duration.inMilliseconds}ms numQueries: $_numberOfQueries authenticatedUser: $authenticatedUserId',
      );

      if (exception != null) {
        stdout.writeln(exception);
        stdout.writeln('$stackTrace');
      }
    }

    var slowMicros =
        (logSettings.slowSessionDuration * _microNormalizer).toInt();
    var isSlow =
        duration > Duration(microseconds: slowMicros) && !session.isLongLived;

    if (logSettings.logAllSessions ||
        (logSettings.logSlowSessions && isSlow) ||
        (logSettings.logFailedSessions && exception != null) ||
        _isLoggingOpened) {
      var now = DateTime.now();

      var sessionLogEntry = SessionLogEntry(
        serverId: _serverId,
        time: now,
        touched: now,
        endpoint: session.endpointName,
        method: session.methodName,
        duration: duration.inMicroseconds / _microNormalizer,
        numQueries: _numberOfQueries,
        slow: isSlow,
        error: exception,
        isOpen: false,
        stackTrace: stackTrace?.toString(),
        authenticatedUserId: authenticatedUserId,
      );

      try {
        return await _logWriter.closeLog(sessionLogEntry);
      } catch (e, logStackTrace) {
        stderr.writeln('${DateTime.now().toUtc()} FAILED TO LOG SESSION');
        stderr.writeln(
            'CALL: ${session.callName} duration: ${duration.inMilliseconds}ms numQueries: $_numberOfQueries authenticatedUser: $authenticatedUserId');
        stderr.writeln('CALL error: $exception');
        stderr.writeln('$logStackTrace');

        stderr.writeln('LOG ERRORS');
        stderr.writeln('$e');
        stderr.writeln('$logStackTrace');
        stderr.writeln('Current stacktrace:');
        stderr.writeln('${StackTrace.current}');
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

  int _nextTemporarySessionId = -1;

  /// Returns a new unique temporary session id. The id will be negative, and
  /// ids are only unique to this running instance.
  int nextTemporarySessionId() {
    var id = _nextTemporarySessionId;
    _nextTemporarySessionId -= 1;
    return id;
  }

  /// Creates a new [LogManager] from [RuntimeSettings].
  LogManager(
    this.runtimeSettings, {
    required String serverId,
  });
}

extension on Session {
  String get callName {
    if (methodName != null) {
      return '$endpointName.$methodName';
    }
    return endpointName;
  }
}

import 'dart:io';
import 'package:meta/meta.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod/src/util/terminal_colors.dart';
import 'package:synchronized/synchronized.dart';

import '../../server.dart';
import '../generated/protocol.dart';

/// The interface for writing logs. The implementation will decide where the logs
/// are written.
abstract class LogWriter {
  /// Logs a query from a stream.
  Future<void> logStreamQuery(StreamingSession session, QueryLogEntry entry);

  /// Logs an entry from a stream.
  Future<void> logStreamEntry(StreamingSession session, LogEntry entry);

  /// Logs a message from a stream.
  Future<void> logStreamMessage(
    StreamingSession session,
    MessageLogEntry entry,
  );

  /// Opens a new streaming log and returns the id of the log.
  /// The id is used to identify the log when writing log entries so that
  /// they can be identified to  a single session.
  Future<int> openStreamingLog(StreamingSession session, SessionLogEntry entry);

  /// Closes a streaming log.
  /// This marks the end of all logs from this session.
  Future<void> closeStreamingLog(
    StreamingSession session,
    SessionLogEntry entry,
  );

  ///
  Future<void> logAllCached(
    Session session,
    SessionLogEntry sessionLogEntry,
    SessionLogEntryCache cache,
  );
}

/// Logs all output to the database
class DatabaseLogWriter extends LogWriter {
  @override
  Future<void> logStreamEntry(StreamingSession session, LogEntry entry) async {
    await _databaseLog(session, entry);
  }

  @override
  Future<void> logStreamMessage(
      StreamingSession session, MessageLogEntry entry) async {
    await _databaseLog(session, entry);
  }

  @override
  Future<void> logStreamQuery(
    StreamingSession session,
    QueryLogEntry entry,
  ) async {
    await _databaseLog<QueryLogEntry>(session, entry);
  }

  @override
  Future<int> openStreamingLog(
    StreamingSession session,
    SessionLogEntry entry,
  ) async {
    var sessionLog = await _databaseLog(session, entry);
    return sessionLog.id!;
  }

  @override
  Future<void> closeStreamingLog(
    StreamingSession session,
    SessionLogEntry entry,
  ) async {
    var tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    await SessionLogEntry.db.updateRow(tempSession, entry);

    await tempSession.close();
  }

  Future<T> _databaseLog<T extends TableRow>(
    StreamingSession session,
    T entry,
  ) async {
    var tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    var result = await tempSession.dbNext.insertRow<T>(entry);

    await tempSession.close();

    return result;
  }

  @override
  Future<void> logAllCached(
    Session session,
    SessionLogEntry sessionLogEntry,
    SessionLogEntryCache cache,
  ) async {
    var tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    var sessionLog =
        await tempSession.dbNext.insertRow<SessionLogEntry>(sessionLogEntry);
    var sessionLogId = sessionLog.id!;

    // Write log entries
    for (var logInfo in cache.logEntries) {
      logInfo.sessionLogId = sessionLogId;
      await tempSession.dbNext.insertRow<LogEntry>(logInfo);
    }
    // Write queries
    for (var queryInfo in cache.queries) {
      queryInfo.sessionLogId = sessionLogId;
      await tempSession.dbNext.insertRow<QueryLogEntry>(queryInfo);
    }
    // Write streaming messages
    for (var messageInfo in cache.messages) {
      messageInfo.sessionLogId = sessionLogId;
      await tempSession.dbNext.insertRow<MessageLogEntry>(messageInfo);
    }

    await tempSession.close();
  }
}

/// Logs all output to standard out.
class StdOutLogWriter extends LogWriter {
  int _sessionLogId = 0;

  int _nextSessionId() {
    _sessionLogId += 1;
    return _sessionLogId;
  }

  @override
  Future<void> logStreamEntry(StreamingSession session, LogEntry entry) async {
    stdout.writeln(entry);
  }

  @override
  Future<void> logStreamMessage(
      StreamingSession session, MessageLogEntry entry) async {
    stdout.writeln(entry);
  }

  @override
  Future<void> logStreamQuery(
      StreamingSession session, QueryLogEntry entry) async {
    stdout.writeln(entry);
  }

  @override
  Future<int> openStreamingLog(
    Session session,
    SessionLogEntry entry,
  ) async {
    entry.id = _nextSessionId();
    stdout.writeln(entry.toString());
    return entry.id!;
  }

  @override
  Future<void> closeStreamingLog(
    StreamingSession session,
    SessionLogEntry entry,
  ) async {
    stdout.writeln(entry);
  }

  @override
  Future<void> logAllCached(
    Session session,
    SessionLogEntry sessionLogEntry,
    SessionLogEntryCache cache,
  ) async {
    var sessionLogId = await openStreamingLog(session, sessionLogEntry);

    // Write log entries
    for (var logInfo in cache.logEntries) {
      logInfo.sessionLogId = sessionLogId;
      stdout.writeln(logInfo);
    }
    // Write queries
    for (var queryInfo in cache.queries) {
      queryInfo.sessionLogId = sessionLogId;
      stdout.writeln(queryInfo);
    }
    // Write streaming messages
    for (var messageInfo in cache.messages) {
      messageInfo.sessionLogId = sessionLogId;
      stdout.writeln(messageInfo);
    }
  }
}

/// The [LogManager] handles logging and logging settings. Typically only used
/// internally by Serverpod.
class LogManager {
  /// The [RuntimeSettings] the log manager retrieves its settings from.
  final RuntimeSettings runtimeSettings;

  final LogWriter _logWriter;

  final Map<String, LogSettings> _endpointOverrides = {};
  final Map<String, LogSettings> _methodOverrides = {};

  final List<SessionLogEntryCache> _openSessionLogs = [];

  int _nextTemporarySessionId = -1;

  /// Returns a new unique temporary session id. The id will be negative, and
  /// ids are only unique to this running instance.
  int nextTemporarySessionId() {
    var id = _nextTemporarySessionId;
    _nextTemporarySessionId -= 1;
    return id;
  }

  /// Creates a new [LogManager] from [RuntimeSettings].
  LogManager(this.runtimeSettings, LogWriter logWriter)
      : _logWriter = logWriter {
    for (var override in runtimeSettings.logSettingsOverrides) {
      if (override.method != null && override.endpoint != null) {
        _methodOverrides['${override.endpoint}.${override.method}'] =
            override.logSettings;
      } else if (override.endpoint != null) {
        _endpointOverrides['${override.endpoint}'] = override.logSettings;
      }
    }
  }

  /// Gets the log settings for a [MethodCallSession].
  LogSettings _getLogSettingsForMethodCallSession(
    String endpoint,
    String method,
  ) {
    var settings = _methodOverrides['$endpoint.$method'];
    if (settings != null) return settings;

    settings = _endpointOverrides[endpoint];
    if (settings != null) return settings;

    return runtimeSettings.logSettings;
  }

  /// Gets the log settings for a [InternalSession].
  LogSettings _getLogSettingsForInternalSession() {
    return runtimeSettings.logSettings;
  }

  /// Gets the log settings for a [StreamingSession].
  LogSettings getLogSettingsForStreamingSession({required String endpoint}) {
    var settings = _endpointOverrides[endpoint];
    if (settings != null) return settings;

    return runtimeSettings.logSettings;
  }

  /// Gets the log settings for a [FutureCallSession].
  LogSettings _getLogSettingsForFutureCallSession(String call) {
    return runtimeSettings.logSettings;
  }

  /// Returns the [LogSettings] for a specific session.
  LogSettings getLogSettingsForSession(Session session) {
    if (session is MethodCallSession) {
      return _getLogSettingsForMethodCallSession(
          session.endpointName, session.methodName);
    } else if (session is StreamingSession) {
      assert(
        session.sessionLogs.currentEndpoint != null,
        'currentEndpoint for the StreamingSession must be set.',
      );
      return getLogSettingsForStreamingSession(
        endpoint: session.sessionLogs.currentEndpoint!,
      );
    } else if (session is InternalSession) {
      return _getLogSettingsForInternalSession();
    } else if (session is FutureCallSession) {
      return _getLogSettingsForFutureCallSession(session.futureCallName);
    }
    throw UnimplementedError('Unknown session type');
  }

  /// Initializes the logging for a session, automatically called when a session
  /// is created. Each call to this method should have a corresponding
  /// [finalizeSessionLog] call.
  SessionLogEntryCache initializeSessionLog(Session session) {
    var logEntry = SessionLogEntryCache(session);
    _openSessionLogs.add(logEntry);
    return logEntry;
  }

  /// Returns true if a query should be logged based on the current session and
  /// its duration and if it failed.
  @internal
  bool shouldLogQuery({
    required Session session,
    required bool slow,
    required bool failed,
  }) {
    var logSettings = getLogSettingsForSession(session);
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

  /// Returns true if a log entry should be stored for the provided session.
  @internal
  bool shouldLogEntry({
    required Session session,
    required LogEntry entry,
  }) {
    var logSettings = getLogSettingsForSession(session);
    var serverLogLevel = (logSettings.logLevel);

    return entry.logLevel.index >= serverLogLevel.index;
  }

  /// Returns true if a message should be logged for the provided session.
  @internal
  bool shouldLogMessage({
    required StreamingSession session,
    required String endpoint,
    required bool slow,
    required bool failed,
  }) {
    var logSettings = getLogSettingsForStreamingSession(endpoint: endpoint);
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

  bool _continuouslyLogging(Session session) =>
      session is StreamingSession &&
      session.sessionLogId != null &&
      session.sessionLogId! >= 0;

  /// Logs an entry, depending on the session type it will be logged directly
  /// to the database or stored in the temporary cache until the session is
  /// closed. Call [shouldLogEntry] to check if the entry should be logged
  /// before calling this method. This method can be called asyncronously.
  @internal
  Future<void> logEntry(Session session, LogEntry entry) async {
    await _internalLogger(
      'ENTRY',
      session,
      entry,
      session.sessionLogs.logEntries,
      _logWriter.logStreamEntry,
      (sessionLogId, entry) => entry.sessionLogId = sessionLogId,
    );
  }

  /// Logs a query, depending on the session type it will be logged directly
  /// to the database or stored in the temporary cache until the session is
  /// closed. Call [shouldLogQuery] to check if the entry should be logged
  /// before calling this method. This method can be called asyncronously.
  @internal
  Future<void> logQuery(Session session, QueryLogEntry entry) async {
    await _internalLogger(
      'QUERY',
      session,
      entry,
      session.sessionLogs.queries,
      _logWriter.logStreamQuery,
      (sessionLogId, entry) => entry.sessionLogId = sessionLogId,
    );
  }

  /// Logs a message from a stream, depending on the session type it will be
  /// logged directly to the database or stored in the temporary cache until the
  /// session is closed. Call [shouldLogMessage] to check if the entry should be
  /// logged before calling this method. This method can be called
  /// asyncronously.
  @internal
  Future<void> logMessage(Session session, MessageLogEntry entry) async {
    await _internalLogger(
      'MESSAGE',
      session,
      entry,
      session.sessionLogs.messages,
      _logWriter.logStreamMessage,
      (sessionLogId, entry) => entry.sessionLogId = sessionLogId,
    );
  }

  Future<void> _internalLogger<T extends TableRow>(
    String type,
    Session session,
    T entry,
    List<T> logCollector,
    Future<void> Function(StreamingSession, T) writeLog,
    Function(int, T) setSessionLogId,
  ) async {
    await _attemptOpenStreamingLog(session: session);
    if (_continuouslyLogging(session) && session is StreamingSession) {
      try {
        setSessionLogId(session.sessionLogId!, entry);
        await writeLog(session, entry);
      } catch (exception, stackTrace) {
        stderr
            .writeln('${DateTime.now().toUtc()} FAILED TO LOG STREAMING $type');
        stderr.write('ENDPOINT: ${_endpointForSession(session)}');
        stderr.writeln('CALL error: $exception');
        stderr.writeln('$stackTrace');
      }
    } else {
      logCollector.add(entry);
    }
  }

  final Lock _openStreamLogLock = Lock();

  /// Sets up a log for a streaming session. Instead of writing all session data
  /// when the session is completed the session will be continuously logged.
  Future<void> _attemptOpenStreamingLog({
    required Session session,
  }) async {
    await _openStreamLogLock.synchronized(() async {
      if (session is! StreamingSession) {
        // Only open streaming logs for streaming sessions.
        return;
      }

      if (session.sessionLogId != null) {
        // Streaming log is already opened.
        return;
      }

      assert(session.sessionLogs.currentEndpoint != null);

      var logSettings = getLogSettingsForStreamingSession(
        endpoint: session.sessionLogs.currentEndpoint!,
      );
      if (!logSettings.logStreamingSessionsContinuously) {
        // This call should not stream continuously.
        return;
      }

      var now = DateTime.now();

      var sessionLogEntry = SessionLogEntry(
        serverId: session.server.serverId,
        time: now,
        touched: now,
        endpoint: _endpointForSession(session),
        method: _methodForSession(session),
        isOpen: true,
      );

      var sessionLogId = await _logWriter.openStreamingLog(
        session,
        sessionLogEntry,
      );

      session.sessionLogId = sessionLogId;
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
    // Remove from open sessions
    _openSessionLogs.removeWhere((logEntry) => logEntry.session == session);

    // If verbose logging is enabled, output otherwise unlogged exceptions to
    // console.
    if (exception != null && !session.enableLogging) {
      session.serverpod.logVerbose(exception);
      if (stackTrace != null) {
        session.serverpod.logVerbose(stackTrace.toString());
      }
    }

    // Check if we should log to database
    if (!session.enableLogging) return null;

    // Log session to database
    var duration = session.duration;
    var cachedEntry = session.sessionLogs;
    LogSettings? logSettings;
    if (session is! StreamingSession) {
      logSettings = getLogSettingsForSession(session);
    }

    // Output to console in development mode.
    if (session.serverpod.runMode == ServerpodRunMode.development) {
      if (session is MethodCallSession) {
        String prefix = TerminalColors.colorize('METHOD CALL', 'method');
        stdout.writeln(
            '$prefix: ${session.endpointName}.${session.methodName} duration: ${duration.inMilliseconds}ms numQueries: ${cachedEntry.queries.length} authenticatedUser: $authenticatedUserId');
      } else if (session is FutureCallSession) {
        String prefix = TerminalColors.colorize('FUTURE CALL', 'future');
        stdout.writeln(
            '$prefix: ${session.futureCallName} duration: ${duration.inMilliseconds}ms numQueries: ${cachedEntry.queries.length}');
      }
      if (exception != null) {
        stdout.writeln(exception);
        stdout.writeln('$stackTrace');
      }
    }

    var isSlow = false;

    if (logSettings != null) {
      var slowMicros = (logSettings.slowSessionDuration * 1000000.0).toInt();
      isSlow = duration > Duration(microseconds: slowMicros) &&
          session is! StreamingSession;
    }

    if ((logSettings?.logAllSessions ?? false) ||
        (logSettings?.logSlowSessions ?? false) && isSlow ||
        (logSettings?.logFailedSessions ?? false) && exception != null ||
        cachedEntry.queries.isNotEmpty ||
        cachedEntry.logEntries.isNotEmpty ||
        cachedEntry.messages.isNotEmpty ||
        _continuouslyLogging(session)) {
      int? sessionLogId;

      var now = DateTime.now();

      var sessionLogEntry = SessionLogEntry(
        serverId: session.server.serverId,
        time: now,
        touched: now,
        endpoint: _endpointForSession(session),
        method: _methodForSession(session),
        duration: duration.inMicroseconds / 1000000.0,
        numQueries: cachedEntry.numQueries,
        slow: isSlow,
        error: exception,
        stackTrace: stackTrace?.toString(),
        authenticatedUserId: authenticatedUserId,
      );

      try {
        if (_continuouslyLogging(session)) {
          // Close open session.
          session as StreamingSession;
          sessionLogId = session.sessionLogId!;
          sessionLogEntry.id = sessionLogId;
          sessionLogEntry.isOpen = false;
          await _logWriter.closeStreamingLog(session, sessionLogEntry);
        } else {
          await _logWriter.logAllCached(session, sessionLogEntry, cachedEntry);
        }
      } catch (e, logStackTrace) {
        stderr.writeln('${DateTime.now().toUtc()} FAILED TO LOG SESSION');
        if (_methodForSession(session) != null) {
          stderr.writeln(
              'CALL: ${_endpointForSession(session)}.${_methodForSession(session)} duration: ${duration.inMilliseconds}ms numQueries: ${cachedEntry.queries.length} authenticatedUser: $authenticatedUserId');
        }
        stderr.writeln('CALL error: $exception');
        stderr.writeln('$logStackTrace');

        stderr.writeln('LOG ERRORS');
        stderr.writeln('$e');
        stderr.writeln('$logStackTrace');
        stderr.writeln('Current stacktrace:');
        stderr.writeln('${StackTrace.current}');
      }

      return sessionLogId;
    }
    return null;
  }

  String? _methodForSession(Session session) {
    if (session is MethodCallSession) {
      // Method calls
      return session.methodName;
    } else if (session is FutureCallSession) {
      // Future calls
      return session.futureCallName;
    }
    return null;
  }

  /// Returns a list of logs for all open sessions.
  List<SessionLogInfo> getOpenSessionLogs(
      int numEntries, SessionLogFilter? filter) {
    var sessionLog = <SessionLogInfo>[];

    var numFoundEntries = 0;
    var i = 0;
    while (i < _openSessionLogs.length && numFoundEntries < numEntries) {
      var entry = _openSessionLogs[i];
      i += 1;

      // Check filter (ignore slow and errors as session is still open)
      if (filter != null) {
        var session = entry.session;
        if (session is MethodCallSession) {
          if (filter.endpoint != null &&
              filter.endpoint != '' &&
              session.endpointName != filter.endpoint) {
            continue;
          }
          if (filter.endpoint != null &&
              filter.endpoint != '' &&
              filter.method != null &&
              filter.method != '' &&
              session.endpointName != filter.endpoint &&
              session.methodName != filter.method) {
            continue;
          }
        }
      }

      // Add to list
      sessionLog.add(
        SessionLogInfo(
          sessionLogEntry: SessionLogEntry(
            serverId: Serverpod.instance.serverId,
            time: entry.session.startTime,
            touched: DateTime.now(),
            endpoint: _endpointForSession(entry.session),
            method: _methodForSession(entry.session),
            numQueries: entry.numQueries,
          ),
          queries: entry.queries,
          logs: entry.logEntries,
          messages: entry.messages,
        ),
      );
    }

    return sessionLog;
  }
}

/// The [SessionLogEntryCache] holds all logging information for a session before
/// it's written to the database.
class SessionLogEntryCache {
  /// A reference to the [Session].
  final Session session;

  /// Queries made during the session.
  final List<QueryLogEntry> queries = [];

  /// Number of queries made during this session.
  int numQueries = 0;

  /// Log entries made during the session.
  final List<LogEntry> logEntries = [];

  /// Streaming messages handled during the session.
  final List<MessageLogEntry> messages = [];

  /// A temporary session id used internally by the server.
  late int temporarySessionId;

  /// Name of streaming message currently being processed.
  String? currentEndpoint;

  /// This is used internally by Serverpod to ensure the ordering of log entries
  /// and log queries are correct.
  int currentLogOrderId = 0;

  /// Creates a new [SessionLogEntryCache].
  SessionLogEntryCache(this.session);
}

String _endpointForSession(Session session) {
  if (session is MethodCallSession) {
    // Method calls
    return session.endpointName;
  } else if (session is FutureCallSession) {
    // Future calls
    return 'FutureCallSession';
  } else if (session is StreamingSession) {
    // Streaming session was closed
    return 'StreamingSession';
  } else if (session is InternalSession) {
    // Internal session
    return 'InternalSession';
  }

  throw (UnimplementedError('Unknown Session type'));
}

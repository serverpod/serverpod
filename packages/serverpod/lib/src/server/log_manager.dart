import 'dart:io';
import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../../server.dart';
import '../generated/protocol.dart';

/// The [LogManager] handles logging and logging settings. Typically only used
/// internally by Serverpod.
class LogManager {
  /// The [RuntimeSettings] the log manager retrieves its settings from.
  final RuntimeSettings runtimeSettings;

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
  LogManager(this.runtimeSettings) {
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

    return entry.logLevel >= serverLogLevel;
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
      session is StreamingSession && session.sessionLogId != null;

  /// Logs an entry, depending on the session type it will be logged directly
  /// to the database or stored in the temporary cache until the session is
  /// closed. Call [shouldLogEntry] to check if the entry should be logged
  /// before calling this method. This method can be called asyncronously.
  @internal
  Future<void> logEntry(Session session, LogEntry entry) async {
    await _attemptOpenStreamingLog(session: session);

    if (_continuouslyLogging(session)) {
      // We are continuously writing to this sessions log.
      entry.sessionLogId = (session as StreamingSession).sessionLogId!;
      var tempSession = await session.serverpod.createSession(
        enableLogging: false,
      );
      try {
        await LogEntry.insert(tempSession, entry);
      } catch (exception, stackTrace) {
        stderr
            .writeln('${DateTime.now().toUtc()} FAILED TO LOG STREAMING ENTRY');
        stderr.write('ENDPOINT: ${_endpointForSession(session)}');
        stderr.writeln('CALL error: $exception');
        stderr.writeln('$stackTrace');
      }

      await tempSession.close();
    } else {
      session.sessionLogs.logEntries.add(entry);
    }
  }

  /// Logs a query, depending on the session type it will be logged directly
  /// to the database or stored in the temporary cache until the session is
  /// closed. Call [shouldLogQuery] to check if the entry should be logged
  /// before calling this method. This method can be called asyncronously.
  @internal
  Future<void> logQuery(Session session, QueryLogEntry entry) async {
    await _attemptOpenStreamingLog(session: session);

    if (_continuouslyLogging(session)) {
      // We are continuously writing to this sessions log.
      var tempSession = await session.serverpod.createSession(
        enableLogging: false,
      );
      try {
        await QueryLogEntry.insert(tempSession, entry);
      } catch (exception, stackTrace) {
        stderr
            .writeln('${DateTime.now().toUtc()} FAILED TO LOG STREAMING QUERY');
        stderr.write('ENDPOINT: ${_endpointForSession(session)}');
        stderr.writeln('CALL error: $exception');
        stderr.writeln('$stackTrace');
      }

      await tempSession.close();
    } else {
      session.sessionLogs.queries.add(entry);
    }
  }

  /// Logs a message from a stream, depending on the session type it will be
  /// logged directly to the database or stored in the temporary cache until the
  /// session is closed. Call [shouldLogMessage] to check if the entry should be
  /// logged before calling this method. This method can be called
  /// asyncronously.
  @internal
  Future<void> logMessage(Session session, MessageLogEntry entry) async {
    await _attemptOpenStreamingLog(session: session);

    if (_continuouslyLogging(session)) {
      // We are continuously writing to this sessions log.
      var tempSession = await session.serverpod.createSession(
        enableLogging: false,
      );
      try {
        entry.sessionLogId = (session as StreamingSession).sessionLogId!;
        await MessageLogEntry.insert(tempSession, entry);
      } catch (exception, stackTrace) {
        stderr
            .writeln('${DateTime.now().toUtc()} FAILED TO LOG STREAMING QUERY');
        stderr.write('ENDPOINT: ${_endpointForSession(session)}');
        stderr.writeln('CALL error: $exception');
        stderr.writeln('$stackTrace');
      }

      await tempSession.close();
    } else {
      session.sessionLogs.messages.add(entry);
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

      var tempSession = await session.serverpod.createSession(
        enableLogging: false,
      );

      var now = DateTime.now();

      var sessionLogEntry = SessionLogEntry(
        serverId: session.server.serverId,
        time: now,
        touched: now,
        endpoint: _endpointForSession(session),
        method: _methodForSession(session),
        isOpen: true,
      );

      await SessionLogEntry.insert(tempSession, sessionLogEntry);
      session.sessionLogId = sessionLogEntry.id;

      await tempSession.close();
    });
  }

  /// Called automatically when a session is closed. Writes the session and its
  /// logs to the database, if configuration says so.
  Future<int?> finalizeSessionLog(
    Session session, {
    int? authenticatedUserId,
    String? exception,
    StackTrace? stackTrace,
  }) async {
    // Remove from open sessions
    _openSessionLogs.removeWhere((logEntry) => logEntry.session == session);

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
        stdout.writeln(
            'METHOD CALL: ${session.endpointName}.${session.methodName} duration: ${duration.inMilliseconds}ms numQueries: ${cachedEntry.queries.length} authenticatedUser: $authenticatedUserId');
      } else if (session is FutureCallSession) {
        stdout.writeln(
            'FUTURE CALL: ${session.futureCallName} duration: ${duration.inMilliseconds}ms numQueries: ${cachedEntry.queries.length}');
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

      var tempSession = await session.serverpod.createSession(
        enableLogging: false,
      );
      try {
        if (_continuouslyLogging(session)) {
          // Close open session.
          session as StreamingSession;
          sessionLogId = session.sessionLogId!;
          sessionLogEntry.id = sessionLogId;
          sessionLogEntry.isOpen = false;
          await SessionLogEntry.update(tempSession, sessionLogEntry);
        } else {
          // Create new session row.
          await tempSession.db.insert(sessionLogEntry);
          sessionLogId = sessionLogEntry.id!;
        }

        // Write log entries
        for (var logInfo in cachedEntry.logEntries) {
          logInfo.sessionLogId = sessionLogId;
          await tempSession.db.insert(logInfo);
        }
        // Write queries
        for (var queryInfo in cachedEntry.queries) {
          queryInfo.sessionLogId = sessionLogId;
          await tempSession.db.insert(queryInfo);
        }
        // Write streaming messages
        for (var messageInfo in cachedEntry.messages) {
          messageInfo.sessionLogId = sessionLogId;
          await tempSession.db.insert(messageInfo);
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
      await tempSession.close();

      return sessionLogId;
    }
    return null;
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
          id: entry.session.sessionLogs.temporarySessionId,
          sessionLogEntry: SessionLogEntry(
            serverId: Serverpod.instance!.serverId,
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

import 'dart:io';

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
      String endpoint, String method) {
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
  LogSettings _getLogSettingsForStreamingSession() {
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
      return _getLogSettingsForStreamingSession();
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
  bool shouldLogQuery({
    required Session session,
    required double duration,
    required bool failed,
  }) {
    var logSettings = getLogSettingsForSession(session);
    if (logSettings.logAllQueries) {
      return true;
    }
    if (logSettings.logSlowQueries &&
        duration >= logSettings.slowQueryDuration) {
      return true;
    }
    if (logSettings.logFailedQueries && failed) {
      return true;
    }
    return false;
  }

  /// Returns true if a log entry should be stored for the provided session.
  bool shouldLogEntry({
    required Session session,
    required LogEntry entry,
  }) {
    var logSettings = getLogSettingsForSession(session);
    var serverLogLevel = (logSettings.logLevel);

    return entry.logLevel >= serverLogLevel;
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
    var logSettings = getLogSettingsForSession(session);

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

    var slowMicros = (logSettings.slowSessionDuration * 1000000.0).toInt();
    var isSlow = duration > Duration(microseconds: slowMicros) &&
        session is! StreamingSession;

    if (logSettings.logAllSessions ||
        logSettings.logSlowSessions && isSlow ||
        logSettings.logFailedSessions && exception != null ||
        cachedEntry.queries.isNotEmpty ||
        cachedEntry.logEntries.isNotEmpty) {
      int? sessionLogId;

      var sessionLogEntry = SessionLogEntry(
        serverId: session.server.serverId,
        time: DateTime.now(),
        endpoint: _endpointForSession(session),
        method: _methodForSession(session),
        duration: duration.inMicroseconds / 1000000.0,
        numQueries: cachedEntry.queries.length,
        slow: isSlow,
        error: exception,
        stackTrace: stackTrace?.toString(),
        authenticatedUserId: authenticatedUserId,
      );

      var tempSession = await session.serverpod.createSession(
        enableLogging: false,
      );
      try {
        await tempSession.db.insert(sessionLogEntry);

        sessionLogId = sessionLogEntry.id!;

        // Write log entries
        for (var logInfo in cachedEntry.logEntries) {
          logInfo.sessionLogId = sessionLogId;
          logInfo.serverId = session.server.serverId;
          await tempSession.db.insert(logInfo);
        }
        // Write queries
        for (var queryInfo in cachedEntry.queries) {
          queryInfo.sessionLogId = sessionLogId;
          queryInfo.serverId = session.server.serverId;
          await tempSession.db.insert(queryInfo);
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
          id: entry.session.temporarySessionId,
          sessionLogEntry: SessionLogEntry(
            serverId: Serverpod.instance!.serverId,
            time: entry.session.startTime,
            endpoint: _endpointForSession(entry.session),
            method: _methodForSession(entry.session),
            numQueries: entry.queries.length,
          ),
          queries: entry.queries,
          messageLog: entry.logEntries,
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

  /// Log entries made during the session.
  final List<LogEntry> logEntries = [];

  /// Creates a new [SessionLogEntryCache].
  SessionLogEntryCache(this.session);
}

import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/log_manager/session_log_cache.dart';

/// The interface for writing logs. The implementation will decide where the logs
/// are written.
abstract class LogWriter {
  /// Logs a query from a stream.
  Future<void> logStreamQuery(Session session, QueryLogEntry entry);

  /// Logs an entry from a stream.
  Future<void> logStreamEntry(Session session, LogEntry entry);

  /// Logs a message from a stream.
  Future<void> logStreamMessage(
    Session session,
    MessageLogEntry entry,
  );

  /// Opens a new streaming log and returns the id of the log.
  /// The id is used to identify the log when writing log entries so that
  /// they can be identified to  a single session.
  Future<int> openStreamingLog(Session session, SessionLogEntry entry);

  /// Closes a streaming log.
  /// This marks the end of all logs from this session.
  Future<void> closeStreamingLog(
    Session session,
    SessionLogEntry entry,
  );

  /// Log all cached logs.
  Future<void> logAllCached(
    Session session,
    SessionLogEntry sessionLogEntry,
    SessionLogEntryCache cache,
  );
}

/// Logs all output to the database
class DatabaseLogWriter extends LogWriter {
  @override
  Future<void> logStreamEntry(Session session, LogEntry entry) async {
    await _databaseLog(session, entry);
  }

  @override
  Future<void> logStreamMessage(Session session, MessageLogEntry entry) async {
    await _databaseLog(session, entry);
  }

  @override
  Future<void> logStreamQuery(
    Session session,
    QueryLogEntry entry,
  ) async {
    await _databaseLog<QueryLogEntry>(session, entry);
  }

  @override
  Future<int> openStreamingLog(
    Session session,
    SessionLogEntry entry,
  ) async {
    var sessionLog = await _databaseLog(session, entry);
    return sessionLog.id!;
  }

  @override
  Future<void> closeStreamingLog(
    Session session,
    SessionLogEntry entry,
  ) async {
    var tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    await SessionLogEntry.db.updateRow(tempSession, entry);

    await tempSession.close();
  }

  Future<T> _databaseLog<T extends TableRow>(
    Session session,
    T entry,
  ) async {
    var tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    var result = await tempSession.db.insertRow<T>(entry);

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
        await tempSession.db.insertRow<SessionLogEntry>(sessionLogEntry);
    var sessionLogId = sessionLog.id!;

    // Write log entries
    for (var logInfo in cache.logEntries) {
      logInfo.sessionLogId = sessionLogId;
      await tempSession.db.insertRow<LogEntry>(logInfo);
    }
    // Write queries
    for (var queryInfo in cache.queries) {
      queryInfo.sessionLogId = sessionLogId;
      await tempSession.db.insertRow<QueryLogEntry>(queryInfo);
    }
    // Write streaming messages
    for (var messageInfo in cache.messages) {
      messageInfo.sessionLogId = sessionLogId;
      await tempSession.db.insertRow<MessageLogEntry>(messageInfo);
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
  Future<void> logStreamEntry(Session session, LogEntry entry) async {
    stdout.writeln(entry);
  }

  @override
  Future<void> logStreamMessage(Session session, MessageLogEntry entry) async {
    stdout.writeln(entry);
  }

  @override
  Future<void> logStreamQuery(Session session, QueryLogEntry entry) async {
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
  Future<void> closeStreamingLog(Session session, SessionLogEntry entry) async {
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

import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// The interface for writing logs. The implementation will decide where the logs
/// are written.
@internal
abstract class LogWriter {
  /// Logs a query from a stream.
  Future<void> logQuery(QueryLogEntry entry);

  /// Logs an entry from a stream.
  Future<void> logEntry(LogEntry entry);

  /// Logs a message from a stream.
  Future<void> logMessage(MessageLogEntry entry);

  /// Opens a new streaming log and returns the id of the log.
  /// The id is used to identify the log when writing log entries so that
  /// they can be identified to a single session.
  Future<int> openLog(SessionLogEntry entry);

  /// Closes a streaming log.
  /// This marks the end of all logs from this session.
  Future<void> closeLog(SessionLogEntry entry);
}

@internal
class CachedLogWriter implements LogWriter {
  final LogWriter _logWriter;

  SessionLogEntry? _openLogEntry;

  /// Queries made during the session.
  final List<QueryLogEntry> _queries = [];

  /// Log entries made during the session.
  final List<LogEntry> _logEntries = [];

  /// Streaming messages handled during the session.
  final List<MessageLogEntry> _messages = [];

  CachedLogWriter(this._logWriter);

  static const _fakeId = -1;

  @override
  Future<int> openLog(SessionLogEntry entry) async {
    if (_openLogEntry != null) return _fakeId;
    _openLogEntry = entry;
    return _fakeId;
  }

  @override
  Future<void> closeLog(SessionLogEntry entry) async {
    var openLogEntry = _openLogEntry;
    if (openLogEntry == null) return;

    await _logWriter.openLog(openLogEntry);

    for (var query in _queries) {
      await _logWriter.logQuery(query);
    }

    for (var logEntry in _logEntries) {
      await _logWriter.logEntry(logEntry);
    }

    for (var message in _messages) {
      await _logWriter.logMessage(message);
    }

    return _logWriter.closeLog(entry);
  }

  @override
  Future<void> logEntry(LogEntry entry) async {
    _logEntries.add(entry);
  }

  @override
  Future<void> logMessage(MessageLogEntry entry) async {
    _messages.add(entry);
  }

  @override
  Future<void> logQuery(QueryLogEntry entry) async {
    _queries.add(entry);
  }
}

@internal
class DatabaseLogWriter extends LogWriter {
  final Session _session;
  late int sessionLogId;

  DatabaseLogWriter(this._session);

  @override
  Future<void> logEntry(LogEntry entry) async {
    entry.sessionLogId = sessionLogId;
    await _databaseLog(_session, entry);
  }

  @override
  Future<void> logMessage(MessageLogEntry entry) async {
    entry.sessionLogId = sessionLogId;
    await _databaseLog(_session, entry);
  }

  @override
  Future<void> logQuery(QueryLogEntry entry) async {
    entry.sessionLogId = sessionLogId;
    await _databaseLog(_session, entry);
  }

  @override
  Future<int> openLog(SessionLogEntry entry) async {
    var sessionLog = await _databaseLog(_session, entry);
    sessionLogId = sessionLog.id!;
    return sessionLogId;
  }

  @override
  Future<void> closeLog(SessionLogEntry entry) async {
    entry.id = sessionLogId;
    var tempSession = await _session.serverpod.createSession(
      enableLogging: false,
    );

    await SessionLogEntry.db.updateRow(tempSession, entry);

    await tempSession.close();
  }

  Future<T> _databaseLog<T extends TableRow>(Session session, T entry) async {
    var tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    var result = await tempSession.db.insertRow<T>(entry);

    await tempSession.close();

    return result;
  }
}

@internal
class StdOutLogWriter extends LogWriter {
  final int _logId;

  StdOutLogWriter(Session session) : _logId = session.sessionId.hashCode;

  @override
  Future<void> logEntry(LogEntry entry) async {
    entry.sessionLogId = _logId;
    stdout.writeln(entry);
  }

  @override
  Future<void> logMessage(MessageLogEntry entry) async {
    entry.sessionLogId = _logId;
    stdout.writeln(entry);
  }

  @override
  Future<void> logQuery(QueryLogEntry entry) async {
    entry.sessionLogId = _logId;
    stdout.writeln(entry);
  }

  @override
  Future<int> openLog(SessionLogEntry entry) async {
    entry.id = _logId;
    stdout.writeln(entry);
    return _logId;
  }

  @override
  Future<void> closeLog(SessionLogEntry entry) async {
    entry.id = hashCode;
    stdout.writeln(entry);
  }
}

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

  /// Opens the log for a session, this method should be called before any other log
  /// methods are called.
  Future<void> openLog(SessionLogEntry entry);

  /// Closes the log for a session. This method should be called after all logs
  /// have been written. Returns the id of the log. It is valid to call this method
  /// without calling [openLog] first, in that case the [entry] will be used to create
  /// a new log entry.
  /// This marks the end of all logs from this session.
  Future<int> closeLog(SessionLogEntry entry);
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

  @override
  Future<void> openLog(SessionLogEntry entry) async {
    _openLogEntry = entry;
  }

  @override
  Future<int> closeLog(SessionLogEntry entry) async {
    var openLogEntry = _openLogEntry ?? entry;

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
  int? _sessionLogId;

  DatabaseLogWriter(this._session);

  @override
  Future<void> logEntry(LogEntry entry) async {
    var id = _sessionLogId;
    if (id == null) throw StateError('The log has not been opened');

    entry.sessionLogId = id;
    await _databaseLog(_session, entry);
  }

  @override
  Future<void> logMessage(MessageLogEntry entry) async {
    var id = _sessionLogId;
    if (id == null) throw StateError('The log has not been opened');

    entry.sessionLogId = id;
    await _databaseLog(_session, entry);
  }

  @override
  Future<void> logQuery(QueryLogEntry entry) async {
    var id = _sessionLogId;
    if (id == null) throw StateError('The log has not been opened');

    entry.sessionLogId = id;
    await _databaseLog(_session, entry);
  }

  @override
  Future<void> openLog(SessionLogEntry entry) async {
    if (_sessionLogId != null) throw StateError('The log is already open');
    _sessionLogId = await _databaseLog(_session, entry);
  }

  @override
  Future<int> closeLog(SessionLogEntry entry) async {
    var id = _sessionLogId;
    if (id == null) {
      id = await _databaseLog(_session, entry);
    } else {
      entry.id = id;
      await _databaseLogUpdate(_session, entry);
    }

    _sessionLogId = null;
    return id;
  }

  Future<void> _databaseLogUpdate<T extends TableRow>(
    Session session,
    T entry,
  ) async {
    var tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    await tempSession.db.updateRow<T>(entry);

    await tempSession.close();
  }

  Future<int> _databaseLog<T extends TableRow>(Session session, T entry) async {
    var tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    var result = await tempSession.db.insertRow<T>(entry);

    await tempSession.close();

    var id = result.id;

    if (id == null) throw StateError('Failed to insert log entry');
    return id;
  }
}

@internal
class StdOutLogWriter extends LogWriter {
  final int _logId;

  SessionLogEntry? _entry;

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
  Future<void> openLog(SessionLogEntry entry) async {
    entry.id = _logId;
    _entry = entry;
    stdout.writeln(entry);
  }

  @override
  Future<int> closeLog(SessionLogEntry entry) async {
    if (_entry != null) return _logId;

    entry.id = _logId;
    stdout.writeln(entry);
    return _logId;
  }
}

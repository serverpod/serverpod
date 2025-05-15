import 'dart:io';

import 'package:collection/collection.dart';
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
  final Session _logWriterSession;
  int? _sessionLogId;

  DatabaseLogWriter({required Session logWriterSession})
      : _logWriterSession = logWriterSession;

  @override
  Future<void> logEntry(LogEntry entry) async {
    var id = _sessionLogId;
    if (id == null) throw StateError('The log has not been opened');

    entry.sessionLogId = id;
    await _databaseLog(entry);
  }

  @override
  Future<void> logMessage(MessageLogEntry entry) async {
    var id = _sessionLogId;
    if (id == null) throw StateError('The log has not been opened');

    entry.sessionLogId = id;
    await _databaseLog(entry);
  }

  @override
  Future<void> logQuery(QueryLogEntry entry) async {
    var id = _sessionLogId;
    if (id == null) throw StateError('The log has not been opened');

    entry.sessionLogId = id;
    await _databaseLog(entry);
  }

  @override
  Future<void> openLog(SessionLogEntry entry) async {
    if (_sessionLogId != null) throw StateError('The log is already open');
    _sessionLogId = await _databaseLog(entry);
  }

  @override
  Future<int> closeLog(SessionLogEntry entry) async {
    var id = _sessionLogId;
    if (id == null) {
      id = await _databaseLog(entry);
    } else {
      entry.id = id;
      await _databaseLogUpdate(entry);
    }

    _sessionLogId = null;
    return id;
  }

  Future<void> _databaseLogUpdate<T extends TableRow>(
    T entry,
  ) async {
    await _logWriterSession.db.updateRow<T>(entry);
  }

  Future<int> _databaseLog<T extends TableRow>(T entry) async {
    var result = await _logWriterSession.db.insertRow<T>(entry);

    var id = result.id;

    if (id == null) throw StateError('Failed to insert log entry');
    return id;
  }
}

@internal
class StdOutLogWriter extends LogWriter {
  final int _logId;

  StdOutLogWriter(Session session) : _logId = session.sessionId.hashCode;

  @override
  Future<void> logEntry(LogEntry entry) async {
    entry.sessionLogId = _logId;

    if (entry.error != null ||
        entry.logLevel == LogLevel.error ||
        entry.logLevel == LogLevel.fatal) {
      stderr.writeln(entry);
    } else {
      stdout.writeln(entry);
    }
  }

  @override
  Future<void> logMessage(MessageLogEntry entry) async {
    entry.sessionLogId = _logId;

    if (entry.error != null) {
      stderr.writeln(entry);
    } else {
      stdout.writeln(entry);
    }
  }

  @override
  Future<void> logQuery(QueryLogEntry entry) async {
    entry.sessionLogId = _logId;

    if (entry.error != null) {
      stderr.writeln(entry);
    } else {
      stdout.writeln(entry);
    }
  }

  @override
  Future<void> openLog(SessionLogEntry entry) async {
    entry.id = _logId;

    if (entry.error != null) {
      stderr.writeln(entry);
    } else {
      stdout.writeln(entry);
    }
  }

  @override
  Future<int> closeLog(SessionLogEntry entry) async {
    entry.id = _logId;

    if (entry.error != null) {
      stderr.writeln(entry);
    } else {
      stdout.writeln(entry);
    }

    return _logId;
  }
}

@internal
class MultipleLogWriter extends LogWriter {
  final List<LogWriter> _logWriters;

  MultipleLogWriter(this._logWriters);

  //// Closes logs for all writers and returns the log ID.
  ///
  /// The log ID for persistent logging is prioritized if present.
  /// This is because persistent logs are more critical for long-term record-keeping
  /// compared to non-persistent logs, such as console logs.
  /// If no persistent log is available, the first log ID from any writer is returned.
  @override
  Future<int> closeLog(SessionLogEntry entry) async {
    int? databaseLogId;

    var responses = await Future.wait(_logWriters.map((writer) async {
      var logId = await writer.closeLog(entry);

      if (writer is DatabaseLogWriter) {
        databaseLogId = logId;
      }

      return logId;
    }));

    return databaseLogId ?? responses.firstOrNull ?? 0;
  }

  @override
  Future<void> logEntry(LogEntry entry) async {
    await Future.wait(
      _logWriters.map((writer) => writer.logEntry(entry)),
    );
  }

  @override
  Future<void> logMessage(MessageLogEntry entry) async {
    await Future.wait(
      _logWriters.map((writer) => writer.logMessage(entry)),
    );
  }

  @override
  Future<void> logQuery(QueryLogEntry entry) async {
    await Future.wait(
      _logWriters.map((writer) => writer.logQuery(entry)),
    );
  }

  @override
  Future<void> openLog(SessionLogEntry entry) async {
    await Future.wait(
      _logWriters.map((writer) => writer.openLog(entry)),
    );
  }
}

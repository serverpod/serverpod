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
class JsonStdOutLogWriter extends LogWriter {
  final int _logId;

  JsonStdOutLogWriter(Session session) : _logId = session.sessionId.hashCode;

  @override
  Future<void> logEntry(LogEntry entry) async {
    entry.sessionLogId = _logId;

    if (_isError(entry)) {
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
class TextStdOutLogWriter extends LogWriter {
  static bool headersWritten = false;

  /// Formats a duration value expressed in milliseconds so that it is easy to
  /// read in logs. Very short durations will be printed using microseconds
  /// while longer ones will switch to milliseconds or seconds.
  static String _printDuration(double? milliseconds) {
    if (milliseconds == null) return 'n/a';
    var micros = (milliseconds * Duration.microsecondsPerMillisecond).round();
    if (micros < 1000) {
      // Ignore required because dart does not understand that "µ" is a valid
      // character in a string.
      // ignore: unnecessary_brace_in_string_interps
      return '${micros}µs';
    }
    if (micros < Duration.microsecondsPerSecond) {
      var ms = micros / 1000;
      return _formatNumber(ms, 'ms');
    }
    var s = micros / Duration.microsecondsPerSecond;
    return _formatNumber(s, 's');
  }

  static String _formatNumber(double value, String suffix) {
    String formatted;
    if (value >= 100) {
      formatted = value.toStringAsFixed(0);
    } else if (value >= 10) {
      formatted = value.toStringAsFixed(1);
    } else {
      formatted = value.toStringAsFixed(2);
    }
    if (formatted.contains('.')) {
      formatted = formatted
          .replaceFirst(RegExp(r'0+$'), '')
          .replaceFirst(RegExp(r'\.$'), '');
    }
    return '$formatted$suffix';
  }

  static void writeHeadersIfNeeded() {
    if (!headersWritten) {
      _writeFormatHeaders();
      headersWritten = true;
    }
  }

  final int _logId;
  final Session _session;

  TextStdOutLogWriter(this._session) : _logId = _session.sessionId.hashCode {
    writeHeadersIfNeeded();
  }

  @override
  Future<void> logEntry(LogEntry entry) async {
    _writeFormattedLog(
      'LOG',
      context: entry.logLevel.name.toUpperCase(),
      id: _logId,
      fields: {
        'message': entry.message,
      },
      error: entry.error,
      stackTrace: entry.stackTrace,
      toStdErr: _isError(entry),
    );
  }

  @override
  Future<void> logMessage(MessageLogEntry entry) async {
    _writeFormattedLog(
      'STREAM MESSAGE',
      context: entry.endpoint,
      id: _logId,
      fields: {
        'id': entry.messageId,
        'name': entry.messageName,
      },
      error: entry.error,
      stackTrace: entry.stackTrace,
    );
  }

  @override
  Future<void> logQuery(QueryLogEntry entry) async {
    _writeFormattedLog(
      'QUERY',
      context: null,
      id: _logId,
      fields: {
        'id': entry.id,
        'duration': _printDuration(entry.duration),
        'query': entry.query,
      },
      error: entry.error,
      stackTrace: entry.stackTrace,
    );
  }

  @override
  Future<void> openLog(SessionLogEntry entry) async {
    if (_session is! StreamingSession && _session is! MethodStreamSession) {
      return;
    }

    _writeFormattedLog(
      'STREAM OPEN',
      context:
          '${entry.endpoint}${entry.method != null ? '.${entry.method}' : ''}',
      id: _logId,
      fields: {
        'user': entry.authenticatedUserId,
      },
      error: entry.error,
      stackTrace: entry.stackTrace,
    );
  }

  @override
  Future<int> closeLog(SessionLogEntry entry) async {
    switch (_session) {
      case MethodCallSession():
        _writeFormattedLog(
          'METHOD',
          context: '${entry.endpoint}.${entry.method}',
          id: _logId,
          fields: {
            'user': entry.authenticatedUserId,
            'queries': entry.numQueries,
            'duration': _printDuration(entry.duration),
          },
          error: entry.error,
          stackTrace: entry.stackTrace,
        );
        break;
      case FutureCallSession():
        _writeFormattedLog(
          'FUTURE',
          context: _session.futureCallName,
          id: _logId,
          fields: {
            'queries': entry.numQueries,
            'duration': _printDuration(entry.duration),
          },
          error: entry.error,
          stackTrace: entry.stackTrace,
        );
        break;
      case WebCallSession():
        _writeFormattedLog(
          'WEB',
          context: entry.endpoint,
          id: _logId,
          fields: {
            'user': entry.authenticatedUserId,
            'queries': entry.numQueries,
            'duration': _printDuration(entry.duration),
          },
          error: entry.error,
          stackTrace: entry.stackTrace,
        );
        break;
      case StreamingSession() || MethodStreamSession():
        _writeFormattedLog(
          'STREAM CLOSED',
          context:
              '${entry.endpoint}${entry.method != null ? '.${entry.method}' : ''}',
          id: _logId,
          fields: {
            'user': entry.authenticatedUserId,
            'queries': entry.numQueries,
            'duration': _printDuration(entry.duration),
          },
          error: entry.error,
          stackTrace: entry.stackTrace,
        );
        break;
      case InternalSession():
        _writeFormattedLog(
          'INTERNAL',
          context: null,
          id: _logId,
          fields: {
            'queries': entry.numQueries,
            'duration': _printDuration(entry.duration),
          },
          error: entry.error,
          stackTrace: entry.stackTrace,
        );
        break;
      default:
        // This should never happen, but we handle it gracefully.
        _writeFormattedLog(
          'UNKNOWN',
          context: null,
          id: _logId,
          fields: {
            'sessionType': _session.runtimeType.toString(),
            'queries': entry.numQueries,
            'duration': _printDuration(entry.duration),
          },
          error: entry.error,
          stackTrace: entry.stackTrace,
        );
        break;
    }

    return _logId;
  }

  static void _writeFormatHeaders() {
    stdout.writeln(
      '${'TIME'.padRight(27)}'
      ' ${'ID'.padRight(10)}'
      ' ${'TYPE'.padRight(14)}'
      ' ${'CONTEXT'.padRight(25)}'
      'DETAILS',
    );
    stdout.writeln(
      '${'-' * 27}' // Time
      ' ${'-' * 10}' // Id
      ' ${'-' * 14}' // Type
      ' ${'-' * 24}' // Context
      ' ${'-' * 30}', // Details
    );
  }

  static void _writeFormattedLog(
    String type, {
    required String? context,
    required int id,
    required Map<String, dynamic> fields,
    required String? error,
    required String? stackTrace,
    bool toStdErr = false,
  }) {
    var now = DateTime.now().toUtc();
    _write(
      type,
      context: context,
      id: id,
      message: fields.isNotEmpty
          ? fields.entries.map((e) => '${e.key}=${e.value}').join(', ')
          : '',
      now: now,
      toStdErr: toStdErr,
    );

    if (error != null) {
      _write(
        'ERROR',
        context: 'n/a',
        id: id,
        message: error,
        now: now,
        toStdErr: true,
      );
      if (stackTrace != null) {
        _write(
          'STACK TRACE',
          context: 'n/a',
          id: id,
          message: stackTrace,
          now: now,
          toStdErr: true,
        );
      }
    }
  }

  static void _write(
    String type, {
    required String? context,
    required int id,
    required String message,
    required DateTime now,
    required bool toStdErr,
  }) {
    var output = StringBuffer();
    output.write('$id'.padLeft(10));
    output.write(' $type'.padRight(15));

    output.write(' ${context ?? 'n/a'}'.padRight(25));
    output.write(' $message');

    if (toStdErr) {
      stderr.writeln('$now ${output.toString()}');
    } else {
      stdout.writeln('$now ${output.toString()}');
    }
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

bool _isError(LogEntry entry) {
  return entry.error != null ||
      entry.logLevel == LogLevel.error ||
      entry.logLevel == LogLevel.fatal;
}

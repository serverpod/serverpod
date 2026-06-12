import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod_shared/log.dart' show LogLevel;

import '../session_log.dart';

/// A [SessionLogWriter] that emits session events as aligned columnar
/// text (TIME / ID / TYPE / CONTEXT / DETAILS) to stdout, matching the
/// legacy `SessionTextStdOutLogWriter` format.
///
/// Stdout/stderr are used directly - a "plain" framework [LogWriter]
/// would re-decorate every line (timestamps, level prefixes) and
/// collide with the column layout. The writer still takes typed
/// [SessionOpen] / [SessionEntry] / [SessionClose] records, so the
/// metadata-key round-trip from the previous design is gone.
@internal
class TextSessionLogWriter extends SessionLogWriter {
  static bool _headersWritten = false;

  /// Synthetic session log id per session, stable within a process and
  /// shared across the session's child rows.
  final Map<String, _OpenState> _sessions = {};

  /// Creates a [TextSessionLogWriter]. Writes column headers to stdout
  /// on first instantiation in the process.
  TextSessionLogWriter() {
    if (!_headersWritten) {
      _writeHeaders();
      _headersWritten = true;
    }
  }

  @override
  Future<void> open(SessionOpen event) async {
    final logId = event.sessionId.hashCode;
    _sessions[event.sessionId] = _OpenState(event, logId);

    // Only streaming sessions log an explicit open row; other session
    // types are reported as a single closing row.
    if (event.kind != SessionKind.stream &&
        event.kind != SessionKind.methodStream) {
      return;
    }

    _writeFormattedLog(
      'STREAM OPEN',
      context: _endpointMethod(event),
      id: logId,
      // Authenticated user is set at close time.
      fields: const {'user': null},
      time: event.startTime,
    );
  }

  @override
  Future<void> record(SessionEntry entry) async {
    final state = _sessions[entry.sessionId];
    if (state == null) return;
    final logId = state.logId;

    switch (entry) {
      case SessionLogEntry e:
        _writeFormattedLog(
          'LOG',
          context: e.level.name.toUpperCase(),
          id: logId,
          fields: {
            'messageId': ?e.messageId,
            'message': e.message,
          },
          error: e.error,
          stackTrace: e.stackTrace?.toString(),
          toStdErr:
              e.error != null ||
              e.level == LogLevel.error ||
              e.level == LogLevel.fatal,
          time: e.time,
        );
      case SessionQueryEntry e:
        _writeFormattedLog(
          'QUERY',
          context: null,
          id: logId,
          fields: {
            'messageId': ?e.messageId,
            'duration': _printDuration(e.duration),
            'query': e.query,
          },
          error: e.error,
          stackTrace: e.stackTrace?.toString(),
          time: e.time,
        );
      case SessionMessageEntry e:
        _writeFormattedLog(
          'STREAM MESSAGE',
          context: e.endpoint,
          id: logId,
          fields: {
            'id': e.messageId,
            'name': e.messageName,
          },
          error: e.error,
          stackTrace: e.stackTrace?.toString(),
          time: e.time,
        );
    }
  }

  @override
  Future<void> close(SessionClose event) async {
    final state = _sessions.remove(event.sessionId);
    if (state == null) return;

    final open = state.open;
    final durStr = _printDuration(event.duration);

    final (line, context) = switch (open.kind) {
      SessionKind.method => ('METHOD', _endpointMethod(open)),
      SessionKind.futureCall => ('FUTURE', open.futureCallName),
      SessionKind.web => ('WEB', open.endpoint),
      SessionKind.stream ||
      SessionKind.methodStream => ('STREAM CLOSED', _endpointMethod(open)),
      SessionKind.internal => ('INTERNAL', null),
      SessionKind.unknown => ('UNKNOWN', null),
    };

    _writeFormattedLog(
      line,
      context: context,
      id: state.logId,
      fields: {
        if (open.kind == SessionKind.method ||
            open.kind == SessionKind.web ||
            open.kind == SessionKind.stream ||
            open.kind == SessionKind.methodStream)
          'user': event.authenticatedUserId,
        'queries': event.numQueries,
        'duration': durStr,
      },
      error: event.error?.toString(),
      stackTrace: event.stackTrace?.toString(),
    );
  }

  String? _endpointMethod(SessionOpen event) {
    final endpoint = event.endpoint;
    final method = event.method;
    if (endpoint == null) return null;
    if (method == null) return endpoint;
    return '$endpoint.$method';
  }

  static void _writeHeaders() {
    stdout.writeln(
      '${'TIME'.padRight(27)}'
      ' ${'ID'.padRight(10)}'
      ' ${'TYPE'.padRight(14)}'
      ' ${'CONTEXT'.padRight(25)}'
      'DETAILS',
    );
    stdout.writeln(
      '${'-' * 27}'
      ' ${'-' * 10}'
      ' ${'-' * 14}'
      ' ${'-' * 24}'
      ' ${'-' * 30}',
    );
  }

  static void _writeFormattedLog(
    String type, {
    required String? context,
    required int id,
    required Map<String, Object?> fields,
    String? error,
    String? stackTrace,
    bool toStdErr = false,
    DateTime? time,
  }) {
    final now = (time ?? DateTime.now()).toUtc();
    final visibleFields = fields.entries.where((e) => e.value != null);
    _write(
      type,
      context: context,
      id: id,
      message: visibleFields.isNotEmpty
          ? visibleFields.map((e) => '${e.key}=${e.value}').join(', ')
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
    final line = StringBuffer();
    line.write('$id'.padLeft(10));
    line.write(' $type'.padRight(15));
    line.write(' ${context ?? 'n/a'}'.padRight(25));
    line.write(' $message');
    if (toStdErr) {
      stderr.writeln('$now ${line.toString()}');
    } else {
      stdout.writeln('$now ${line.toString()}');
    }
  }

  static String _printDuration(Duration duration) {
    final micros = duration.inMicroseconds;
    // ignore: unnecessary_brace_in_string_interps
    if (micros < 1000) return '${micros}\u00B5s';
    if (micros < Duration.microsecondsPerSecond) {
      return _formatNumber(micros / 1000, 'ms');
    }
    return _formatNumber(micros / Duration.microsecondsPerSecond, 's');
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
}

class _OpenState {
  _OpenState(this.open, this.logId);

  final SessionOpen open;
  final int logId;
}

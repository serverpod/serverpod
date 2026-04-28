import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

class LoggingUtil {
  static Future<void> clearAllLogs(Session session) async {
    // Only need to delete the session log entries, the rest will be deleted by the cascade.
    await SessionLogEntry.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );

    // Also clear runtime settings to ensure default log levels.
    await RuntimeSettings.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
  }

  /// Fetches log entries for a specific session log ID.
  ///
  /// This is preferred over [findAllLogs] when you need to assert on logs from
  /// a specific session, as it avoids interference from concurrent test
  /// sessions and log cleanup.
  static Future<List<LogEntry>> findLogsForSession(
    Session session,
    int? sessionLogId,
  ) async {
    if (sessionLogId == null) {
      // ignore: avoid_print
      print(
        'findLogsForSession: sessionLogId is null. This means no log '
        'was opened for this session. Check logAllSessions or logLevel.',
      );
      return [];
    }
    return LogEntry.db.find(
      session,
      where: (t) => t.sessionLogId.equals(sessionLogId),
      orderBy: (t) => t.order,
    );
  }

  /// Attempts to resolve the `serverpod_session_log.id` (session log id) for
  /// [loggedSession].
  ///
  /// Serverpod no longer returns a session log id from [Session.close], so
  /// tests that need to assert on a specific session's logs must locate the
  /// corresponding [SessionLogEntry] row in the database.
  static Future<int?> findSessionLogIdForSession(
    Session querySession,
    Session loggedSession,
  ) async {
    final candidates = await SessionLogEntry.db.find(
      querySession,
      where: (t) =>
          t.serverId.equals(loggedSession.server.serverId) &
          t.endpoint.equals(loggedSession.endpoint) &
          t.method.equals(loggedSession.method),
      orderBy: (t) => t.id.desc(),
      limit: 20,
    );

    if (candidates.isEmpty) return null;

    final startTime = loggedSession.startTime;
    for (final row in candidates) {
      final deltaMs = row.time.difference(startTime).inMilliseconds.abs();
      if (deltaMs <= 2000) {
        return row.id;
      }
    }

    // Fall back to the most recent matching entry (best effort).
    return candidates.first.id;
  }

  static Future<List<SessionLogInfo>> findAllLogs(
    Session session,
  ) async {
    var rows = (await SessionLogEntry.db.find(
      session,
      orderBy: (t) => t.id.desc(),
    ));

    var sessionLogInfo = <SessionLogInfo>[];
    for (var logEntry in rows) {
      var futureLogRows = LogEntry.db.find(
        session,
        where: (t) => t.sessionLogId.equals(logEntry.id),
        orderBy: (t) => t.order,
      );

      var futureQueryRows = QueryLogEntry.db.find(
        session,
        where: (t) => t.sessionLogId.equals(logEntry.id),
        orderBy: (t) => t.order,
      );

      var futureMessageRows = MessageLogEntry.db.find(
        session,
        where: (t) => t.sessionLogId.equals(logEntry.id),
        orderBy: (t) => t.order,
      );

      var logRows = await futureLogRows;
      var queryRows = await futureQueryRows;
      var messageRows = await futureMessageRows;

      sessionLogInfo.add(
        SessionLogInfo(
          sessionLogEntry: logEntry,
          logs: logRows,
          queries: queryRows,
          messages: messageRows,
        ),
      );
    }

    return sessionLogInfo;
  }
}

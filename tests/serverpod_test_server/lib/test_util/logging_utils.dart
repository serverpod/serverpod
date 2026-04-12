import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

class LoggingUtil {
  static Future<void> clearAllLogs(Session session) async {
    // Only need to delete the session log entries, the rest will be deleted by the cascade.
    await SessionLogEntry.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
  }

  /// Fetches log entries for a specific session log ID returned by
  /// [Session.close]. This is preferred over [findAllLogs] when you need to
  /// assert on logs from a specific session, as it avoids interference from
  /// concurrent test sessions and log cleanup.
  static Future<List<LogEntry>> findLogsForSession(
    Session session,
    int? sessionLogId,
  ) async {
    if (sessionLogId == null) return [];
    return LogEntry.db.find(
      session,
      where: (t) => t.sessionLogId.equals(sessionLogId),
      orderBy: (t) => t.order,
    );
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

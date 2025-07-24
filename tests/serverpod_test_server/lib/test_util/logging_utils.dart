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

  static Future<List<SessionLogInfo>> findAllLogs(
    Session session,
  ) async {
    var rows = (await SessionLogEntry.db.find(
      session,
      orderBy: (t) => t.id,
      orderDescending: true,
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

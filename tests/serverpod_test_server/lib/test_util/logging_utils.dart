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
    var rows = (await session.db.find<SessionLogEntry>(
      orderBy: SessionLogEntry.t.id,
      orderDescending: true,
    ));

    var sessionLogInfo = <SessionLogInfo>[];
    for (var logEntry in rows) {
      var logRows = await session.db.find<LogEntry>(
        where: LogEntry.t.sessionLogId.equals(logEntry.id),
        orderBy: LogEntry.t.order,
      );

      var queryRows = await session.db.find<QueryLogEntry>(
        where: QueryLogEntry.t.sessionLogId.equals(logEntry.id),
        orderBy: QueryLogEntry.t.order,
      );

      var messageRows = await session.db.find<MessageLogEntry>(
        where: MessageLogEntry.t.sessionLogId.equals(logEntry.id),
        orderBy: MessageLogEntry.t.order,
      );

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

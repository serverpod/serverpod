import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// The [SessionLogEntryCache] holds all logging information for a session before
/// it's written to the database.
class SessionLogEntryCache {
  /// A reference to the [Session].
  final Session session;

  /// Queries made during the session.
  final List<QueryLogEntry> queries = [];

  /// Number of queries made during this session.
  int get numQueries => queries.length;

  /// Log entries made during the session.
  final List<LogEntry> logEntries = [];

  /// Streaming messages handled during the session.
  final List<MessageLogEntry> messages = [];

  /// A temporary session id used internally by the server.
  late int temporarySessionId;

  int _currentLogOrderId = 0;

  /// This is used internally by Serverpod to ensure the ordering of log entries
  int get createLogOrderId {
    return ++_currentLogOrderId;
  }

  /// Creates a new [SessionLogEntryCache].
  SessionLogEntryCache(this.session);
}

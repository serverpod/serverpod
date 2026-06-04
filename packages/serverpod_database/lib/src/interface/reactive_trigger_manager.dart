import '../../serverpod_database.dart';

/// Manages database triggers for reactive future calls.
///
/// Implementations provide dialect-specific trigger creation, cleanup,
/// and removal operations.
abstract interface class ReactiveTriggerManager {
  /// Creates or replaces a trigger and its backing function for a reactive
  /// future call handler.
  Future<void> createTrigger(
    DatabaseSession session, {
    required String handlerName,
    required String tableName,
    required Expression? condition,
  });

  /// Drops triggers that don't match any of the [registeredHandlers].
  Future<void> cleanupOrphanedTriggers(
    DatabaseSession session, {
    required Set<String> registeredHandlers,
  });

  /// Drops all reactive triggers. Called before migrations to prevent
  /// stale trigger references.
  Future<void> dropAllTriggers(DatabaseSession session);

  /// Returns the handler names of all currently registered reactive
  /// triggers in the database. Useful for inspection and testing.
  Future<List<String>> listTriggerHandlers(DatabaseSession session);
}

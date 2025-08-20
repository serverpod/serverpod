import 'package:serverpod/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// A collection of utils for the database backed session logs.
abstract final class SessionLogUtils {
  /// Migrates SessionLogEntry user IDs from the deprecated
  /// `authenticatedUserId` to `userId` if `userId` is null.
  /// Processes entries in batches for efficiency.
  ///
  /// [batchSize] controls how many entries are processed per batch (default: 1000).
  /// Returns the total number of migrated entries.
  static Future<int> migrateSessionLogUserIds({
    required Session session,
    int batchSize = 1000,
    int? maxMigratedEntries,
    Transaction? transaction,
  }) async {
    int totalMigrated = 0;

    while (true) {
      int effectiveBatchSize = batchSize;
      if (maxMigratedEntries != null) {
        final remaining = maxMigratedEntries - totalMigrated;
        if (remaining <= 0) break;
        effectiveBatchSize = remaining < batchSize ? remaining : batchSize;
      }

      final entries = await SessionLogEntry.db.find(
        session,
        where: (t) =>
            t.userId.equals(null) & t.authenticatedUserId.notEquals(null),
        limit: effectiveBatchSize,
        orderBy: (t) => t.id,
        transaction: transaction,
      );

      if (entries.isEmpty) break;

      for (final entry in entries) {
        entry.userId = entry.authenticatedUserId?.toString();
        entry.authenticatedUserId = null;
      }

      await SessionLogEntry.db.update(
        session,
        entries,
        columns: (t) => [t.userId, t.authenticatedUserId],
        transaction: transaction,
      );

      totalMigrated += entries.length;
    }
    return totalMigrated;
  }
}

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_api_tokens_server/src/generated/api_token.dart';

/// Collection of admin functions for managing API tokens.
final class ApiTokensAdmin {
  /// Creates a new admin helper class instance.
  @internal
  ApiTokensAdmin();

  /// Deletes the API tokens which [ApiToken.expiresAt] has elapsed, or where
  /// the token has not been used in since [ApiToken.expireAfterUnusedFor] expired it.
  Future<void> deleteExpiredTokens(
    final Session session, {
    /// Whether to delete API tokens which [ApiToken.expiresAt] is in the past.
    final bool deleteExpired = true,

    /// Whether to delete API tokens which have not been used for [ApiToken.expireAfterUnusedFor].
    final bool deleteInactive = true,
    final Transaction? transaction,
  }) async {
    if (deleteExpired) {
      await ApiToken.db.deleteWhere(
        session,
        where: (final t) => t.expiresAt < clock.now(),
        transaction: transaction,
      );
    }

    if (deleteInactive) {
      await session.db.unsafeQuery(
        'DELETE FROM ${ApiToken.t.tableName} WHERE '
        '"${ApiToken.t.expireAfterUnusedFor.columnName}" IS NOT NULL AND '
        '"${ApiToken.t.lastUsed.columnName}" + ("${ApiToken.t.expireAfterUnusedFor.columnName}" * INTERVAL \'1 millisecond\') < \'${SerializationManager.encode(clock.now())}\'',
        transaction: transaction,
      );
    }
  }
}

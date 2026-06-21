import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

/// Management functions for merging accounts.
///
/// Account merging happens in rare cases when a user adds a new sign-in method
/// to their account, but Serverpod recognizes that IDP as already belonging to
/// a different, pre-existing account. At this point, application developers
/// should offer an account merge to the user, and, if they accept, run the
/// [merge] method found here.
class AccountMerger {
  final AccountMergeConfig _config;

  /// Creates a new [AccountMerger] instance.
  const AccountMerger({
    final AccountMergeConfig config = const AccountMergeConfig(),
  }) : _config = config;

  /// Merges the accounts of two [AuthUser]s.
  ///
  /// This method invokes the callbacks defined in the
  /// [AccountMergeConfig.mergeHooks].
  ///
  /// Throws an [AuthUserNotFoundException] if either user is not found.
  Future<void> merge(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(session.db, transaction, (
      final transaction,
    ) async {
      final users = await Future.wait([
        AuthUser.db.findById(
          session,
          userToKeepId,
          transaction: transaction,
        ),
        AuthUser.db.findById(
          session,
          userToRemoveId,
          transaction: transaction,
        ),
      ]);
      final userToKeepEntity = users[0];
      final userToRemoveEntity = users[1];

      if (userToKeepEntity == null || userToRemoveEntity == null) {
        throw AuthUserNotFoundException();
      }

      for (final AccountMergeHandler hook in _config.mergeHooks) {
        await hook(
          session,
          userToKeepId: userToKeepId,
          userToRemoveId: userToRemoveId,
          transaction: transaction,
        );
      }
    });
  }
}

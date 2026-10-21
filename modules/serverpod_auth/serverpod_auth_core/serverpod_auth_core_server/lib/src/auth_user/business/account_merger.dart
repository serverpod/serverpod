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

  /// Whether the application has supplied its own merge logic.
  ///
  /// See [AccountMergeConfig.hasApplicationMergeHandler].
  bool get hasApplicationMergeHandler => _config.hasApplicationMergeHandler;

  /// Merges the accounts of two [AuthUser]s.
  ///
  /// This method invokes the callbacks defined in the
  /// [AccountMergeConfig.mergeHooks].
  ///
  /// Set [userToRemoveIsNewlyCreated] when the user being removed was created
  /// moments ago, as part of the sign-in that is being linked to
  /// [userToKeepId]. Such a user cannot hold application data of its own, so
  /// [AccountMergeConfig.newAccountMergeHooks] is used instead and no
  /// application merge handler is required.
  ///
  /// Throws an [AuthUserNotFoundException] if either user is not found.
  /// Throws an [ArgumentError] if [userToKeepId] and [userToRemoveId] are equal.
  Future<void> merge(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    final bool userToRemoveIsNewlyCreated = false,
    final Transaction? transaction,
  }) async {
    if (userToKeepId == userToRemoveId) {
      throw ArgumentError.value(
        userToRemoveId,
        'userToRemoveId',
        'The user to remove must be different from the user to keep.',
      );
    }

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

      final hooks = userToRemoveIsNewlyCreated
          ? _config.newAccountMergeHooks
          : _config.mergeHooks;

      for (final AccountMergeHandler hook in hooks) {
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

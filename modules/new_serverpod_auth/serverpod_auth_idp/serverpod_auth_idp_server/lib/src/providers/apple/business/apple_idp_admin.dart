import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import 'apple_idp_utils.dart';

/// Collection of Apple-account admin methods.
final class AppleIDPAdmin {
  final AppleIDPUtils _utils;

  /// Creates a new instance of the admin utilities.
  AppleIDPAdmin({required final AppleIDPUtils utils}) : _utils = utils;

  /// Checks whether all accounts are in good standing with Apple and that the
  /// authorization has not been revoked.
  ///
  /// Accounts are checked at most every 24 hours.
  ///
  /// In case a deactivated account is encountered, the configuration's
  /// `expiredUserAuthenticationCallback` is invoked with the auth user's ID.
  /// Then all their sessions created through Sign in with Apple should be
  /// revoked.
  Future<void> checkAccountStatus(
    final Session session, {

    /// Callback to be invoked when an Apple authentication has been revoked.
    ///
    /// In this case all sessions associated with this sign-in method should be
    /// removed.
    required final void Function(UuidValue authUserId)
    onExpiredUserAuthentication,
    final Transaction? transaction,
    final int databaseBatchSize = 100,
  }) async {
    while (true) {
      final appleAccounts = await AppleAccount.db.find(
        session,
        where: (final t) =>
            t.lastRefreshedAt <
            DateTime.now().subtract(const Duration(days: 1)),
        limit: databaseBatchSize,
        transaction: transaction,
      );

      if (appleAccounts.isEmpty) {
        break;
      }

      for (final appleAccount in appleAccounts) {
        await _utils.refreshToken(
          session,
          appleAccount: appleAccount,
          onExpiredUserAuthentication: onExpiredUserAuthentication,
        );
      }
    }
  }
}

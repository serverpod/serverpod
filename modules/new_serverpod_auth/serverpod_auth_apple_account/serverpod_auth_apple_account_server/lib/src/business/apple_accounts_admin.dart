import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_apple_account_server/serverpod_auth_apple_account_server.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';

/// Administrative Apple account management functions.
final class AppleAccountsAdmin {
  final AppleAccountConfig _config;
  final SignInWithApple _siwa;

  /// Creates a new instance of the admin utilities.
  @internal
  AppleAccountsAdmin(this._config, this._siwa);

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
    final Transaction? transaction,
    final int databaseBatchSize = 100,
  }) async {
    final expiredUserAuthenticationCallback =
        _config.expiredUserAuthenticationCallback;
    if (expiredUserAuthenticationCallback == null) {
      throw StateError(
        'No `expiredUserAuthenticationCallback` is configured in the `AppleAccountConfig`.',
      );
    }

    while (true) {
      final appleAccounts = await AppleAccount.db.find(
        session,
        where: (final t) =>
            t.lastRefreshedAt <
            DateTime.now().subtract(const Duration(days: 1)),
        limit: 10,
        transaction: transaction,
      );

      if (appleAccounts.isEmpty) {
        break;
      }

      for (final appleAccount in appleAccounts) {
        try {
          await _siwa.validateRefreshToken(
            appleAccount.refreshToken,
            useBundleIdentifier:
                appleAccount.refreshTokenRequestedWithBundleIdentifier,
          );
        } on RevokedTokenException catch (_) {
          expiredUserAuthenticationCallback(appleAccount.authUserId);
        }

        await AppleAccount.db.updateRow(
          session,
          appleAccount.copyWith(lastRefreshedAt: clock.now()),
        );
      }
    }
  }
}

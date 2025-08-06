import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';

import '../../../generated/protocol.dart';
import 'apple_accounts_admin.dart';
import 'config.dart';

/// Apple account management functions.
abstract final class AppleAccounts {
  /// Administrative methods for working with Apple-backed accounts.
  static late AppleAccountsAdmin admin;

  static late AppleAccountConfig _config;
  static late SignInWithApple _siwa;

  /// Sets the configuration and configured the underlying utilities.
  ///
  /// This must be set before any methods on this class are invoked.
  set config(final AppleAccountConfig config) {
    _config = config;

    _siwa = SignInWithApple(
      config: SignInWithAppleConfiguration(
        serviceIdentifier: config.serviceIdentifier,
        bundleIdentifier: config.bundleIdentifier,
        redirectUri: config.redirectUri,
        teamId: config.teamId,
        keyId: config.keyId,
        key: ECPrivateKey(config.key),
      ),
    );

    admin = AppleAccountsAdmin(_siwa);
  }

  /// Returns the current configuration.
  AppleAccountConfig get config => _config;

  /// Authenticates a user using an [identityToken] and [authorizationCode].
  ///
  /// If the external user ID is not yet known in the system, a new `AuthUser`
  /// is created for it.
  static Future<AppleAuthSuccess> signIn(
    final Session session, {
    required final String identityToken,
    required final String authorizationCode,

    /// Whether the sign-in was triggered from a native Apple platform app.
    ///
    /// Pass `false` for web sign-ins or 3rd party platforms like Android.
    required final bool isNativeApplePlatformSignIn,
    final String? firstName,
    final String? lastName,
    final Transaction? transaction,
  }) async {
    final verifiedIdentityToken = await _siwa.verifyIdentityToken(
      identityToken,
      useBundleIdentifier: isNativeApplePlatformSignIn,
      nonce: null,
    );

    // TODO: Handle the edge-case where we already know the user, but they
    //       disconnected and now "registered" again, in which case we need to
    //       receive and store the new refresh token.

    var appleAccount = await AppleAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(
        verifiedIdentityToken.userId,
      ),
      transaction: transaction,
    );
    final authUserNewlyCreated = appleAccount == null;

    if (appleAccount == null) {
      final refreshToken = await _siwa.exchangeAuthorizationCode(
        authorizationCode,
        useBundleIdentifier: isNativeApplePlatformSignIn,
      );

      await DatabaseUtil.runInTransactionOrSavepoint(
        session.db,
        transaction,
        (final transaction) async {
          final authUser = await AuthUsers.create(
            session,
            transaction: transaction,
          );

          appleAccount = await AppleAccount.db.insertRow(
            session,
            AppleAccount(
              userIdentifier: verifiedIdentityToken.userId,
              refreshToken: refreshToken.refreshToken,
              refreshTokenRequestedWithBundleIdentifier:
                  isNativeApplePlatformSignIn,
              email: verifiedIdentityToken.email?.toLowerCase(),
              isEmailVerified: verifiedIdentityToken.emailVerified,
              isPrivateEmail: verifiedIdentityToken.isPrivateEmail,
              authUserId: authUser.id,
              firstName: firstName,
              lastName: lastName,
            ),
            transaction: transaction,
          );
        },
      );
    }

    final AppleAccountDetails details = (
      userIdentifier: appleAccount!.userIdentifier,
      email: appleAccount!.email,
      isVerifiedEmail: appleAccount!.isEmailVerified,
      isPrivateEmail: appleAccount!.isPrivateEmail,
      firstName: appleAccount!.firstName,
      lastName: appleAccount!.lastName,
    );

    return (
      appleAccountId: appleAccount!.id!,
      authUserId: appleAccount!.authUserId,
      details: details,
      authUserNewlyCreated: authUserNewlyCreated,
    );
  }
}

/// Details of a successful Apple-based authentication.
typedef AppleAuthSuccess = ({
  UuidValue appleAccountId,
  UuidValue authUserId,
  AppleAccountDetails details,
  bool authUserNewlyCreated,
});

/// Details of the Apple account.
typedef AppleAccountDetails = ({
  /// Apple's permanent user identifier for this account
  String userIdentifier,
  String? email,
  bool? isVerifiedEmail,
  bool? isPrivateEmail,
  String? firstName,
  String? lastName,
});

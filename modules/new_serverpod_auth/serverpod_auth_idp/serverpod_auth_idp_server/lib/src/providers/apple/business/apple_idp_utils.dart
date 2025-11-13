import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';

import '../../../generated/protocol.dart';
import 'apple_idp.dart';

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

/// Details of a successful Apple-based authentication.
typedef AppleAuthSuccess = ({
  UuidValue appleAccountId,
  UuidValue authUserId,
  AppleAccountDetails details,
  bool newAccount,
  Set<Scope> scopes,
});

/// Utility functions for the Apple identity provider.
///
/// These functions can be used to compose custom authentication and
/// administration flows if needed.
///
/// But for most cases, the methods exposed by [AppleIDP] and [AppleIDPAdmin] should
/// be sufficient.
class AppleIDPUtils {
  final TokenManager _tokenManager;
  final SignInWithApple _signInWithApple;
  final AuthUsers _authUsers;

  /// Creates a new instance of [AppleIDPUtils].
  AppleIDPUtils({
    required final TokenManager tokenManager,
    required final SignInWithApple signInWithApple,
    required final AuthUsers authUsers,
  }) : _tokenManager = tokenManager,
       _signInWithApple = signInWithApple,
       _authUsers = authUsers;

  /// Authenticates a user using an [identityToken] and [authorizationCode].
  ///
  /// If the external user ID is not yet known in the system, a new `AuthUser`
  /// is created for it.
  Future<AppleAuthSuccess> authenticate(
    final Session session, {
    required final String identityToken,
    required final String authorizationCode,

    /// Whether the sign-in was triggered from a native Apple platform app.
    ///
    /// Pass `false` for web sign-ins or 3rd party platforms like Android.
    required final bool isNativeApplePlatformSignIn,
    final String? firstName,
    final String? lastName,
    required final Transaction? transaction,
  }) async {
    final verifiedIdentityToken = await _signInWithApple.verifyIdentityToken(
      identityToken,
      useBundleIdentifier: isNativeApplePlatformSignIn,
      nonce: null,
    );

    // TODO(https://github.com/serverpod/serverpod/issues/4105):
    // Handle the edge-case where we already know the user, but they
    // disconnected and now "registered" again, in which case we need to
    // receive and store the new refresh token.

    var appleAccount = await AppleAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(
        verifiedIdentityToken.userId,
      ),
      transaction: transaction,
    );

    final createNewAccount = appleAccount == null;

    final AuthUserModel authUser = switch (createNewAccount) {
      true => await _authUsers.create(
        session,
        transaction: transaction,
      ),
      false => await _authUsers.get(
        session,
        authUserId: appleAccount!.authUserId,
      ),
    };

    if (createNewAccount) {
      final refreshToken = await _signInWithApple.exchangeAuthorizationCode(
        authorizationCode,
        useBundleIdentifier: isNativeApplePlatformSignIn,
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
    }

    final AppleAccountDetails details = (
      userIdentifier: appleAccount.userIdentifier,
      email: appleAccount.email,
      isVerifiedEmail: appleAccount.isEmailVerified,
      isPrivateEmail: appleAccount.isPrivateEmail,
      firstName: appleAccount.firstName,
      lastName: appleAccount.lastName,
    );

    return (
      appleAccountId: appleAccount.id!,
      authUserId: appleAccount.authUserId,
      details: details,
      newAccount: createNewAccount,
      scopes: authUser.scopes,
    );
  }

  /// Refreshes the Apple [appleAccount]'s refresh token to ensure it is still
  /// valid.
  ///
  /// If the token has been revoked, the [onExpiredUserAuthentication] callback
  /// is invoked with the associated auth user's ID.
  Future<void> refreshToken(
    final Session session, {
    required final AppleAccount appleAccount,
    required final void Function(UuidValue authUserId)
    onExpiredUserAuthentication,
  }) async {
    await AppleAccount.db.updateRow(
      session,
      appleAccount.copyWith(lastRefreshedAt: clock.now()),
    );

    try {
      await _signInWithApple.validateRefreshToken(
        appleAccount.refreshToken,
        useBundleIdentifier:
            appleAccount.refreshTokenRequestedWithBundleIdentifier,
      );
    } on RevokedTokenException catch (_) {
      onExpiredUserAuthentication(appleAccount.authUserId);
    }
  }

  /// Handler for revoking sessions based on server-to-server notifications
  /// coming from Apple.
  ///
  /// To be mounted as a `POST` handler under the URL configured in Apple's
  /// developer portal, for example:
  ///
  /// ```dart
  ///   Router<Handler>()..post(
  ///     '/hooks/apple-notification',
  ///     handleAppleNotification, // your function to handle the notification
  ///   );
  /// ```
  ///
  /// If the notification is of type [AppleServerNotificationConsentRevoked] or
  /// [AppleServerNotificationAccountDelete], all sessions based on the Apple
  /// authentication for that account will be revoked.
  Future<Result> serverNotificationHandler(
    final Session session,
    final Request req,
  ) async {
    final body = await utf8.decodeStream(req.body.read());
    final payload = (jsonDecode(body) as Map)['payload'] as String;

    final notification = await _signInWithApple.decodeAppleServerNotification(
      payload,
    );

    final userIdentifier = switch (notification) {
      AppleServerNotificationConsentRevoked() => notification.userIdentifier,
      AppleServerNotificationAccountDelete() => notification.userIdentifier,
      _ => null,
    };

    if (userIdentifier != null) {
      final appleAccount = await AppleAccount.db.findFirstRow(
        session,
        where: (final t) => t.userIdentifier.equals(userIdentifier),
      );

      if (appleAccount != null) {
        await _signInWithApple.revokeAuthorization(
          refreshToken: appleAccount.refreshToken,
          useBundleIdentifier:
              appleAccount.refreshTokenRequestedWithBundleIdentifier,
        );

        await _tokenManager.revokeAllTokens(
          session,
          authUserId: appleAccount.authUserId,
          method: AppleIDP.method,
        );

        if (notification is AppleServerNotificationAccountDelete) {
          await AppleAccount.db.deleteRow(session, appleAccount);
        }
      }
    }
    return Response.ok();
  }
}

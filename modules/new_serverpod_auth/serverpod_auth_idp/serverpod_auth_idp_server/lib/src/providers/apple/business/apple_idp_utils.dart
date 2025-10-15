import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';

import '../../../generated/protocol.dart';

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
  bool authUserNewlyCreated,
});

/// Utility functions for the Apple identity provider.
///
/// These functions can be used to compose custom authentication and
/// administration flows if needed.
///
/// But for most cases, the methods exposed by [AppleIDP] and [AppleIDPAdmin] should
/// be sufficient.
class AppleIDPUtils {
  final SignInWithApple _siwa;

  /// Creates a new instance of [AppleIDPUtils].
  AppleIDPUtils({required final SignInWithApple siwa}) : _siwa = siwa;

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

  /// Creates a new authentication session for the given [authUserId].
  Future<AuthSuccess> createSession(
    final Session session,
    final UuidValue authUserId, {
    final Transaction? transaction,
    required final String method,
  }) async {
    final authUser = await AuthUsers.get(
      session,
      authUserId: authUserId,
      transaction: transaction,
    );

    if (authUser.blocked) {
      throw AuthUserBlockedException();
    }

    return AuthSessions.createSession(
      session,
      authUserId: authUserId,
      method: method,
      scopes: authUser.scopes,
      transaction: transaction,
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
      await _siwa.validateRefreshToken(
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
  /// If the notification is of type [AppleServerNotificationConsentRevoked] or
  /// [AppleServerNotificationAccountDelete], all sessions based on the Apple
  /// authentication for that account will be revoked.
  Handler revokedNotificationHandler() {
    return serverNotificationHandler((final notification) async {
      final revokeSessions =
          (notification is AppleServerNotificationConsentRevoked ||
              notification is AppleServerNotificationAccountDelete);

      if (!revokeSessions) {
        // For other notification types, we do not need to take any action.
        return;
      }

      /// TODO: Implement session revocation based on the notification for all
      /// the sessions associated with the Apple account.
      return;
    });
  }

  /// Handler for server-to-server notifications coming from Apple.
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
  /// The [handler] function is invoked with the decoded [AppleServerNotification].
  /// The function can then take appropriate actions based on the notification type.
  Handler serverNotificationHandler(
    final FutureOr<void> Function(AppleServerNotification notification) handler,
  ) {
    return (final RequestContext ctx) async {
      final body = await utf8.decodeStream(ctx.request.body.read());

      final payload = (jsonDecode(body) as Map)['payload'] as String;

      final notification = await _siwa.decodeAppleServerNotification(
        payload,
      );

      await handler(notification);

      return (ctx as RespondableContext).respond(Response.ok());
    };
  }
}

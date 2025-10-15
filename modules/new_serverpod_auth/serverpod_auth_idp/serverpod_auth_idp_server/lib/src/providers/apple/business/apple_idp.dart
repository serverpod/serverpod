import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_idp_server/src/providers/apple/business/routes/apple_server_notification_route.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';

import 'apple_idp_admin.dart';
import 'apple_idp_config.dart';
import 'apple_idp_utils.dart';

/// Main class for the Apple identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [AppleIDPAdmin], which contains
/// admin-related methods for managing Apple-backed accounts.
///
/// The `utils` property provides access to [AppleIDPUtils], which contains
/// utility methods for working with Apple-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
final class AppleIDP {
  static const String _method = 'apple';

  /// Admin operations to work with Apple-backed accounts.
  late final AppleIDPAdmin admin;

  /// Utility functions for the Apple identity provider.
  late final AppleIDPUtils utils;

  /// Creates a new instance of [AppleIDP].
  AppleIDP({required final AppleIDPConfig config}) {
    final siwaConf = SignInWithAppleConfiguration(
      serviceIdentifier: config.serviceIdentifier,
      bundleIdentifier: config.bundleIdentifier,
      redirectUri: config.redirectUri,
      teamId: config.teamId,
      keyId: config.keyId,
      key: config.key,
    );

    final siwa = SignInWithApple(config: siwaConf);

    utils = AppleIDPUtils(siwa: siwa);
    admin = AppleIDPAdmin(utils: utils);
  }

  /// {@macro apple_idp_base_endpoint.login}
  Future<AuthSuccess> login(
    final Session session, {
    required final String identityToken,
    required final String authorizationCode,

    /// Whether the sign-in was triggered from a native Apple platform app.
    ///
    /// Pass `false` for web sign-ins or 3rd party platforms like Android.
    required final bool isNativeApplePlatformSignIn,
    final String? firstName,
    final String? lastName,
  }) async {
    return session.db.transaction((final transaction) async {
      final account = await utils.authenticate(
        session,
        identityToken: identityToken,
        authorizationCode: authorizationCode,
        isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
        firstName: firstName,
        lastName: lastName,
        transaction: transaction,
      );

      if (account.authUserNewlyCreated) {
        await UserProfiles.createUserProfile(
          session,
          account.authUserId,
          UserProfileData(
            fullName: [account.details.firstName, account.details.lastName]
                .nonNulls
                .map((final n) => n.trim())
                .where((final n) => n.isNotEmpty)
                .join(' '),
            email: account.details.isVerifiedEmail == true
                ? account.details.email
                : null,
          ),
          transaction: transaction,
        );
      }

      return utils.createSession(
        session,
        account.authUserId,
        transaction: transaction,
        method: _method,
      );
    });
  }

  /// {@template apple_idp.revokedNotificationRoute}
  /// Route for handling revoking sessions based on server-to-server
  /// notifications coming from Apple.
  ///
  /// To be mounted as a `POST` handler under the URL configured in Apple's
  /// developer portal, for example:
  ///
  /// ```dart
  ///  pod.webServer.addRoute(
  ///    appleIDP.revokedNotificationRoute(),
  ///    '/hooks/apple-notification',
  /// );
  /// ```
  ///
  /// If the notification is of type [AppleServerNotificationConsentRevoked] or
  /// [AppleServerNotificationAccountDelete], all sessions based on the Apple
  /// authentication for that account will be revoked.
  /// {@endtemplate}
  Route revokedNotificationRoute() {
    return AppleRevokedNotificationRoute(utils: utils);
  }
}

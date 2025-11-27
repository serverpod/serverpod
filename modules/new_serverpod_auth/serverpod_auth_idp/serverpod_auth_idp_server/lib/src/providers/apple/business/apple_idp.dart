import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';

import '../../../../core.dart';
import 'apple_idp_admin.dart';
import 'apple_idp_config.dart';
import 'apple_idp_utils.dart';
import 'routes/apple_server_notification_route.dart';

/// Main class for the Apple identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [AppleIdpAdmin], which contains
/// admin-related methods for managing Apple-backed accounts.
///
/// The `utils` property provides access to [AppleIdpUtils], which contains
/// utility methods for working with Apple-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
final class AppleIdp {
  /// The method used when authenticating with the Apple identity provider.
  static const String method = 'apple';

  /// Admin operations to work with Apple-backed accounts.
  late final AppleIdpAdmin admin;

  /// Utility functions for the Apple identity provider.
  final AppleIdpUtils utils;

  /// The configuration for the Apple identity provider.
  final AppleIdpConfig config;

  final TokenIssuer _tokenIssuer;

  final UserProfiles _userProfiles;

  AppleIdp._(
    this.config,
    this._tokenIssuer,
    this.utils,
    this.admin,
    this._userProfiles,
  );

  /// Creates a new instance of [AppleIdp].
  factory AppleIdp(
    final AppleIdpConfig config, {
    required final TokenManager tokenManager,
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
  }) {
    final signInWithAppleConfig = config.toSignInWithAppleConfiguration();

    final utils = AppleIdpUtils(
      tokenManager: tokenManager,
      signInWithApple: SignInWithApple(config: signInWithAppleConfig),
      authUsers: authUsers,
    );
    final admin = AppleIdpAdmin(utils: utils);

    return AppleIdp._(
      config,
      tokenManager,
      utils,
      admin,
      userProfiles,
    );
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
    final Transaction? transaction,
  }) async {
    return await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final account = await utils.authenticate(
          session,
          identityToken: identityToken,
          authorizationCode: authorizationCode,
          isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
          firstName: firstName,
          lastName: lastName,
          transaction: transaction,
        );

        if (account.newAccount) {
          await _userProfiles.createUserProfile(
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

        return _tokenIssuer.issueToken(
          session,
          authUserId: account.authUserId,
          method: method,
          transaction: transaction,
          scopes: account.scopes,
        );
      },
    );
  }

  /// {@macro apple_idp.revokedNotificationRoute}
  Route revokedNotificationRoute() =>
      AppleRevokedNotificationRoute(utils: utils);

  /// {@macro apple_idp.webAuthenticationCallbackRoute}
  Route webAuthenticationCallbackRoute() =>
      AppleWebAuthenticationCallbackRoute(utils: utils);
}

/// Extension to get the AppleIdp instance from the AuthServices.
extension AppleIdpGetter on AuthServices {
  /// Returns the AppleIdp instance from the AuthServices.
  AppleIdp get appleIdp => AuthServices.getIdentityProvider<AppleIdp>();
}

/// Extension to configure AppleIdp routes on the web server.
extension AppleIdpConfigureRoutes on Serverpod {
  /// Configures the routes for the AppleIdp. Must be called after the web
  /// server is initialized. If any of the paths are not provided, its route
  /// will not be added.
  void configureAppleIdpRoutes({
    final String? revokedNotificationRoutePath = '/hooks/apple-notification',
    final String? webAuthenticationCallbackRoutePath = '/auth/apple/callback',
  }) {
    final appleIdp = AuthServices.instance.appleIdp;

    if (revokedNotificationRoutePath != null) {
      webServer.addRoute(
        appleIdp.revokedNotificationRoute(),
        revokedNotificationRoutePath,
      );
    }
    if (webAuthenticationCallbackRoutePath != null) {
      webServer.addRoute(
        appleIdp.webAuthenticationCallbackRoute(),
        webAuthenticationCallbackRoutePath,
      );
    }
  }
}

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
class AppleIdp implements IdentityProvider {
  /// The method used when authenticating with the Apple identity provider.
  @override
  String get method => utils.method;

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
    AppleIdpConfig config, {
    required TokenManager tokenManager,
    AuthUsers authUsers = const AuthUsers(),
    UserProfiles userProfiles = const UserProfiles(),
  }) {
    final signInWithAppleConfig = config.toSignInWithAppleConfiguration();

    final utils = AppleIdpUtils(
      config: config,
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
    Session session, {
    required String identityToken,
    required String authorizationCode,

    /// Whether the sign-in was triggered from a native Apple platform app.
    ///
    /// Pass `false` for web sign-ins or 3rd party platforms like Android.
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
    Transaction? transaction,
  }) async {
    return await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) async {
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
                  .map((n) => n.trim())
                  .where((n) => n.isNotEmpty)
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

  /// Determines whether the current session has an associated Apple account.
  Future<bool> hasAccount(Session session) async =>
      await utils.getAccount(session) != null;

  /// Migrates all [AppleAccount]s from [userToRemoveId] to [userToKeepId].
  @override
  Future<void> mergeAuthUsers(
    Session session, {
    required UuidValue userToKeepId,
    required UuidValue userToRemoveId,
    required Transaction transaction,
  }) async {
    await AppleAccount.db.updateWhere(
      session,
      where: (t) => t.authUserId.equals(userToRemoveId),
      columnValues: (t) => [
        t.authUserId(userToKeepId),
      ],
      transaction: transaction,
    );
  }

  /// {@macro apple_idp.revokedNotificationRoute}
  Route revokedNotificationRoute() =>
      AppleRevokedNotificationRoute(utils: utils);

  /// {@macro apple_idp.webAuthenticationCallbackRoute}
  Route webAuthenticationCallbackRoute() => AppleWebAuthenticationCallbackRoute(
    utils: utils,
    androidPackageIdentifier: config.androidPackageIdentifier,
    webRedirectUri: config.webRedirectUri,
  );
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
    String? revokedNotificationRoutePath = '/hooks/apple-notification',
    String? webAuthenticationCallbackRoutePath = '/auth/apple/callback',
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

import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'facebook_idp_admin.dart';
import 'facebook_idp_config.dart';
import 'facebook_idp_utils.dart';

/// Main class for the Facebook identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [FacebookIdpAdmin], which contains
/// admin-related methods for managing Facebook-backed accounts.
///
/// The `utils` property provides access to [FacebookIdpUtils], which contains
/// utility methods for working with Facebook-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
class FacebookIdp {
  /// The method used when authenticating with the Facebook identity provider.
  static const String method = 'facebook';

  /// Admin operations to work with Facebook-backed accounts.
  final FacebookIdpAdmin admin;

  /// Utility functions for the Facebook identity provider.
  final FacebookIdpUtils utils;

  /// The configuration for the Facebook identity provider.
  final FacebookIdpConfig config;

  final TokenIssuer _tokenIssuer;

  final UserProfiles _userProfiles;

  FacebookIdp._(
    this.config,
    this._tokenIssuer,
    this.utils,
    this.admin,
    this._userProfiles,
  );

  /// Creates a new instance of [FacebookIdp].
  factory FacebookIdp(
    final FacebookIdpConfig config, {
    required final TokenManager tokenManager,
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
  }) {
    final utils = FacebookIdpUtils(
      config: config,
      authUsers: authUsers,
    );
    final admin = FacebookIdpAdmin(
      utils: utils,
    );
    return FacebookIdp._(
      config,
      tokenManager,
      utils,
      admin,
      userProfiles,
    );
  }

  /// {@macro facebook_idp_base_endpoint.login}
  Future<AuthSuccess> login(
    final Session session, {
    required final String accessToken,
    final Transaction? transaction,
  }) async {
    return await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final account = await utils.authenticate(
          session,
          accessToken: accessToken,
          transaction: transaction,
        );

        final image = account.details.image;
        if (account.newAccount) {
          try {
            await _userProfiles.createUserProfile(
              session,
              account.authUserId,
              UserProfileData(
                fullName: account.details.fullName?.trim(),
                email: account.details.email,
              ),
              transaction: transaction,
              imageSource: image != null ? UserImageFromUrl(image) : null,
            );
          } catch (e, stackTrace) {
            session.log(
              'Failed to create user profile for new Facebook user.',
              level: LogLevel.error,
              exception: e,
              stackTrace: stackTrace,
            );
          }
        } else if (image != null) {
          try {
            final user = await UserProfile.db.findFirstRow(
              session,
              where: (final t) => t.authUserId.equals(account.authUserId),
              transaction: transaction,
            );
            if (user != null && user.image == null) {
              await _userProfiles.setUserImageFromUrl(
                session,
                account.authUserId,
                image,
                transaction: transaction,
              );
            }
          } catch (e, stackTrace) {
            session.log(
              'Failed to update user profile image for existing Facebook user.',
              level: LogLevel.error,
              exception: e,
              stackTrace: stackTrace,
            );
          }
        }

        return _tokenIssuer.issueToken(
          session,
          authUserId: account.authUserId,
          transaction: transaction,
          method: method,
          scopes: account.scopes,
        );
      },
    );
  }
}

/// Extension to get the FacebookIdp instance from the AuthServices.
extension FacebookIdpGetter on AuthServices {
  /// Returns the FacebookIdp instance from the AuthServices.
  FacebookIdp get facebookIdp =>
      AuthServices.getIdentityProvider<FacebookIdp>();
}

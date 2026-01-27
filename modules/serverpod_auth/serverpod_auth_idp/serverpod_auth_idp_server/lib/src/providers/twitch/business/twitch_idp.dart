import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'twitch_idp_config.dart';
import 'twitch_idp_utils.dart';

/// Main class for the Twitch identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [TwitchIdpAdmin], which contains
/// admin-related methods for managing Twitch-backed accounts.
///
/// The `utils` property provides access to [TwitchIdpUtils], which contains
/// utility methods for working with Twitch-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
class TwitchIdp {
  /// The method used when authenticating with the Twitch identity provider.
  static const String method = 'twitch';

  /// Utility functions for the Twitch identity provider.
  final TwitchIdpUtils utils;

  /// The configuration for the Twitch identity provider.
  final TwitchIdpConfig config;

  final TokenIssuer _tokenIssuer;

  final UserProfiles _userProfiles;

  TwitchIdp._(
    this.config,
    this._tokenIssuer,
    this.utils,
    this._userProfiles,
  );

  /// Creates a new instance of [TwitchIdp].
  factory TwitchIdp(
    final TwitchIdpConfig config, {
    required final TokenIssuer tokenIssuer,
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
  }) {
    final utils = TwitchIdpUtils(
      config: config,
      authUsers: authUsers,
    );
    return TwitchIdp._(
      config,
      tokenIssuer,
      utils,
      userProfiles,
    );
  }

  /// {@macro twitch_idp_base_endpoint.login}
  Future<AuthSuccess> login(
    final Session session, {
    required final String code,
    required final String redirectUri,
    final Transaction? transaction,
  }) async {
    return await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final tokenSuccess = await utils.exchangeCodeForToken(
          session,
          code: code,
          redirectUri: redirectUri,
        );

        final account = await utils.authenticate(
          session,
          tokenSuccessResponse: tokenSuccess,
          transaction: transaction,
        );

        final image = account.details.profileImage;
        if (account.newAccount) {
          try {
            await _userProfiles.createUserProfile(
              session,
              account.authUserId,
              UserProfileData(
                userName: account.details.login,
                email: account.details.email,
              ),
              transaction: transaction,
              imageSource: image != null ? UserImageFromUrl(image) : null,
            );
          } catch (e, stackTrace) {
            session.log(
              'Failed to create user profile for new Twitch user.',
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
              'Failed to update user profile image for existing Twitch user.',
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

/// Extension to get the TwitchIdp instance from the AuthServices.
extension TwitchIdpGetter on AuthServices {
  /// Returns the TwitchIdp instance from the AuthServices.
  TwitchIdp get twitchIdp => AuthServices.getIdentityProvider<TwitchIdp>();
}

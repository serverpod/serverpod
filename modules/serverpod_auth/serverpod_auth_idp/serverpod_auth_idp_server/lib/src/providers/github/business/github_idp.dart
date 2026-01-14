import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'github_idp_admin.dart';
import 'github_idp_config.dart';
import 'github_idp_utils.dart';

/// Main class for the GitHub identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [GitHubIdpAdmin], which contains
/// admin-related methods for managing GitHub-backed accounts.
///
/// The `utils` property provides access to [GitHubIdpUtils], which contains
/// utility methods for working with GitHub-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
class GitHubIdp {
  /// The method used when authenticating with the GitHub identity provider.
  static const String method = 'github';

  /// Admin operations to work with GitHub-backed accounts.
  final GitHubIdpAdmin admin;

  /// Utility functions for the GitHub identity provider.
  final GitHubIdpUtils utils;

  /// The configuration for the GitHub identity provider.
  final GitHubIdpConfig config;

  final TokenIssuer _tokenIssuer;

  final UserProfiles _userProfiles;

  GitHubIdp._(
    this.config,
    this._tokenIssuer,
    this.utils,
    this.admin,
    this._userProfiles,
  );

  /// Creates a new instance of [GitHubIdp].
  factory GitHubIdp(
    final GitHubIdpConfig config, {
    required final TokenIssuer tokenIssuer,
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
  }) {
    final utils = GitHubIdpUtils(
      config: config,
      authUsers: authUsers,
    );
    final admin = GitHubIdpAdmin(
      utils: utils,
    );
    return GitHubIdp._(
      config,
      tokenIssuer,
      utils,
      admin,
      userProfiles,
    );
  }

  /// {@macro github_idp_base_endpoint.login}
  Future<AuthSuccess> login(
    final Session session, {
    required final String code,
    required final String codeVerifier,
    required final String redirectUri,
    final Transaction? transaction,
  }) async {
    return await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final accessToken = await utils.exchangeCodeForToken(
          session,
          code: code,
          codeVerifier: codeVerifier,
          redirectUri: redirectUri,
        );

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
                fullName: account.details.name?.trim(),
                email: account.details.email,
              ),
              transaction: transaction,
              imageSource: image != null ? UserImageFromUrl(image) : null,
            );
          } catch (e, stackTrace) {
            session.log(
              'Failed to create user profile for new GitHub user.',
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
              'Failed to update user profile image for existing GitHub user.',
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

/// Extension to get the GitHubIdp instance from the AuthServices.
extension GitHubIdpGetter on AuthServices {
  /// Returns the GitHubIdp instance from the AuthServices.
  GitHubIdp get githubIdp => AuthServices.getIdentityProvider<GitHubIdp>();
}

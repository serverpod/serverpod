import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'microsoft_idp_admin.dart';
import 'microsoft_idp_config.dart';
import 'microsoft_idp_utils.dart';

/// Main class for the Microsoft identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [MicrosoftIdpAdmin], which contains
/// admin-related methods for managing Microsoft-backed accounts.
///
/// The `utils` property provides access to [MicrosoftIdpUtils], which contains
/// utility methods for working with Microsoft-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
class MicrosoftIdp implements IdentityProvider {
  /// The method used when authenticating with the Microsoft identity provider.
  @override
  String get method => 'microsoft';

  /// Admin operations to work with Microsoft-backed accounts.
  final MicrosoftIdpAdmin admin;

  /// Utility functions for the Microsoft identity provider.
  final MicrosoftIdpUtils utils;

  /// The configuration for the Microsoft identity provider.
  final MicrosoftIdpConfig config;

  final TokenIssuer _tokenIssuer;

  final UserProfiles _userProfiles;

  MicrosoftIdp._(
    this.config,
    this._tokenIssuer,
    this.utils,
    this.admin,
    this._userProfiles,
  );

  /// Creates a new instance of [MicrosoftIdp].
  factory MicrosoftIdp(
    MicrosoftIdpConfig config, {
    required TokenIssuer tokenIssuer,
    AuthUsers authUsers = const AuthUsers(),
    UserProfiles userProfiles = const UserProfiles(),
  }) {
    final utils = MicrosoftIdpUtils(
      config: config,
      authUsers: authUsers,
    );
    final admin = MicrosoftIdpAdmin(
      utils: utils,
    );
    return MicrosoftIdp._(
      config,
      tokenIssuer,
      utils,
      admin,
      userProfiles,
    );
  }

  /// {@macro microsoft_idp_base_endpoint.login}
  Future<AuthSuccess> login(
    Session session, {
    required String code,
    required String codeVerifier,
    required String redirectUri,
    required bool isWebPlatform,
    Transaction? transaction,
  }) async {
    return await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) async {
        final accessToken = await utils.exchangeCodeForToken(
          session,
          code: code,
          codeVerifier: codeVerifier,
          redirectUri: redirectUri,
          isWebPlatform: isWebPlatform,
        );

        final account = await utils.authenticate(
          session,
          accessToken: accessToken,
          transaction: transaction,
        );

        final imageBytes = account.details.imageBytes;
        if (account.newAccount) {
          await _userProfiles.createUserProfile(
            session,
            account.authUserId,
            UserProfileData(
              fullName: account.details.name?.trim(),
              email: account.details.email,
            ),
            transaction: transaction,
            imageSource: imageBytes != null
                ? UserImageFromBytes(imageBytes)
                : null,
          );
        } else if (imageBytes != null) {
          try {
            final user = await UserProfile.db.findFirstRow(
              session,
              where: (t) => t.authUserId.equals(account.authUserId),
              transaction: transaction,
            );
            if (user != null && user.imageId == null) {
              await _userProfiles.setUserImageFromBytes(
                session,
                account.authUserId,
                imageBytes,
                transaction: transaction,
              );
            }
          } catch (e, stackTrace) {
            session.log(
              'Failed to update user profile image for existing Microsoft user.',
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

  /// Determines whether the current session has an associated Microsoft account.
  Future<bool> hasAccount(Session session) async =>
      await utils.getAccount(session) != null;

  /// Migrates [MicrosoftAccount]s from [userToRemoveId] to [userToKeepId].
  @override
  Future<void> mergeAuthUsers(
    Session session, {
    required UuidValue userToKeepId,
    required UuidValue userToRemoveId,
    required Transaction transaction,
  }) async {
    await MicrosoftAccount.db.updateWhere(
      session,
      where: (t) => t.authUserId.equals(userToRemoveId),
      columnValues: (t) => [
        t.authUserId(userToKeepId),
      ],
      transaction: transaction,
    );
  }
}

/// Extension to get the MicrosoftIdp instance from the AuthServices.
extension MicrosoftIdpGetter on AuthServices {
  /// Returns the MicrosoftIdp instance from the AuthServices.
  MicrosoftIdp get microsoftIdp =>
      AuthServices.getIdentityProvider<MicrosoftIdp>();
}

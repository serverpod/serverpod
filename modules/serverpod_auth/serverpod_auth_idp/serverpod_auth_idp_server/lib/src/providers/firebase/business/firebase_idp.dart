import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'firebase_idp_admin.dart';
import 'firebase_idp_config.dart';
import 'firebase_idp_utils.dart';

/// Main class for the Firebase identity provider.
///
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [FirebaseIdpAdmin], which contains
/// admin-related methods for managing Firebase-backed accounts.
///
/// The `utils` property provides access to [FirebaseIdpUtils], which contains
/// utility methods for working with Firebase-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
class FirebaseIdp extends Idp {
  /// The method used when authenticating with the Firebase identity provider.
  static const String method = 'firebase';

  /// Admin operations to work with Firebase-backed accounts.
  final FirebaseIdpAdmin admin;

  /// Utility functions for the Firebase identity provider.
  final FirebaseIdpUtils utils;

  /// The configuration for the Firebase identity provider.
  final FirebaseIdpConfig config;

  final TokenIssuer _tokenIssuer;

  final UserProfiles _userProfiles;

  FirebaseIdp._(
    this.config,
    this._tokenIssuer,
    this.utils,
    this.admin,
    this._userProfiles,
  );

  /// Creates a new instance of [FirebaseIdp].
  factory FirebaseIdp(
    final FirebaseIdpConfig config, {
    required final TokenIssuer tokenIssuer,
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
  }) {
    final utils = FirebaseIdpUtils(
      config: config,
      authUsers: authUsers,
    );
    final admin = FirebaseIdpAdmin(
      utils: utils,
    );
    return FirebaseIdp._(
      config,
      tokenIssuer,
      utils,
      admin,
      userProfiles,
    );
  }

  /// {@macro firebase_idp_base_endpoint.login}
  Future<AuthSuccess> login(
    final Session session, {
    required final String idToken,
    final Transaction? transaction,
  }) async {
    return await DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final account = await utils.authenticate(
          session,
          idToken: idToken,
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
              'Failed to create user profile for new Firebase user.',
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
              'Failed to update user profile image for existing Firebase user.',
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

  @override
  Future<bool> hasAccount(final Session session) async =>
      await utils.getAccount(session) != null;
}

/// Extension to get the FirebaseIdp instance from the AuthServices.
extension FirebaseIdpGetter on AuthServices {
  /// Returns the FirebaseIdp instance from the AuthServices.
  FirebaseIdp get firebaseIdp =>
      AuthServices.getIdentityProvider<FirebaseIdp>();
}

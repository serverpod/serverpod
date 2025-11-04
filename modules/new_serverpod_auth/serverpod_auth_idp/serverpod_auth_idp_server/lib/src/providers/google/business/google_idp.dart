import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import 'google_idp_admin.dart';
import 'google_idp_config.dart';
import 'google_idp_utils.dart';

/// Main class for the Google identity provider.
/// The methods defined here are intended to be called from an endpoint.
///
/// The `admin` property provides access to [GoogleIDPAdmin], which contains
/// admin-related methods for managing Google-backed accounts.
///
/// The `utils` property provides access to [GoogleIDPUtils], which contains
/// utility methods for working with Google-backed accounts. These can be used
/// to implement custom authentication flows if needed.
///
/// If you would like to modify the authentication flow, consider creating
/// custom implementations of the relevant methods.
final class GoogleIDP {
  /// The method used when authenticating with the Google identity provider.
  static const String method = 'google';

  /// Admin operations to work with Google-backed accounts.
  final GoogleIDPAdmin admin;

  /// Utility functions for the Google identity provider.
  final GoogleIDPUtils utils;

  /// The configuration for the Google identity provider.
  final GoogleIDPConfig config;

  final TokenIssuer _tokenIssuer;

  GoogleIDP._(
    this.config,
    this._tokenIssuer,
    this.utils,
    this.admin,
  );

  /// Creates a new instance of [GoogleIDP].
  factory GoogleIDP(
    final GoogleIDPConfig config, {
    required final TokenIssuer tokenIssuer,
  }) {
    final utils = GoogleIDPUtils(
      clientSecret: config.clientSecret,
    );
    final admin = GoogleIDPAdmin(
      utils: utils,
    );
    return GoogleIDP._(
      config,
      tokenIssuer,
      utils,
      admin,
    );
  }

  /// {@macro google_idp_base_endpoint.login}
  Future<AuthSuccess> login(
    final Session session, {
    required final String idToken,
    final Transaction? transaction,
  }) async {
    return await DatabaseUtil.runInTransactionOrSavepoint(
        session.db, transaction, (final transaction) async {
      final account = await utils.authenticate(
        session,
        idToken: idToken,
        transaction: transaction,
      );

      if (account.newAccount) {
        final image = account.details.image;
        try {
          await UserProfiles.createUserProfile(
            session,
            account.authUserId,
            UserProfileData(
              fullName: account.details.fullName.trim(),
              email: account.details.email,
            ),
            transaction: transaction,
            imageSource: image != null ? UserImageFromUrl(image) : null,
          );
        } catch (e, stackTrace) {
          session.log(
            'Failed to create user profile for new Google user.',
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
    });
  }
}

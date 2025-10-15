import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/session.dart';

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
  static const String _method = 'google';

  /// Admin operations to work with Google-backed accounts.
  late final GoogleIDPAdmin admin;

  /// Utility functions for the Google identity provider.
  final GoogleIDPUtils utils;

  /// Creates a new instance of [GoogleIDP].
  GoogleIDP({
    required final GoogleIDPConfig config,
  }) : utils = GoogleIDPUtils(clientSecret: config.clientSecret) {
    admin = GoogleIDPAdmin(
      utils: utils,
    );
  }

  /// {@macro google_idp_base_endpoint.login}
  Future<AuthSuccess> login(
    final Session session, {
    required final String idToken,
  }) async {
    return session.db.transaction((final transaction) async {
      final account = await utils.authenticate(
        session,
        idToken: idToken,
        transaction: transaction,
      );

      if (account.isNewUser) {
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

      return utils.createSession(
        session,
        account.authUserId,
        transaction: transaction,
        method: _method,
      );
    });
  }
}

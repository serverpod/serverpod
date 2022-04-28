// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';

import '../business/config.dart';
import '../generated/protocol.dart';

/// Endpoint for getting status for a signed in user and module configuration.
class StatusEndpoint extends Endpoint {
  /// Returns true if the client user is signed in.
  Future<bool> isSignedIn(Session session) async {
    int? userId = await session.auth.authenticatedUserId;
    return userId != null;
  }

  /// Signs out a user.
  Future<void> signOut(Session session) async {
    await session.auth.signOutUser();
  }

  /// Gets the [UserInfo] for a signed in user, or null if the user is currently
  /// not signed in with the server.
  Future<UserInfo?> getUserInfo(Session session) async {
    int? userId = await session.auth.authenticatedUserId;
    if (userId == null) return null;
    return await session.db.findById<UserInfo>(userId);
  }

  /// Gets the server configuration.
  Future<UserSettingsConfig> getUserSettingsConfig(Session session) async {
    AuthConfig config = AuthConfig.current;

    return UserSettingsConfig(
      canSeeUserName: config.userCanSeeUserName,
      canSeeFullName: config.userCanSeeFullName,
      canEditUserName: config.userCanEditUserName,
      canEditFullName: config.userCanEditFullName,
      canEditUserImage: config.userCanEditUserImage,
    );
  }
}

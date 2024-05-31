// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/src/business/user_authentication.dart';

import '../business/config.dart';
import '../generated/protocol.dart';

/// Endpoint for getting status for a signed in user and module configuration.
class StatusEndpoint extends Endpoint {
  /// Returns true if the client user is signed in.
  Future<bool> isSignedIn(Session session) async {
    var userId = (await session.authenticated)?.userId;
    return userId != null;
  }

  /// Signs out a user.
  Future<void> signOut(Session session) async {
    await UserAuthentication.signOutUser(session);
  }

  /// Gets the [UserInfo] for a signed in user, or null if the user is currently
  /// not signed in with the server.
  Future<UserInfo?> getUserInfo(Session session) async {
    var userId = (await session.authenticated)?.userId;
    if (userId == null) return null;
    return await UserInfo.db.findById(session, userId);
  }

  /// Gets the server configuration.
  Future<UserSettingsConfig> getUserSettingsConfig(Session session) async {
    var config = AuthConfig.current;

    return UserSettingsConfig(
      canSeeUserName: config.userCanSeeUserName,
      canSeeFullName: config.userCanSeeFullName,
      canEditUserName: config.userCanEditUserName,
      canEditFullName: config.userCanEditFullName,
      canEditUserImage: config.userCanEditUserImage,
    );
  }
}

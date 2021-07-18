// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import '../business/user_images.dart';
import '../generated/protocol.dart';
import '../business/config.dart';
import '../business/users.dart';

class StatusEndpoint extends Endpoint {
  Future<bool> isSignedIn(Session session) async {
    var userId = await session.auth.authenticatedUserId;
    return userId != null;
  }

  Future<void> signOut(Session session) async {
    await session.auth.signOutUser();
  }

  Future<UserInfo?> getUserInfo(Session session) async {
    var userId = await session.auth.authenticatedUserId;
    if (userId == null)
      return null;
    return (await session.db.findById(tUserInfo, userId)) as UserInfo;
  }

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
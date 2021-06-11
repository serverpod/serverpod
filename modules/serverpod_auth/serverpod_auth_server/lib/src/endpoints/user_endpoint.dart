// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../business/users.dart';

class UserEndpoint extends Endpoint {
  Future<bool> isSignedIn(Session session) async {
    var userId = await session.auth.authenticatedUserId;
    return userId != null;
  }

  Future<void> signOut(Session session) async {
    await session.auth.signOutUser();
  }

  Future<UserInfo?> getAuthenticatedUserInfo(Session session) async {
    var userId = await session.auth.authenticatedUserId;
    if (userId == null)
      return null;

    return (await session.db.findById(tUserInfo, userId)) as UserInfo;
  }

  Future<bool> updateUserInfo(Session session, UserInfo userInfo) async {
    return false;
  }
}
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

class AuthenticationEndpoint extends Endpoint {
  Future<void> removeAllUsers(Session session) async {
    await UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true));
  }

  Future<int> countUsers(Session session) async {
    return await UserInfo.db.count(session);
  }

  Future<void> createUser(
    Session session,
    String email,
    String password,
  ) async {
    var userInfo = UserInfo(
      userIdentifier: email,
      email: email,
      userName: email.split('@')[0],
      created: DateTime.now(),
      scopeNames: [],
      blocked: false,
    );
    await Users.createUser(session, userInfo);
  }

  Future<AuthenticationResponse> authenticate(
    Session session,
    String email,
    String password, [
    List<String>? scopes,
  ]) async {
    if (email == 'test@foo.bar' && password == 'password') {
      var userInfo = await Users.findUserByEmail(session, 'test@foo.bar');
      if (userInfo == null) {
        userInfo = UserInfo(
          userIdentifier: email,
          email: email,
          userName: 'Test',
          created: DateTime.now(),
          scopeNames: scopes ?? [],
          blocked: false,
        );
        userInfo = await Users.createUser(session, userInfo);
      }

      if (userInfo == null) return AuthenticationResponse(success: false);

      var authKey = await UserAuthentication.signInUser(
        session,
        userInfo.id!,
        'test',
        scopes: scopes?.map((e) => Scope(e)).toSet() ?? const {},
      );
      return AuthenticationResponse(
        success: true,
        keyId: authKey.id,
        key: authKey.key,
        userInfo: userInfo,
      );
    } else {
      return AuthenticationResponse(success: false);
    }
  }

  Future<void> signOut(Session session) async {
    await UserAuthentication.signOutUser(session);
  }

  Future<void> updateScopes(
    Session session,
    int userId,
    List<String> scopes,
  ) async {
    var newScopes = scopes.map((e) => Scope(e)).toSet();
    await Users.updateUserScopes(session, userId, newScopes);
  }
}

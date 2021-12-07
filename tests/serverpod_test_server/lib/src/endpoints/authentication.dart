import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

class AuthenticationEndpoint extends Endpoint {
  Future<AuthenticationResponse> authenticate(
      Session session, String email, String password) async {
    if (email == 'test@foo.bar' && password == 'password') {
      var userInfo = await Users.findUserByEmail(session, 'test@foo.bar');
      if (userInfo == null) {
        userInfo = UserInfo(
          userIdentifier: email,
          email: email,
          userName: 'Test',
          created: DateTime.now(),
          scopeNames: [],
          active: true,
          blocked: false,
        );
        userInfo = await Users.createUser(session, userInfo);
      }

      if (userInfo == null) return AuthenticationResponse(success: false);

      var authKey = await session.auth.signInUser(userInfo.id!, 'test');
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
}

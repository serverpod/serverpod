import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_auth_server/src/business/authentication_util.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Collects methods for authenticating users.
class UserAuthentication {
  /// Signs in an user to the server. The user should have been authenticated
  /// before signing them in. Send the AuthKey.id and key to the client and
  /// use that to authenticate in future calls. In most situations you should
  /// use one of the auth providers instead of this method.
  static Future<AuthKey> signInUser(
    Session session,
    int userId,
    String method, {
    Set<Scope> scopes = const {},
  }) async {
    var signInSalt = session.passwords['authKeySalt'] ?? defaultAuthKeySalt;

    var key = generateRandomString();
    var hash = hashString(signInSalt, key);

    var scopeNames = <String>[];
    for (var scope in scopes) {
      if (scope.name != null) scopeNames.add(scope.name!);
    }

    var authKey = AuthKey(
      userId: userId,
      hash: hash,
      key: key,
      scopeNames: scopeNames,
      method: method,
    );

    session.updateAuthenticated(AuthenticationInfo(userId, scopes));
    var result = await AuthKey.db.insertRow(session, authKey);
    return result.copyWith(key: key);
  }

  /// Signs out a user from the server and deletes all authentication keys.
  /// This means that the user will be signed out from all connected devices.
  static Future<void> signOutUser(Session session, {int? userId}) async {
    userId ??= (await session.authenticated)?.userId;
    if (userId == null) return;

    await session.db
        .deleteWhere<AuthKey>(where: AuthKey.t.userId.equals(userId));
    await session.messages
        .revokedAuthentication(userId, RevokedAuthenticationUser());
    session.updateAuthenticated(null);
  }
}

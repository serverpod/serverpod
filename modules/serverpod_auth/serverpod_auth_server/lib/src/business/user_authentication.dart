import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_server/src/business/authentication_util.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Provides methods for authenticating users.
class UserAuthentication {
  /// Signs in an user to the server. The user should have been authenticated
  /// before signing them in. Send the AuthKey.id and key to the client and
  /// use that to authenticate in future calls. In most situations you should
  /// use one of the auth providers instead of this method.
  ///
  /// - `updateSession`: If set to `true`, the session will be updated with
  ///   the authenticated user's information. The default is `true`.
  static Future<AuthKey> signInUser(
    Session session,
    int userId,
    String method, {
    Set<Scope> scopes = const {},
    bool updateSession = true,
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

    var result = await AuthKey.db.insertRow(session, authKey);

    if (updateSession) {
      session.updateAuthenticated(
        AuthenticationInfo(
          userId,
          scopes,
          authId: '${result.id}',
        ),
      );
    }
    return result;
  }

  /// Signs out a user from the server and deletes all authentication keys.
  /// This means that the user will be signed out from all connected devices.
  /// If the user being signed out is the currently authenticated user, the
  /// session's authentication information will be cleared.
  ///
  /// Note: The method will fail silently if no authentication information is
  /// found for the user.
  static Future<void> signOutUser(
    Session session, {
    int? userId,
  }) async {
    userId ??= (await session.authenticated)?.userId;
    if (userId == null) return;

    // Delete all authentication keys for the user
    var auths = await AuthKey.db.deleteWhere(
      session,
      where: (row) => row.userId.equals(userId),
    );

    if (auths.isEmpty) return;

    await session.messages.authenticationRevoked(
      userId,
      RevokedAuthenticationUser(),
    );

    // Clear session authentication if the signed-out user is the currently
    // authenticated user
    var authInfo = await session.authenticated;
    if (userId == authInfo?.userId) {
      session.updateAuthenticated(null);
    }
  }

  /// Signs out the user from the current device by deleting the specific
  /// authentication key. This does not affect the user's sessions on other
  /// devices. If the user being signed out is the currently authenticated user,
  /// the session's authentication information will be cleared.
  ///
  /// Note: The method will fail silently if no authentication information is
  /// found for the key.
  static Future<void> revokeAuthKey(
    Session session, {
    required String authKeyId,
  }) async {
    int? id = int.tryParse(authKeyId);
    if (id == null) return;

    // Delete the authentication key for the current device
    var auths = await AuthKey.db.deleteWhere(
      session,
      where: (row) => row.id.equals(id),
    );

    if (auths.isEmpty) return;
    var auth = auths.first;

    // Notify the client about the revoked authentication for the specific
    // auth key
    await session.messages.authenticationRevoked(
      auth.userId,
      RevokedAuthenticationAuthId(authId: authKeyId),
    );

    // Clear session authentication if the signed-out user is the currently
    // authenticated user
    var authInfo = await session.authenticated;
    if (auth.userId == authInfo?.userId) {
      session.updateAuthenticated(null);
    }
  }
}

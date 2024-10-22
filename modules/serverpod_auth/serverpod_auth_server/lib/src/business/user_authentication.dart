import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_auth_server/src/business/authentication_util.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Provides methods for authenticating users.
class UserAuthentication {
  /// Signs in a user and generates an authentication key.
  /// Sends the `AuthKey.id` and `key` to the client for future authentication.
  ///
  /// Before calling this method, ensure the user has been authenticated
  /// through appropriate methods (e.g., email, social sign-ins).
  /// This method only generates the authentication key after successful
  /// authentication.
  ///
  /// The authenticated user will be signed into the provided session,
  /// and their session will be updated with the user's authentication info.
  ///
  /// In most cases, use an auth provider instead of calling this method directly.
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
    return result.copyWith(key: key);
  }

  /// Signs out the user from all devices.
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

    // Notify clients about the revoked authentication for the user
    await session.messages.authenticationRevoked(
      userId,
      RevokedAuthenticationUser(),
    );

    // Clear session authentication if the signed-out user is the currently authenticated user
    var authInfo = await session.authenticated;
    if (userId == authInfo?.userId) {
      session.updateAuthenticated(null);
    }
  }

  /// Signs out the user from the current device.
  static Future<void> revokeAuthKey(
    Session session, {
    required int authKeyId,
  }) async {
    // Delete the authentication key for the current device
    var auths = await AuthKey.db.deleteWhere(
      session,
      where: (row) => row.id.equals(authKeyId),
    );

    if (auths.isEmpty) return;
    var auth = auths.first;

    // Notify the client about the revoked authentication for the specific auth key
    await session.messages.authenticationRevoked(
      auth.userId,
      RevokedAuthenticationAuthId(authId: '${auth.id}'),
    );

    // Clear session authentication if the signed-out user is the currently authenticated user
    var authInfo = await session.authenticated;
    if (auth.userId == authInfo?.userId) {
      session.updateAuthenticated(null);
    }
  }
}

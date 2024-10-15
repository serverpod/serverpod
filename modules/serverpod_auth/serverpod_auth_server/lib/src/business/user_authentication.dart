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
  /// In most cases, use an auth provider instead of calling this method directly.
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
    var result = await AuthKey.db.insertRow(session, authKey);

    session.updateAuthenticated(
      AuthenticationInfo(
        userId,
        scopes,
        authId: '${result.id}',
      ),
    );
    return result.copyWith(key: key);
  }

  /// Signs out a user from either the current session or all sessions.
  ///
  /// The [signoutOption] determines if the user is signed out from just the current session
  /// or from all active sessions.
  /// If [userId] is provided, it targets that specific user; otherwise, it signs out the current user.
  static Future<void> _signOut(
    Session session, {
    required SignOutOption signoutOption,
    int? userId,
  }) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) return;

    var tempUserId = userId ?? authInfo.userId;

    switch (signoutOption) {
      case SignOutOption.currentDevice:
        var authKeyId = int.tryParse(authInfo.authId ?? '');
        if (authKeyId == null) {
          throw StateError(
              'Authentication Key ID is missing or invalid. Unable to sign out from the current device.');
        }
        await session.db.deleteWhere<AuthKey>(
          where: AuthKey.t.userId.equals(tempUserId) &
              AuthKey.t.id.equals(authKeyId),
        );
        break;
      case SignOutOption.allDevices:
        await session.db.deleteWhere<AuthKey>(
          where: AuthKey.t.userId.equals(tempUserId),
        );
        break;
    }

    await session.messages
        .authenticationRevoked(tempUserId, RevokedAuthenticationUser());
    if (tempUserId == authInfo.userId) {
      session.updateAuthenticated(null);
    }
  }

  /// **[Deprecated]** Signs out a user.
  ///
  /// This method is deprecated. Use `signOutCurrentDevice` or `signOutAllDevices` instead.
  /// You can control the sign-out behavior using `AuthConfig.signOutOption`.
  ///
  /// Example:
  /// ```dart
  /// auth.AuthConfig.set(auth.AuthConfig(
  ///   signOutOption: auth.SignOutOption.currentDevice,
  /// ));
  /// ```
  @Deprecated(
      'Use signOutCurrentDevice or signOutAllDevices. This method will be removed in future releases.')
  static Future<void> signOutUser(
    Session session, {
    int? userId,
  }) async {
    return _signOut(
      session,
      userId: userId,
      signoutOption: AuthConfig.current.signOutOption,
    );
  }

  /// Signs out the user from the current session.
  static Future<void> signOutCurrentDevice(
    Session session, {
    int? userId,
  }) async {
    return _signOut(
      session,
      userId: userId,
      signoutOption: SignOutOption.currentDevice,
    );
  }

  /// Signs out the user from all active sessions.
  static Future<void> signOutAllDevices(
    Session session, {
    int? userId,
  }) async {
    return _signOut(
      session,
      userId: userId,
      signoutOption: SignOutOption.allDevices,
    );
  }
}

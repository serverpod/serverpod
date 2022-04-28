import '../generated/auth_key.dart';

import '../server/session.dart';
import 'authentication_info.dart';
import 'scope.dart';
import 'util.dart';

/// The default [AuthenticationHandler], uses the auth_key table from the
/// database to authenticate a user.
Future<AuthenticationInfo?> defaultAuthenticationHandler(
    Session session, String key) async {
  try {
    // Get the secret and user id
    List<String> parts = key.split(':');
    String keyIdStr = parts[0];
    int? keyId = int.tryParse(keyIdStr);
    if (keyId == null) return null;
    String secret = parts[1];

    // Get the authentication key from the database
    AuthKey? authKey = await session.db.findById<AuthKey>(keyId);
    if (authKey == null) return null;

    // Hash the key from the user and check that it is what we expect
    String signInSalt = session.passwords['authKeySalt'] ?? defaultAuthKeySalt;
    String expectedHash = hashString(signInSalt, secret);

    if (authKey.hash != expectedHash) return null;

    // All looking bright, user is signed in

    // Setup scopes
    Set<Scope> scopes = <Scope>{};
    for (String scopeName in authKey.scopeNames) {
      scopes.add(Scope(scopeName));
    }
    return AuthenticationInfo(authKey.userId, scopes);
  } catch (e) {
    return null;
  }
}

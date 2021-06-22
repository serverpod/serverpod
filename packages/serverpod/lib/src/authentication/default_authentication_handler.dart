import 'package:serverpod/src/generated/auth_key.dart';

import 'authentication_info.dart';
import 'scope.dart';
import 'util.dart';
import '../server/session.dart';

/// The default [AuthenticationHandler], uses the auth_key table from the
/// database to authenticate a user.
Future<AuthenticationInfo?> defaultAuthenticationHandler(Session session, String key) async {
  try {
    print('defaultAuthenticationHandler');
    // Get the secret and user id
    var parts = key.split(':');
    var keyIdStr = parts[0];
    var keyId = int.tryParse(keyIdStr);
    if (keyId == null)
      return null;
    var secret = parts[1];

    // Get the authentication key from the database
    var authKey = (await session.db.findById(tAuthKey, keyId)) as AuthKey?;
    if (authKey == null)
      return null;

    // Hash the key from the user and check that it is what we expect
    var signInSalt = session.passwords['authKeySalt'] ?? defaultAuthKeySalt;
    var expectedHash = hashString(signInSalt, secret);

    if (authKey.hash != expectedHash)
      return null;

    // All looking bright, user is signed in

    // Setup scopes
    var scopes = <Scope>{};
    for (var scopeName in authKey.scopes) {
      scopes.add(Scope(scopeName));
    }

    print('scopes: $scopes');

    return AuthenticationInfo(authKey.userId, scopes);
  }
  catch(e, stackTrace) {
    print('e: $e');
    print('$stackTrace');
    return null;
  }
}

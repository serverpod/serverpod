import 'dart:io';

import 'package:serverpod/src/generated/auth_key.dart';

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
    var parts = key.split(':');
    var keyIdStr = parts[0];
    var keyId = int.tryParse(keyIdStr);
    if (keyId == null) return null;
    var secret = parts[1];

    // Get the authentication key from the database
    var tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    var authKey = await tempSession.dbNext.findById<AuthKey>(keyId);
    await tempSession.close();

    if (authKey == null) return null;

    // Hash the key from the user and check that it is what we expect
    var signInSalt = session.passwords['authKeySalt'] ?? defaultAuthKeySalt;
    var expectedHash = hashString(signInSalt, secret);

    if (authKey.hash != expectedHash) return null;

    // All looking bright, user is signed in

    // Setup scopes
    var scopes = <Scope>{};
    for (var scopeName in authKey.scopeNames) {
      scopes.add(Scope(scopeName));
    }
    return AuthenticationInfo(authKey.userId, scopes);
  } catch (exception, stackTrace) {
    stderr.writeln('Failed authentication: $exception');
    stderr.writeln('$stackTrace');
    return null;
  }
}

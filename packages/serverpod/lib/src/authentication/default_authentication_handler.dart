import 'dart:io';

import '../generated/auth_key.dart';
import '../server/session.dart';
import 'authentication_info.dart';
import 'scope.dart';
import 'util.dart';

/// The default [AuthenticationHandler], uses the auth_key table from the
/// database to authenticate a user.
Future<AuthenticationInfo?> defaultAuthenticationHandler(
  Session session,
  String key,
) async {
  try {
    // Get the secret and user id
    final parts = key.split(':');
    final keyIdStr = parts[0];
    final keyId = int.tryParse(keyIdStr);
    if (keyId == null) return null;
    final secret = parts[1];

    // Get the authentication key from the database
    final tempSession = await session.serverpod.createSession(
      enableLogging: false,
    );

    final authKey = await tempSession.db.findById<AuthKey>(keyId);
    await tempSession.close();

    if (authKey == null) return null;

    // Hash the key from the user and check that it is what we expect
    final signInSalt = session.passwords['authKeySalt'] ?? defaultAuthKeySalt;
    final expectedHash = hashString(signInSalt, secret);

    if (authKey.hash != expectedHash) return null;

    // All looking bright, user is signed in

    // Setup scopes
    final scopes = <Scope>{};
    for (final scopeName in authKey.scopeNames) {
      scopes.add(Scope(scopeName));
    }
    return AuthenticationInfo(authKey.userId, scopes);
  } catch (exception, stackTrace) {
    stderr
      ..writeln('Failed authentication: $exception')
      ..writeln('$stackTrace');
    return null;
  }
}

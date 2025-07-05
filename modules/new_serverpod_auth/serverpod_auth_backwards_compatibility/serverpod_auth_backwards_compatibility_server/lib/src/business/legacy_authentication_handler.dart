import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_backwards_compatibility_server/src/generated/protocol.dart';

/// Authentication handler closely mirroring the behavior of `modules/serverpod_auth/serverpod_auth_server/lib/src/business/authentication_handler.dart`
@internal
Future<AuthenticationInfo?> legacyAuthenticationHandler(
  final Session session,
  final String key,
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

    final authKey = await LegacySession.db.findById(tempSession, keyId);
    await tempSession.close();

    if (authKey == null) return null;

    // Hash the key from the user and check that it is what we expect
    final signInSalt = session.passwords['authKeySalt'] ?? _defaultAuthKeySalt;
    final expectedHash = _hashString(signInSalt, secret);

    if (authKey.hash != expectedHash) return null;

    // All looking bright, user is signed in

    // Setup scopes
    final scopes = <Scope>{
      for (final scopeName in authKey.scopeNames) Scope(scopeName),
    };

    return AuthenticationInfo(
      authKey.authUserId,
      scopes,
      authId: keyIdStr,
    );
  } catch (exception, stackTrace) {
    stderr.writeln('Failed authentication: $exception');
    stderr.writeln('$stackTrace');
    return null;
  }
}

// copied from `modules/serverpod_auth/serverpod_auth_server/lib/src/business/authentication_util.dart`

/// Default salt used for hashing authentication keys if no salt is provided.
const _defaultAuthKeySalt = 'salty';

/// Uses SHA256 to create a hash for a string using the specified secret.
String _hashString(final String secret, final String string) {
  return sha256.convert(utf8.encode(secret + string)).toString();
}

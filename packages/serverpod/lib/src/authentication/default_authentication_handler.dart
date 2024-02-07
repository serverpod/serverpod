import 'dart:io';

import 'package:serverpod/src/authentication/authentication_handler.dart';
import 'package:serverpod/src/generated/auth_key.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../server/session.dart';
import 'authentication_info.dart';
import 'scope.dart';
import 'util.dart';

/// An [AuthenticationHandler] that uses the auth_key table from the
/// database to authenticate a user. Performs a database query for every
/// authenticated endpoint call, to look up the [AuthKey] for the user.
class DatabaseAuthenticationHandler extends AuthenticationHandler {
  String _getSalt(Session session) =>
      session.passwords['authKeySalt'] ??
      (throw 'Need to set authKeySalt in passwords config file');

  @override
  Future<AuthKey> generateAuthKey(
    Session session,
    int userId,
    Iterable<Scope> scopes,
    String method, {
    bool update = false,
  }) async {
    var key = generateRandomString();
    var hash = hashString(_getSalt(session), key);

    var scopeNames = scopes.map((scope) => scope.name).nonNulls.toList();

    var authKey = AuthKey(
      userId: userId,
      hash: hash,
      key: key,
      scopeNames: scopeNames,
      method: method,
    );

    var result = update
        ? await AuthKey.db.updateRow(session, authKey)
        : await AuthKey.db.insertRow(session, authKey);
    return result.copyWith(key: key);
  }

  @override
  Future<AuthenticationInfo?> authenticate(Session session, String key) async {
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
      var signInSalt = _getSalt(session);
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
}

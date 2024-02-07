import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/src/authentication/authentication_handler.dart';
import 'package:serverpod/src/generated/auth_key.dart';

import '../server/session.dart';
import 'authentication_info.dart';
import 'scope.dart';
import 'util.dart';

/// The default [AuthenticationHandler], uses the auth_key table from the
/// database to authenticate a user.
class JwtAuthenticationHandler extends AuthenticationHandler {
  final Duration tokenLifespan;

  /// Creates a new [JwtAuthenticationHandler] with the given [tokenLifespan]
  /// (which defaults to 10 minutes).
  JwtAuthenticationHandler({this.tokenLifespan = const Duration(minutes: 10)});

  String _getSecret(Session session) =>
      session.passwords['authKeySecret'] ??
      (throw 'Need to set authKeySecret in passwords config file');

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
    // We comma-separate scope names in the JWT
    if (scopes.any((scope) => (scope.name ?? '').contains(','))) {
      throw Exception('Scope names cannot contain commas');
    }

    // Generate JWT from payload map
    var jwt = JWT(
      {
        'userId': userId,
        // Ensure scopes are sorted for consistent token generation
        'scopes': scopes.map((scope) => scope.name).nonNulls.sorted().join(','),
        'method': method,
        'expires':
            DateTime.now().add(tokenLifespan).millisecondsSinceEpoch ~/ 1000,
      },
    );

    // Sign JWT (default uses HS256 algorithm)
    var token = jwt.sign(SecretKey(_getSecret(session)));

    // Hash the token (probably not necessary for a JWT, but AuthKey requires
    // a hash to be provided)
    var hash = hashString(_getSalt(session), token);

    var scopeNames = scopes.map((scope) => scope.name).nonNulls.toList();

    var authKey = AuthKey(
      userId: userId,
      hash: hash,
      key: token,
      scopeNames: scopeNames,
      method: method,
    );

    AuthKey result;
    if (update) {
      var existingAuthKey = await AuthKey.db
          .findFirstRow(session, where: (t) => t.userId.equals(userId));
      if (existingAuthKey == null) {
        // Should not happen
        throw Exception('No existing auth key found for user $userId');
      }
      result =
          await AuthKey.db.updateRow(session, authKey..id = existingAuthKey.id);
    } else {
      result = await AuthKey.db.insertRow(session, authKey);
    }
    return result.copyWith(key: token);
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

      // Verify the token (throws an exception if verification fails)
      var jwt = JWT.verify(secret, SecretKey(_getSecret(session)));
      var userId = jwt.payload['userId'] as int;
      var scopesStr = jwt.payload['scopes'] as String;
      // Use the `expires` field to check if the token has expired,
      // rather than the standard `exp` field, because then we still
      // get the other fields in the jwt object (which has been
      // cryptographicall verified), so we can reuse the userId
      // and scopes. (Otherwise, JWT.verify would throw an exception
      // if the token has expired.)
      var expires = jwt.payload['expires'] as int;

      if (DateTime.fromMillisecondsSinceEpoch(expires * 1000)
          .isBefore(DateTime.now())) {
        // JWT has expired -- regenerate it by looking up the auth
        // key in the database, to ensure user is still allowed
        // to be logged in, and that scopes are up to date.
        var tempSession = await session.serverpod.createSession(
          enableLogging: false,
        );
        var authKey = await AuthKey.db
            .findFirstRow(tempSession, where: (t) => t.userId.equals(userId));
        if (authKey == null) {
          // User login has been invalidated
          return null;
        }
        // Update the AuthKey so that it has the new expiration time
        await generateAuthKey(
          tempSession,
          authKey.userId,
          authKey.scopes,
          authKey.method,
          update: true,
        );
        await tempSession.close();
        // Update JWT scopes from the AuthKey
        scopesStr = authKey.scopeNames.sorted().join(',');
      }

      // User is signed in

      // Setup scopes
      var scopes = <Scope>{};
      for (var scopeName in scopesStr.split(',')) {
        scopes.add(Scope(scopeName));
      }
      return AuthenticationInfo(userId, scopes);
    } catch (exception, stackTrace) {
      stderr.writeln('Failed JWT authentication: $exception');
      stderr.writeln('$stackTrace');
      return null;
    }
  }
}

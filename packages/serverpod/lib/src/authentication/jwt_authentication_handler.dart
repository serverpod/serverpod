import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/src/authentication/authentication_handler.dart';
import 'package:serverpod/src/generated/auth_key.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

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
    var jwt = JWT(
      // Payload
      {
        'id': userId,
        'scopes': scopes.map((scope) => scope.name).nonNulls.sorted().join(','),
        'method': method,
        'exp': DateTime.now().add(tokenLifespan).millisecondsSinceEpoch ~/ 1000,
      },
    );

    // Sign it (default with HS256 algorithm)
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

    var result = update
        ? await AuthKey.db.updateRow(session, authKey)
        : await AuthKey.db.insertRow(session, authKey);
    return result.copyWith(key: token);
  }

  @override
  Future<AuthenticationInfo?> authenticate(Session session, String key) async {
    var expired = false;
    JWT? jwt;
    try {
      // Verify the token
      jwt = JWT.verify(key, SecretKey(_getSecret(session)));
    } on JWTExpiredException {
      // JWT has expired -- regenerate it, to ensure user is still allowed
      // to be logged in, and that scopes are up to date.
      // TODO: check that the AuthKey table has an index on userId
      var authKey = await AuthKey.db.findFirstRow(session,
          where: (t) => t.userId.equals(jwt.payload['id']));
      if (authKey == null) {
        return null;
      }
      // Update the AuthKey so that it has the new expiration time
      await generateAuthKey(
        session,
        authKey.userId,
        authKey.scopes,
        authKey.method,
        update: true,
      );
    } on JWTException catch (ex) {
      print(ex.message); // ex: invalid signature
    }

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
}

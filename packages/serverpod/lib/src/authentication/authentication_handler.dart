import 'package:serverpod/src/generated/auth_key.dart';

import '../server/session.dart';
import 'authentication_info.dart';
import 'scope.dart';

/// Returns authentication information for a given [Session] and [key] or null
/// if the key is invalid.
abstract class AuthenticationHandler {
  /// Returns the salt used for hashing the authentication key.
  Future<String> getSalt(Session session);

  /// Generates a new authentication key for the user with the given [userId].
  Future<AuthKey> generateAuthKey(Session session, int userId, String secret,
      List<Scope> scopes, String method);

  /// Authenticates the user with the given [key] and returns the userId and
  /// scopes in an [AuthenticationInfo] object, or null if the key is invalid.
  Future<AuthenticationInfo?> authenticate(Session session, String key);
}

import 'package:serverpod/src/authentication/authentication_handler.dart';
import 'package:serverpod/src/generated/auth_key.dart';

import '../server/session.dart';
import 'authentication_info.dart';
import 'scope.dart';

/// An [AuthenticationHandler] that logs a service into a session based on a
/// secret.
class ServiceAuthenticationHandler extends AuthenticationHandler {
  /// Unused
  @override
  Future<String> getSalt(Session session) => throw UnimplementedError();

  @override
  Future<AuthKey> generateAuthKey(
    Session session,
    int userId,
    Iterable<Scope> scopes,
    String method, {
    bool update = false,
  }) =>
      // TODO: I don't think this is called anywhere, but I'm not sure
      throw UnimplementedError();

  @override
  Future<AuthenticationInfo?> authenticate(Session session, String key) async {
    try {
      var parts = key.split(':');
      // var name = parts[0];
      var secret = parts[1];

      if (secret == session.server.serverpod.config.serviceSecret) {
        return AuthenticationInfo(0, <Scope>{Scope.none});
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

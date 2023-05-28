import '../server/session.dart';
import 'authentication_info.dart';
import 'scope.dart';

/// The [AuthenticationHandler] for the servers service connection.
Future<AuthenticationInfo?> serviceAuthenticationHandler(
  Session session,
  String key,
) async {
  try {
    final parts = key.split(':');
    // var name = parts[0];
    final secret = parts[1];

    if (secret == session.server.serverpod.config.serviceSecret) {
      return AuthenticationInfo(0, <Scope>{Scope.none});
    }
  } catch (e) {
    return null;
  }

  return null;
}

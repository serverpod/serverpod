import 'authentication_info.dart';
import 'scope.dart';
import '../server/session.dart';

Future<AuthenticationInfo?> serviceAuthenticationHandler(Session session, String key) async {
  try {
    var parts = key.split(':');
    // var name = parts[0];
    var secret = parts[1];

    if (secret == session.server.serverpod.config.serviceSecret) {
      return AuthenticationInfo(0, <Scope>{scopeNone});
    }
  }
  catch(e) {}

  return null;
}

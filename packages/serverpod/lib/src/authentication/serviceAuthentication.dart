import 'authentication_info.dart';
import 'scope.dart';
import '../server/config.dart';
import '../server/session.dart';
import 'package:serverpod_client/src/auth_key_manager.dart';

Future<AuthenticationInfo> serviceAuthenticationHandler(Session session, String key) async {
  try {
    var parts = key.split(':');
    var name = parts[0];
    var secret = parts[1];

    if (secret == session.server.serverpod.config.serviceSecret) {
      return AuthenticationInfo(name, <Scope>{scopeNone});
    }
  }
  catch(e) {}

  return null;
}

class ServiceKeyManager extends AuthenticationKeyManager {
  final String name;
  final ServerConfig config;

  ServiceKeyManager(this.name, this.config);

  Future<String> get() async {
    return 'name:${config.serviceSecret}';
  }
  Future<Null> put(String key) async {
  }
}
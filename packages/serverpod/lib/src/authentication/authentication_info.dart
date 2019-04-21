import 'scope.dart';
import '../server/server.dart';

typedef Future<AuthenticationInfo> AuthenticationHandler(Server server, String key);

class AuthenticationInfo {
  final String authenticatedUser;
  final List<Scope> scopes;

  AuthenticationInfo(this.authenticatedUser, this.scopes);
}

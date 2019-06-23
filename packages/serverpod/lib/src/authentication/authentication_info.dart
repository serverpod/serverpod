import 'scope.dart';
import '../server/session.dart';

typedef Future<AuthenticationInfo> AuthenticationHandler(Session session, String key);

class AuthenticationInfo {
  final String authenticatedUser;
  final Set<Scope> scopes;

  AuthenticationInfo(this.authenticatedUser, this.scopes);
}

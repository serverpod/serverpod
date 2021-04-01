import 'scope.dart';
import '../server/session.dart';

typedef Future<AuthenticationInfo?> AuthenticationHandler(Session session, String key);

class AuthenticationInfo {
  final int authenticatedUserId;
  final Set<Scope> scopes;

  AuthenticationInfo(this.authenticatedUserId, this.scopes);
}

import 'scope.dart';
import '../server/session.dart';

typedef AuthenticationHandler = Future<AuthenticationInfo?> Function(Session session, String key);

class AuthenticationInfo {
  final int authenticatedUserId;
  final Set<Scope> scopes;

  AuthenticationInfo(this.authenticatedUserId, this.scopes);
}

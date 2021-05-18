import 'scope.dart';
import '../server/session.dart';

/// Returns authentication information for a given [Session] and [key] or null
/// if the key is invalid.
typedef AuthenticationHandler = Future<AuthenticationInfo?> Function(Session session, String key);

/// Holds the id for an authenticated user and which [scopes] it can access.
/// Allowed scopes are defined for each [Endpoint].
class AuthenticationInfo {
  /// Id for an authenticated user.
  final int authenticatedUserId;

  /// The scopes that the user can access.
  final Set<Scope> scopes;

  /// Creates a new [AuthenticationInfo].
  AuthenticationInfo(this.authenticatedUserId, this.scopes);
}

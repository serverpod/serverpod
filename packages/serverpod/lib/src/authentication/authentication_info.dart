import 'scope.dart';
import '../server/session.dart';

/// Returns authentication information for a given [Session] and [token] or null
/// if the key is invalid.
typedef AuthenticationHandler = Future<AuthenticationInfo?> Function(
  Session session,
  String token,
);

/// Holds the id for an authenticated user and which [scopes] it can access.
/// Allowed scopes are defined for each [Endpoint].
class AuthenticationInfo {
  /// Id for an authenticated user.
  final int userId;

  /// The scopes that the user can access.
  final Set<Scope> scopes;

  /// The authentication key id.
  final String? authId;

  /// Creates a new [AuthenticationInfo].
  AuthenticationInfo(this.userId, this.scopes, {this.authId});
}

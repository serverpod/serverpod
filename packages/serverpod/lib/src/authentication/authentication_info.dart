import 'scope.dart';

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

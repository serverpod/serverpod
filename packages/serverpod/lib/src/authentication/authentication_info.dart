import '../server/session.dart';
import 'scope.dart';

/// Returns authentication information for a given [Session] and [token] or null
/// if the key is invalid.
typedef AuthenticationHandler = Future<AuthenticationInfo?> Function(
  Session session,
  String token,
);

/// Holds the id for an authenticated user and which [scopes] it can access.
/// Allowed scopes are defined for each [Endpoint].
class AuthenticationInfo {
  /// Returns the `int` user ID of the authenticated user.
  ///
  /// Assumes that the system uses `int` user IDs, otherwise throws.
  int get userId {
    return int.parse(userIdentifier, radix: 10);
  }

  /// Identifier of the user, as set by the [AuthenticationHandler].
  final String userIdentifier;

  /// The scopes that the user can access.
  final Set<Scope> scopes;

  /// The authentication key id.
  final String? authId;

  /// Creates a new [AuthenticationInfo].
  AuthenticationInfo(
    Object userIdentifier,
    this.scopes, {
    this.authId,
  }) : userIdentifier = userIdentifier.toString();
}

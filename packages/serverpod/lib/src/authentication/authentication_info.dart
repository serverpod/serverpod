import '../server/session.dart';
import 'scope.dart';

/// Returns authentication information for a given [Session] and [token] or null
/// if the key is invalid.
typedef AuthenticationHandler =
    Future<AuthenticationInfo?> Function(
      Session session,
      String token,
    );

/// Holds the id for an authenticated user and which [scopes] it can access.
/// Allowed scopes are defined for each [Endpoint].
class AuthenticationInfo {
  /// Identifier of the user, as set by the [AuthenticationHandler].
  ///
  /// For example when using the `serverpod_auth_user` module, this contains the
  /// current auth user's ID as a UUID string.
  final String userIdentifier;

  /// The scopes that the user can access.
  final Set<Scope> scopes;

  /// The authentication key id.
  ///
  /// For example when using the `serverpod_auth_session` module, this contains
  /// the auth session's ID as a UUID string.
  final String? authId;

  /// Creates a new [AuthenticationInfo].
  AuthenticationInfo(
    this.userIdentifier,
    this.scopes, {
    this.authId,
  }) {
    if (userIdentifier.isEmpty) {
      throw ArgumentError(
        'The user identifier must not be empty.',
        'userIdentifier',
      );
    }
  }
}

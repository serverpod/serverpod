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
  /// Integer Id for an authenticated user.
  ///
  /// Will throw in case the ID of the authenticated user is not an integer.
  @Deprecated(
    'Use the authentication packages typed getter on `Session` instead (`await session.userId` from `serverpod_auth`)',
  )
  int get userId => int.parse(user, radix: 10);

  /// Identifier of the user, as set by the session handler.
  final String user;

  /// The scopes that the user can access.
  final Set<Scope> scopes;

  /// The authentication key id.
  final String? authId;

  /// Creates a new [AuthenticationInfo].
  AuthenticationInfo(
    @Deprecated('User parameter `user` instead') int? userId,
    this.scopes, {
    this.authId,
    String? user,
  }) : user = user ?? userId!.toString();
}

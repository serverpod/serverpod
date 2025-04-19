import 'package:serverpod/serverpod.dart';

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
  ///
  /// Can only be `int` or `UuidValue`.
  // @deprecated("")
  final dynamic userId;

  // TBD: New field
  // final String user;

  /// The scopes that the user can access.
  final Set<Scope> scopes;

  /// The authentication key id.
  final String? authId;

  /// Creates a new [AuthenticationInfo].
  AuthenticationInfo(this.userId, this.scopes, {this.authId}) {
    if (userId is! int && userId is! UuidValue) {
      throw Exception('Invalid `userId` data type "${userId.runtimeType}"');
    }
  }
}

// This could live in the `auth2` package
// extension on AuthenticationInfo {
//   UuidValue get userUuid {
//     return UuidValue.fromString(user);
//   }
// }

// extension on Session {
// Future<UserProfile> get userProfile {
//     UserProfile.db.find(where: t => t.userId == session.auth.userId);
//   }
// }

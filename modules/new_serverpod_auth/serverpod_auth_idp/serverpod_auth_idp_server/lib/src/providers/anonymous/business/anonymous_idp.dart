import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

/// Main class for the anonymous identity provider.
/// The method defined here ([signIn]) is intended to be called from an endpoint.
class AnonymousIdp {
  /// The method used when authenticating with the Anonymous identity provider.
  static const String method = 'anonymous';

  final AuthUsers _authUsers;
  final UserProfiles _userProfiles;
  final TokenManager _tokenManager;

  /// Creates a new instance of [AnonymousIdp].
  const AnonymousIdp({
    final AuthUsers authUsers = const AuthUsers(),
    final UserProfiles userProfiles = const UserProfiles(),
    required final TokenManager tokenManager,
  }) : _authUsers = authUsers,
       _userProfiles = userProfiles,
       _tokenManager = tokenManager;

  /// Signs in a user anonymously.
  ///
  /// Creates new [AuthUser] and [UserProfile] records, and issues a new
  /// session.
  Future<AuthSuccess> signIn(
    final Session session, {
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        // 1. Create a new AuthUser
        final authUser = await _authUsers.create(
          session,
          transaction: transaction,
        );

        // 2. Create a new UserProfile
        await _userProfiles.createUserProfile(
          session,
          authUser.id,
          UserProfileData(),
          transaction: transaction,
        );

        // 3. Create a session for the new user
        return _tokenManager.issueToken(
          session,
          authUserId: authUser.id,
          method: method,
          scopes: authUser.scopes,
          transaction: transaction,
        );
      },
    );
  }
}

/// Extension to get the AnonymousIdp instance from the AuthServices.
extension AnonymousIdpGetter on AuthServices {
  /// Returns the AnonymousIdp instance from the AuthServices.
  AnonymousIdp get anonymousIdp =>
      AuthServices.getIdentityProvider<AnonymousIdp>();
}

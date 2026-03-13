import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/business/auth_backwards_compatibility.dart';
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Endpoint for legacy admin operations. Requires admin scope.
class LegacyAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  /// Finds a user by legacy user id.
  Future<LegacyUserInfo?> getUserInfo(
    final Session session,
    final int userId,
  ) async {
    final authUserId = await _findAuthUserIdByLegacyUserId(session, userId);
    if (authUserId == null) return null;

    final authUser = await AuthUser.db.findById(session, authUserId);
    if (authUser == null) return null;

    final profile = await AuthServices.instance.userProfiles
        .maybeFindUserProfileByUserId(session, authUserId);

    return LegacyUserInfo(
      id: userId,
      userIdentifier: authUserId.toString(),
      userName: profile?.userName,
      fullName: profile?.fullName,
      email: profile?.email,
      created: authUser.createdAt,
      imageUrl: profile?.imageUrl?.toString(),
      scopeNames: authUser.scopeNames.toList(),
      blocked: authUser.blocked,
    );
  }

  /// Marks a user as blocked and revokes all tokens.
  Future<void> blockUser(final Session session, final int userId) async {
    final authUser = await _findAuthUserByLegacyUserId(session, userId);
    if (authUser == null) {
      throw InvalidParametersException('userId $userId not found');
    }
    if (authUser.blocked) {
      throw InvalidParametersException('userId $userId already blocked');
    }

    await AuthServices.instance.authUsers.update(
      session,
      authUserId: authUser.id!,
      blocked: true,
    );
    await AuthServices.instance.tokenManager.revokeAllTokens(
      session,
      authUserId: authUser.id!,
    );
  }

  /// Unblocks a user so that they can log in again.
  Future<void> unblockUser(final Session session, final int userId) async {
    final authUser = await _findAuthUserByLegacyUserId(session, userId);
    if (authUser == null) {
      throw InvalidParametersException('userId $userId not found');
    }
    if (!authUser.blocked) {
      throw InvalidParametersException('userId $userId already unblocked');
    }

    await AuthServices.instance.authUsers.update(
      session,
      authUserId: authUser.id!,
      blocked: false,
    );
  }

  Future<AuthUser?> _findAuthUserByLegacyUserId(
    final Session session,
    final int userId,
  ) async {
    final authUserId = await _findAuthUserIdByLegacyUserId(session, userId);
    if (authUserId == null) return null;
    return AuthUser.db.findById(session, authUserId);
  }

  Future<UuidValue?> _findAuthUserIdByLegacyUserId(
    final Session session,
    final int userId,
  ) async {
    final legacyRows = await session.db.unsafeQuery(
      'SELECT "userIdentifier" FROM serverpod_user_info WHERE id = \$1 LIMIT 1',
      parameters: QueryParameters.positional([userId]),
    );
    if (legacyRows.isEmpty) return null;

    final legacyIdentifier = legacyRows.first[0] as String?;
    if (legacyIdentifier == null || legacyIdentifier.isEmpty) return null;

    return AuthBackwardsCompatibility.lookUpLegacyExternalUserIdentifier(
      session,
      userIdentifier: legacyIdentifier,
    );
  }
}

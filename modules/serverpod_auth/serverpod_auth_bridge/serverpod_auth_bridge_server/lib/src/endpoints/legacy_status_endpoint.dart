import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Proxy endpoint for legacy session status operations (sign-in check,
/// sign-out, user info retrieval).
class LegacyStatusEndpoint extends Endpoint {
  /// Returns whether the current session is authenticated.
  Future<bool> isSignedIn(final Session session) async {
    return session.isUserSignedIn;
  }

  /// Signs out the current device by deleting the legacy session.
  Future<void> signOutDevice(final Session session) async {
    final authId = int.tryParse(session.authenticated?.authId ?? '');
    if (authId != null) {
      await LegacySession.db.deleteWhere(
        session,
        where: (final t) => t.id.equals(authId),
      );
    }
  }

  /// Signs out all devices by deleting all legacy sessions for the user.
  Future<void> signOutAllDevices(final Session session) async {
    final userIdentifier = session.authenticated?.userIdentifier;
    if (userIdentifier != null) {
      final uuid = UuidValue.withValidation(userIdentifier);
      await LegacySession.db.deleteWhere(
        session,
        where: (final t) => t.authUserId.equals(uuid),
      );
    }
  }

  /// Returns legacy-format user info for the authenticated user.
  Future<LegacyUserInfo?> getUserInfo(final Session session) async {
    final userIdentifier = session.authenticated?.userIdentifier;
    if (userIdentifier == null) return null;
    final uuid = UuidValue.withValidation(userIdentifier);

    final authUser = await AuthUser.db.findById(session, uuid);
    if (authUser == null) return null;

    final profile = await AuthServices.instance.userProfiles
        .maybeFindUserProfileByUserId(session, uuid);

    int? legacyId;
    final profileEmail = profile?.email;
    if (profileEmail != null) {
      final legacyRows = await session.db.unsafeQuery(
        'SELECT id FROM serverpod_user_info WHERE email = \$1 LIMIT 1',
        parameters: QueryParameters.positional([profileEmail]),
      );
      legacyId = legacyRows.isNotEmpty ? legacyRows.first[0] as int? : null;
    }

    return LegacyUserInfo(
      id: legacyId,
      userIdentifier: userIdentifier,
      userName: profile?.userName,
      fullName: profile?.fullName,
      email: profile?.email,
      created: authUser.createdAt,
      imageUrl: profile?.imageUrl?.toString(),
      scopeNames: authUser.scopeNames.toList(),
      blocked: authUser.blocked,
    );
  }

  /// Returns a static user settings configuration for legacy clients.
  ///
  /// This mirrors the capabilities supported by the bridge's legacy endpoints,
  /// so clients can show settings that are actually available.
  Future<LegacyUserSettingsConfig> getUserSettingsConfig(
    final Session session,
  ) async {
    return LegacyUserSettingsConfig(
      canSeeUserName: true,
      canSeeFullName: true,
      canEditUserName: true,
      canEditFullName: true,
      canEditUserImage: true,
    );
  }
}

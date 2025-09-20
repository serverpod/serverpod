import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/authentication_tokens.dart';

/// Endpoint for getting status and managing a signed in user.
class StatusEndpoint extends Endpoint {
  /// Returns true if the client user is signed in.
  Future<bool> isSignedIn(final Session session) async {
    final authInfo = await session.authenticated;
    return authInfo?.authId != null;
  }

  // TODO: Replace signout methods implementation by using the [TokenManager]
  // class that once it is implemented. This class will allow revoking the token
  // from the specific issuer without having to try each of the available ones.
  // POC spec: https://github.com/serverpod/serverpod/pull/3970/files

  /// Signs out a user from the current device.
  Future<void> signOutDevice(final Session session) async {
    final authInfoIdStr = (await session.authenticated)?.authId;
    if (authInfoIdStr == null) return;
    final authInfoId = UuidValue.withValidation(authInfoIdStr);

    if (!await AuthenticationTokens.destroyRefreshToken(session,
        refreshTokenId: authInfoId)) {
      await AuthSessions.destroySession(session, authSessionId: authInfoId);
    }
  }

  /// Signs out a user from all active devices.
  Future<void> signOutAllDevices(final Session session) async {
    final authUserIdStr = (await session.authenticated)?.userIdentifier;
    if (authUserIdStr == null) return;
    final authUserId = UuidValue.withValidation(authUserIdStr);

    await AuthenticationTokens.destroyAllRefreshTokens(session,
        authUserId: authUserId);
    await AuthSessions.destroyAllSessions(session, authUserId: authUserId);
  }
}

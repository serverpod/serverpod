import 'package:serverpod/serverpod.dart';
import '../business/auth_services.dart';
import '../integrations/token_manager.dart';

/// Endpoint for getting status and managing a signed in user.
class StatusEndpoint extends Endpoint {
  /// Gets the [TokenManager] from the [AuthServices] instance.
  ///
  /// If [TokenManager] should be fetched from a different source, override
  /// this method.
  TokenManager get tokenManager => AuthServices.instance.tokenManager;

  /// Returns true if the client user is signed in.
  Future<bool> isSignedIn(final Session session) async {
    final authInfo = session.authenticated;
    return authInfo?.authId != null;
  }

  /// Signs out a user from the current device.
  Future<void> signOutDevice(final Session session) async {
    final authInfoIdStr = (session.authenticated)?.authId;
    if (authInfoIdStr == null) return;
    final authInfoId = UuidValue.withValidation(authInfoIdStr);

    await tokenManager.revokeToken(session, tokenId: authInfoId.toString());
  }

  /// Signs out a user from all active devices.
  Future<void> signOutAllDevices(final Session session) async {
    final authUserIdStr = session.authenticated?.userIdentifier;
    if (authUserIdStr == null) return;
    final authUserId = UuidValue.withValidation(authUserIdStr);

    await tokenManager.revokeAllTokens(session, authUserId: authUserId);
  }
}

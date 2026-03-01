import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart';

/// Stub endpoint for legacy Google authentication. Always returns an error
/// because social auth is not supported via the bridge.
class LegacyGoogleEndpoint extends Endpoint {
  /// Stub — Google server auth code authentication is not supported.
  Future<LegacyAuthenticationResponse> authenticateWithServerAuthCode(
    final Session session,
    final String authenticationCode,
    final String? redirectUri,
  ) async {
    return LegacyAuthenticationResponse(
      success: false,
      failReason: LegacyAuthenticationFailReason.internalError,
    );
  }

  /// Stub — Google ID token authentication is not supported.
  Future<LegacyAuthenticationResponse> authenticateWithIdToken(
    final Session session,
    final String idToken,
  ) async {
    return LegacyAuthenticationResponse(
      success: false,
      failReason: LegacyAuthenticationFailReason.internalError,
    );
  }
}

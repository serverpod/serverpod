import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart';

/// Stub endpoint for legacy Firebase authentication. Always returns an error
/// because social auth is not supported via the bridge.
class LegacyFirebaseEndpoint extends Endpoint {
  /// Stub — Firebase authentication is not supported.
  Future<LegacyAuthenticationResponse> authenticate(
    final Session session,
    final String idToken,
  ) async {
    return LegacyAuthenticationResponse(
      success: false,
      failReason: LegacyAuthenticationFailReason.internalError,
    );
  }
}

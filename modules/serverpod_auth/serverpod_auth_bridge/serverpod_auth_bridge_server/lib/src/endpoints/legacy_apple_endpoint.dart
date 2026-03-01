import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart';

/// Stub endpoint for legacy Apple authentication. Always returns an error
/// because social auth is not supported via the bridge.
class LegacyAppleEndpoint extends Endpoint {
  /// Stub — Apple authentication is not supported.
  Future<LegacyAuthenticationResponse> authenticate(
    final Session session,
    final Map<String, dynamic> authInfo,
  ) async {
    return LegacyAuthenticationResponse(
      success: false,
      failReason: LegacyAuthenticationFailReason.internalError,
    );
  }
}

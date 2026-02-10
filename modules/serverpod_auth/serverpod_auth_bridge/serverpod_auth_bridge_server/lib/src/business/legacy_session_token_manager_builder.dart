import 'package:serverpod_auth_bridge_server/src/business/legacy_session_token_manager.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Builder that creates [LegacySessionTokenManager] instances for registration
/// with [AuthServices].
class LegacySessionTokenManagerBuilder
    implements TokenManagerBuilder<LegacySessionTokenManager> {
  @override
  LegacySessionTokenManager build({required final AuthUsers authUsers}) {
    return LegacySessionTokenManager();
  }
}

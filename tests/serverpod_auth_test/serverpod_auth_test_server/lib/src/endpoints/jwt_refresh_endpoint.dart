import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

class JwtRefreshEndpoint extends RefreshJwtTokensEndpoint {
  static int _activeRefreshes = 0;
  static int maxConcurrentRefreshes = 0;
  static int refreshCallCount = 0;

  static void resetConcurrencyTracking() {
    _activeRefreshes = 0;
    maxConcurrentRefreshes = 0;
    refreshCallCount = 0;
  }

  @unauthenticatedClientCall
  @override
  Future<AuthSuccess> refreshAccessToken(
    final Session session, {
    final String? refreshToken,
  }) async {
    refreshCallCount++;
    _activeRefreshes++;
    if (_activeRefreshes > maxConcurrentRefreshes) {
      maxConcurrentRefreshes = _activeRefreshes;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return await super.refreshAccessToken(
        session,
        refreshToken: refreshToken,
      );
    } finally {
      _activeRefreshes--;
    }
  }
}

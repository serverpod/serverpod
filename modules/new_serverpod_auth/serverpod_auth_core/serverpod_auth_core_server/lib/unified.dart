import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/src/common/business/auth_config.dart';

import 'src/common/business/token_manager.dart';

export 'src/common/business/auth_config.dart';

/// Authentication handler that supports both JWT and SAS auth tokens.
abstract final class UnifiedAuthTokens {
  /// The token manager to use for the session migration.
  ///
  /// If [TokenManager] should be fetched from a different source, override
  /// this method.
  static TokenManager get tokenManager => AuthConfig.instance.tokenManager;

  /// Looks up the `AuthenticationInfo` belonging to the [key].
  ///
  /// First tries to resolve the key as a SAS key, and then as a JWT. This
  /// operation is easy on resources, as it will only call the database if the
  /// key looks like a SAS key. Otherwise, it will eagerly return null and try
  /// to resolve the key as a JWT. In case the key can not be parsed as either
  /// a SAS key or a JWT, it will return null.
  static Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String key,
  ) async {
    final authInfo = await tokenManager.validateToken(session, key);
    if (authInfo != null) return authInfo;
    return await AuthenticationTokens.authenticationHandler(session, key);
  }
}

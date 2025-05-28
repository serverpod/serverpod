import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';

/// Collection of admin functions for managing authentication tokens.
@internal
final class AuthenticationTokensAdmin {
  @internal
  AuthenticationTokensAdmin();

  /// Removes all expired refresh tokens from the database.
  static Future<void> deleteExpiredRefreshTokens(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final oldestValidRefreshTokenDate = DateTime.now()
        .subtract(AuthenticationTokens.config.refreshTokenLifetime);

    await RefreshToken.db.deleteWhere(
      session,
      where: (final t) => t.lastUpdated < oldestValidRefreshTokenDate,
      transaction: transaction,
    );
  }
}

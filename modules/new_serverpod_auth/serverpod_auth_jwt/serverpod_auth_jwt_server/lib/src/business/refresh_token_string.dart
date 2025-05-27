import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';

@internal
abstract final class RefreshTokenString {
  /// Prefix for refresh tokens
  /// "sajrt" being an abbreviation of "serverpod_auth_jwt RefrestToken"
  static const _refreshTokenPrefix = 'sajrt';

  /// Returns the external refresh token string
  static String buildRefreshTokenString({
    required final RefreshToken refreshToken,
    required final String secret,
  }) {
    return '$_refreshTokenPrefix:${base64Encode(refreshToken.id!.toBytes())}:${refreshToken.fixedSecret}:$secret';
  }

  static ({
    UuidValue id,
    String fixedSecret,
    String variableSecret,
  }) parseRefreshTokenString(
    final String refreshToken,
  ) {
    if (!refreshToken.startsWith('$_refreshTokenPrefix:')) {
      throw ArgumentError.value(
        refreshToken,
        'refreshToken',
        'Refresh token does not start with "$_refreshTokenPrefix"',
      );
    }

    final parts = refreshToken.split(':');
    if (parts.length != 4) {
      throw ArgumentError.value(
        refreshToken,
        'refreshToken',
        'Refresh token does not consist of 4 parts separated by ":".',
      );
    }

    final refreshTokenId = UuidValue.fromByteList(base64Decode(parts[1]));

    final fixedSecret = parts[2];

    final variableSecret = parts[3];

    return (
      id: refreshTokenId,
      fixedSecret: fixedSecret,
      variableSecret: variableSecret,
    );
  }
}

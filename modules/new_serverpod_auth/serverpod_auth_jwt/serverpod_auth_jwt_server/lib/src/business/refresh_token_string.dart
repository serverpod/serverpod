import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';

@internal
abstract final class RefreshTokenString {
  /// Prefix for refresh tokens
  /// "sajrt" being an abbreviation of "serverpod_auth_jwt Refresh Token"
  static const _refreshTokenPrefix = 'sajrt';

  /// Returns the external refresh token string
  static String buildRefreshTokenString({
    required final RefreshToken refreshToken,
    required final Uint8List rotatingSecret,
  }) {
    return '$_refreshTokenPrefix:${base64Encode(refreshToken.id!.toBytes())}:${base64Encode(Uint8List.sublistView(refreshToken.fixedSecret))}:${base64Encode(rotatingSecret)}';
  }

  static RefreshTokenStringData parseRefreshTokenString(
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

    final fixedSecret = base64Decode(parts[2]);

    final rotatingSecret = base64Decode(parts[3]);

    return (
      id: refreshTokenId,
      fixedSecret: fixedSecret,
      rotatingSecret: rotatingSecret,
    );
  }
}

/// The data obtained from reading in a refresh token string.
typedef RefreshTokenStringData = ({
  UuidValue id,
  Uint8List fixedSecret,
  Uint8List rotatingSecret,
});

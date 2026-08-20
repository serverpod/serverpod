import 'package:serverpod/serverpod.dart';

import '../business/refresh_token_string.dart';
import '../jwt.dart';

/// JWT refresh token ID extension for [AuthSuccess].
extension AuthSuccessJwtRefreshTokenId on AuthSuccess {
  /// Returns the JWT refresh token ID from the [AuthSuccess.refreshToken].
  UuidValue get jwtRefreshTokenId {
    final refreshToken = this.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const FormatException(
        'Cannot parse JWT refresh token ID from an empty '
        '`AuthSuccess.refreshToken`. In cookie-mode sign-in the JWT refresh '
        'token is carried in an HttpOnly cookie instead of the response body.',
      );
    }

    try {
      return RefreshTokenString.parseRefreshTokenString(refreshToken).id;
    } catch (e) {
      throw const FormatException(
        'Failed to parse JWT refresh token ID from `AuthSuccess.refreshToken`.',
      );
    }
  }
}

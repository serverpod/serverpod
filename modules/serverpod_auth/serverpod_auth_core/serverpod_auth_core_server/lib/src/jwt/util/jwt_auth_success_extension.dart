import 'package:serverpod/serverpod.dart';

import '../business/refresh_token_string.dart';
import '../jwt.dart';

/// JWT refresh token ID extension for [AuthSuccess].
extension AuthSuccessJwtRefreshTokenId on AuthSuccess {
  /// Returns the JWT refresh token ID from the [AuthSuccess.refreshToken].
  UuidValue get jwtRefreshTokenId {
    try {
      return RefreshTokenString.parseRefreshTokenString(refreshToken!).id;
    } catch (e) {
      throw const FormatException(
        'Failed to parse JWT refresh token ID from `AuthSuccess.refreshToken`.',
      );
    }
  }
}

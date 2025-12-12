import 'package:uuid/uuid_value.dart';

/// Exception thrown when a refresh token is malformed.
final class RefreshTokenMalformedServerException
    extends RefreshTokenServerException {
  /// Creates a new [RefreshTokenMalformedServerException].
  RefreshTokenMalformedServerException();
}

/// Exception thrown when a refresh token is not found.
final class RefreshTokenNotFoundServerException
    extends RefreshTokenServerException {
  /// Creates a new [RefreshTokenNotFoundServerException].
  RefreshTokenNotFoundServerException();
}

/// Exception thrown when a refresh token has expired.
final class RefreshTokenExpiredServerException
    extends RefreshTokenServerException {
  /// Creates a new [RefreshTokenExpiredServerException].
  RefreshTokenExpiredServerException({
    required this.authUserId,
    required this.refreshTokenId,
  });

  /// The ID of the auth user that the refresh token belongs to.
  final UuidValue authUserId;

  /// The ID of the refresh token that has expired.
  final UuidValue refreshTokenId;
}

/// Exception thrown when a refresh token has an invalid secret.
final class RefreshTokenInvalidSecretServerException
    extends RefreshTokenServerException {
  /// Creates a new [RefreshTokenInvalidSecretServerException].
  RefreshTokenInvalidSecretServerException({
    required this.authUserId,
    required this.refreshTokenId,
  });

  /// The ID of the auth user that the refresh token belongs to.
  final UuidValue authUserId;

  /// The ID of the refresh token that has an invalid secret.
  final UuidValue refreshTokenId;
}

/// Base exception for all refresh token related errors.
sealed class RefreshTokenServerException implements Exception {}

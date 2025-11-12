import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

/// Exception for user-facing error messages that should be displayed to the user.
///
/// This exception is used to wrap server exceptions and convert them to
/// user-friendly messages that can be safely shown in the UI.
class UserFacingException implements Exception {
  /// The user-friendly error message.
  final String message;

  /// The original exception that caused this user-facing exception.
  final Object? originalException;

  /// Creates a new [UserFacingException].
  const UserFacingException(this.message, {required this.originalException});

  @override
  String toString() => message;

  /// Converts a [ServerpodClientException] to a [UserFacingException].
  static UserFacingException fromServerpodClientException(
    ServerpodClientException error,
  ) {
    switch (error) {
      case ServerpodClientInternalServerError():
      case ServerpodClientBadRequest():
      case ServerpodClientUnauthorized():
      case ServerpodClientForbidden():
      case ServerpodClientNotFound():
        return UserFacingException(
          'An error occurred while processing your request. Please try again '
          'later. If the problem persists, please contact support.',
          originalException: error,
        );
      default:
        return UserFacingException(
          'A connection error occurred. Please check your internet connection '
          'and try again.',
          originalException: error,
        );
    }
  }
}

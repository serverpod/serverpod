import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/exceptions.dart';
import 'email_auth_controller.dart';

/// Converts server exceptions to user-friendly error messages.
///
/// Returns a user-friendly exception or message for exceptions that should be
/// shown to the user. Returns `null` for internal errors that shouldn't be
/// exposed to users (e.g., StateError, internal server errors, network errors).
Exception? convertToUserFacingException(Object error) {
  if (error is UserFacingException) return error;
  if (error is InvalidEmailException) return error;

  if (error is EmailAccountLoginException) {
    return switch (error.reason) {
      EmailAccountLoginExceptionReason.invalidCredentials =>
        UserFacingException(
          'Invalid email or password. Please check your credentials and try '
          'again.',
          originalException: error,
        ),
      EmailAccountLoginExceptionReason.tooManyAttempts => UserFacingException(
        'Too many failed login attempts. Please try again later.',
        originalException: error,
      ),
      EmailAccountLoginExceptionReason.unknown => UserFacingException(
        'An error occurred during login. Please try again.',
        originalException: error,
      ),
    };
  }

  if (error is EmailAccountRequestException) {
    return switch (error.reason) {
      EmailAccountRequestExceptionReason.tooManyAttempts => UserFacingException(
        'Too many failed registration attempts. Please try again later.',
        originalException: error,
      ),
      EmailAccountRequestExceptionReason.expired => UserFacingException(
        'The verification code has expired. Please request a new one.',
        originalException: error,
      ),
      EmailAccountRequestExceptionReason.invalid => UserFacingException(
        'Invalid verification code. Please check and try again.',
        originalException: error,
      ),
      EmailAccountRequestExceptionReason.policyViolation => UserFacingException(
        'The password does not meet the requirements. Please choose a '
        'different password.',
        originalException: error,
      ),
      EmailAccountRequestExceptionReason.unknown => UserFacingException(
        'An error occurred during registration. Please try again later. '
        'If the problem persists, please contact support.',
        originalException: error,
      ),
    };
  }

  if (error is EmailAccountPasswordResetException) {
    return switch (error.reason) {
      EmailAccountPasswordResetExceptionReason.tooManyAttempts =>
        UserFacingException(
          'Too many failed password reset attempts. Please try again later.',
          originalException: error,
        ),
      EmailAccountPasswordResetExceptionReason.expired => UserFacingException(
        'The password reset code has expired. Please request a new one.',
        originalException: error,
      ),
      EmailAccountPasswordResetExceptionReason.invalid => UserFacingException(
        'Invalid verification code. Please check and try again.',
        originalException: error,
      ),
      EmailAccountPasswordResetExceptionReason.policyViolation =>
        UserFacingException(
          'The password does not meet the requirements. Please choose a '
          'different password.',
          originalException: error,
        ),
      EmailAccountPasswordResetExceptionReason.unknown => UserFacingException(
        'An error occurred during password reset. Please try again later. '
        'If the problem persists, please contact support.',
        originalException: error,
      ),
    };
  }

  if (error is ServerpodClientException) {
    return UserFacingException.fromServerpodClientException(error);
  }

  return null;
}

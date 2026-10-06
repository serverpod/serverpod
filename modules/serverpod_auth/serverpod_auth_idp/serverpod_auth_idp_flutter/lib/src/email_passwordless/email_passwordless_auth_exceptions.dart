import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/exceptions.dart';
import '../email/email_auth_controller.dart';

/// Converts server exceptions of the passwordless email flow to user-friendly
/// error messages.
///
/// Returns `null` for internal errors that should not be exposed to users, such
/// as [StateError]s.
Exception? convertPasswordlessToUserFacingException(Object error) {
  if (error is UserFacingException) return error;
  if (error is InvalidEmailException) return error;

  if (error is EmailPasswordlessLoginException) {
    return switch (error.reason) {
      EmailPasswordlessLoginExceptionReason.invalidEmail => UserFacingException(
        'Invalid email address.',
        originalException: error,
      ),
      EmailPasswordlessLoginExceptionReason.rateLimited => UserFacingException(
        'Too many codes have been requested. Please try again later.',
        originalException: error,
      ),
      EmailPasswordlessLoginExceptionReason.tooManyAttempts =>
        UserFacingException(
          'Too many failed attempts. Please request a new code.',
          originalException: error,
        ),
      EmailPasswordlessLoginExceptionReason.expired => UserFacingException(
        'The verification code has expired. Please request a new one.',
        originalException: error,
      ),
      EmailPasswordlessLoginExceptionReason.invalid => UserFacingException(
        'Invalid verification code. Please check and try again, or request a '
        'new code.',
        originalException: error,
      ),
      EmailPasswordlessLoginExceptionReason.unknown => UserFacingException(
        'An error occurred during login. Please try again.',
        originalException: error,
      ),
    };
  }

  if (error is ServerpodClientException) {
    return UserFacingException.fromServerpodClientException(error);
  }

  return null;
}

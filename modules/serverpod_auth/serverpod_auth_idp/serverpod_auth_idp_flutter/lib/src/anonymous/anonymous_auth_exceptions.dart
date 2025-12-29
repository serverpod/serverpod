import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/exceptions.dart';

/// Converts server exceptions to user-friendly error messages for
/// anonymous authentication.
///
/// Returns a user-friendly exception or message for exceptions that should be
/// shown to the user. Returns `null` for internal errors that shouldn't be
/// exposed to users (e.g., StateError, internal server errors, network errors).
Exception? convertToUserFacingException(Object error) {
  if (error is UserFacingException) return error;

  if (error is AnonymousAccountBlockedException) {
    return switch (error.reason) {
      AnonymousAccountBlockedExceptionReason.denied => UserFacingException(
        'Anonymous sign-in is not allowed at this time.',
        originalException: error,
      ),
      AnonymousAccountBlockedExceptionReason.throttled => UserFacingException(
        'Too many sign-in attempts. Please try again later.',
        originalException: error,
      ),
    };
  }

  if (error is ServerpodClientException) {
    return UserFacingException.fromServerpodClientException(error);
  }

  return null;
}

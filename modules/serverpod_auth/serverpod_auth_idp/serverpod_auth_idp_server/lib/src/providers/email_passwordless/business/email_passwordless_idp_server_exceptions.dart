/// Base exception for all passwordless email login related errors.
///
/// These exceptions are for internal purposes only and must not be exposed to
/// clients. For such, see `EmailPasswordlessLoginException`.
sealed class EmailPasswordlessLoginServerException implements Exception {}

/// Exception thrown when the email address fails email validation.
final class EmailPasswordlessInvalidEmailException
    extends EmailPasswordlessLoginServerException {}

/// Exception thrown when too many login requests have been made for the same
/// email address.
final class EmailPasswordlessLoginRequestRateLimitedException
    extends EmailPasswordlessLoginServerException {}

/// Exception thrown when a login request was made for the email address less
/// than the resend cooldown ago.
///
/// It is thrown the same way for every email address, whether it is known or
/// not, and whether it has a pending request or the request was created by a
/// concurrent call.
final class EmailPasswordlessResendCooldownException
    extends EmailPasswordlessLoginServerException {}

/// Exception thrown when trying to finish a login request that does not exist
/// or that has already been used.
final class EmailPasswordlessLoginRequestNotFoundException
    extends EmailPasswordlessLoginServerException {}

/// Exception thrown when trying to finish a login request with a wrong
/// verification code.
final class EmailPasswordlessInvalidVerificationCodeException
    extends EmailPasswordlessLoginServerException {}

/// Exception thrown when trying to finish a login request with the correct
/// verification code after the request has expired.
///
/// Must be thrown only if the code is correct to avoid leaking that the
/// request exists.
final class EmailPasswordlessLoginRequestExpiredException
    extends EmailPasswordlessLoginServerException {}

/// Exception thrown when too many verification attempts have been made for a
/// login request or an email address.
final class EmailPasswordlessTooManyVerificationAttemptsException
    extends EmailPasswordlessLoginServerException {}

/// Exception thrown when the verification code was correct, but no account
/// exists for the email address and creating one is not allowed.
final class EmailPasswordlessSignUpNotAllowedException
    extends EmailPasswordlessLoginServerException {}

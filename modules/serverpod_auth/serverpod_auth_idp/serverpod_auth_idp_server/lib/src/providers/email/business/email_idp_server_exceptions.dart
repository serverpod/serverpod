/// Exception thrown for operations on an email address that is not registered.
final class EmailAccountNotFoundException extends EmailLoginServerException {}

/// Exception thrown when trying to verify an email account with an invalid
/// verification code.
final class EmailAccountRequestInvalidVerificationCodeException
    extends EmailAccountRequestServerException {}

/// Exception thrown when trying to complete inexistent email account requests.
final class EmailAccountRequestNotFoundException
    extends EmailAccountRequestServerException {}

/// Exception thrown when trying to verify an email account request with a
/// verification code that has already been used.
final class EmailAccountRequestVerificationCodeAlreadyUsedException
    extends EmailAccountRequestServerException {}

/// Exception thrown when trying to complete a non-verified account request.
final class EmailAccountRequestNotVerifiedException
    extends EmailAccountRequestServerException {}

/// Base exception for all account request related errors.
sealed class EmailAccountRequestServerException extends EmailServerException {}

/// Exception thrown when trying to complete an email request that is expired.
///
/// Must be thrown only if the verification is correct to avoid leaking that the
/// request exists.
final class EmailAccountRequestVerificationExpiredException
    extends EmailAccountRequestServerException {}

/// Exception thrown when trying to verify an email account too many times.
final class EmailAccountRequestVerificationTooManyAttemptsException
    extends EmailAccountRequestServerException {}

/// Exception thrown for login attempts with invalid credentials.
final class EmailAuthenticationInvalidCredentialsException
    extends EmailLoginServerException {}

/// Exception thrown for too many login attempts.
final class EmailAuthenticationTooManyAttemptsException
    extends EmailLoginServerException {}

/// Base exception for all login related errors.
sealed class EmailLoginServerException extends EmailServerException {}

/// Exception thrown for operations that violate password policies.
final class EmailPasswordPolicyViolationException
    extends EmailAccountRequestServerException {}

/// Exception thrown when an email address is already registered.
final class EmailAccountAlreadyRegisteredException
    extends EmailAccountRequestServerException {}

/// Exception thrown when email address fails email validation.
final class EmailAccountRequestInvalidEmailException
    extends EmailAccountRequestServerException {}

/// Exception thrown when trying to complete a password reset request with an
/// invalid verification code.
final class EmailPasswordResetInvalidVerificationCodeException
    extends EmailPasswordResetServerException {}

/// Exception thrown when trying to complete a password reset request with a
/// password that violates the password policy.
final class EmailPasswordResetPasswordPolicyViolationException
    extends EmailPasswordResetServerException {}

/// Exception thrown when trying to complete an expired password reset request.
final class EmailPasswordResetRequestExpiredException
    extends EmailPasswordResetServerException {}

/// Exception thrown when trying to complete an inexistent password reset request.
final class EmailPasswordResetRequestNotFoundException
    extends EmailPasswordResetServerException {}

/// Base exception for all password reset related errors.
sealed class EmailPasswordResetServerException extends EmailServerException {}

/// Exception thrown when trying to request a password reset too many times.
final class EmailPasswordResetTooManyAttemptsException
    extends EmailPasswordResetServerException {}

/// Exception thrown when trying to request a password reset for an inexistent email account.
final class EmailPasswordResetEmailNotFoundException
    extends EmailPasswordResetServerException {}

/// Exception thrown when trying to complete the password reset request too
/// many times.
final class EmailPasswordResetTooManyVerificationAttemptsException
    extends EmailPasswordResetServerException {}

/// Exception thrown when trying to validate a password reset verification code that has already been used.
final class EmailPasswordResetVerificationCodeAlreadyUsedException
    extends EmailPasswordResetServerException {}

/// Exception thrown when trying to validate a password reset request with a
/// set password token that has not been set.
final class EmailPasswordResetNotVerifiedException
    extends EmailPasswordResetServerException {}

/// Base exception for all email related errors.
///
/// These exceptions are for internal purposes only and must not be exposed to
/// clients. For such, see the adequate serializable exceptions.
sealed class EmailServerException implements Exception {}

/// Base exception for all passwordless login related errors.
sealed class EmailPasswordlessLoginServerException
    extends EmailServerException {}

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

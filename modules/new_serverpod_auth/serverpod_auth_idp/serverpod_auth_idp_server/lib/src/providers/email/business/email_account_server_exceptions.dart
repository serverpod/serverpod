/// Base exception for all email related errors.
///
/// These exceptions are for internal purposes only and must not be exposed to
/// clients. For such, see the adequate serializable exceptions.
sealed class EmailServerException implements Exception {}

/// Exception thrown for operations on an email address that is not registered.
class EmailAccountNotFoundException extends EmailServerException {}

/// Exception thrown for login attempts with invalid credentials.
class EmailAuthenticationInvalidCredentialsException
    extends EmailServerException {}

/// Exception thrown for too many login attempts.
class EmailAuthenticationTooManyAttemptsException
    extends EmailServerException {}

/// Exception thrown for operations that violate password policies.
class EmailPasswordPolicyViolationException extends EmailServerException {}

/// Exception thrown when trying to complete inexistent email account requests.
class EmailAccountRequestNotFoundException extends EmailServerException {}

/// Exception thrown when trying to complete an email request that is expired.
///
/// Must be thrown only if the verification is correct to avoid leaking that the
/// request exists.
class EmailAccountRequestVerificationExpiredException
    extends EmailServerException {}

/// Exception thrown when trying to verify an email account too many times.
class EmailAccountRequestVerificationTooManyAttemptsException
    extends EmailServerException {}

/// Exception thrown when trying to verify an email account with an invalid
/// verification code.
class EmailAccountRequestInvalidVerificationCodeException
    extends EmailServerException {}

/// Exception thrown when trying to complete a non-verified account request.
class EmailAccountRequestNotVerifiedException extends EmailServerException {}

/// Exception thrown when trying to request a password reset too many times.
class EmailPasswordResetTooManyAttemptsException extends EmailServerException {}

/// Exception thrown when requesting password reset for an inexistent account.
class EmailPasswordResetAccountNotFoundException extends EmailServerException {}

/// Exception thrown when trying to complete an inexistent password reset request.
class EmailPasswordResetRequestNotFoundException extends EmailServerException {}

/// Exception thrown when trying to complete an expired password reset request.
class EmailPasswordResetRequestExpiredException extends EmailServerException {}

/// Exception thrown when trying to complete a password reset request with a
/// password that violates the password policy.
class EmailPasswordResetPasswordPolicyViolationException
    extends EmailServerException {}

/// Exception thrown when trying to complete the password reset request too
/// many times.
class EmailPasswordResetTooManyVerificationAttemptsException
    extends EmailServerException {}

/// Exception thrown when trying to complete a password reset request with an
/// invalid verification code.
class EmailPasswordResetInvalidVerificationCodeException
    extends EmailServerException {}

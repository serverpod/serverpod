/// Base exception for all SMS authentication related errors.
sealed class SmsServerException implements Exception {}

/// Base exception for all SMS account request related errors.
sealed class SmsAccountRequestServerException extends SmsServerException {}

/// Base exception for all SMS login related errors.
sealed class SmsLoginServerException extends SmsServerException {}

/// Base exception for all SMS phone bind related errors.
sealed class SmsPhoneBindServerException extends SmsServerException {}

/// Exception thrown when an account is already registered with the phone number.
final class SmsAccountAlreadyRegisteredException
    extends SmsAccountRequestServerException {}

/// Exception thrown when trying to verify with an invalid code.
final class SmsAccountRequestInvalidVerificationCodeException
    extends SmsAccountRequestServerException {}

/// Exception thrown when the account request is not found.
final class SmsAccountRequestNotFoundException
    extends SmsAccountRequestServerException {}

/// Exception thrown when the verification code has already been used.
final class SmsAccountRequestVerificationCodeAlreadyUsedException
    extends SmsAccountRequestServerException {}

/// Exception thrown when trying to complete a non-verified request.
final class SmsAccountRequestNotVerifiedException
    extends SmsAccountRequestServerException {}

/// Exception thrown when the account request has expired.
final class SmsAccountRequestVerificationExpiredException
    extends SmsAccountRequestServerException {}

/// Exception thrown when there are too many verification attempts.
final class SmsAccountRequestVerificationTooManyAttemptsException
    extends SmsAccountRequestServerException {}

/// Exception thrown when the password does not meet the policy requirements.
final class SmsPasswordPolicyViolationException
    extends SmsAccountRequestServerException {}

/// Exception thrown when login credentials are invalid.
final class SmsLoginInvalidCredentialsException
    extends SmsLoginServerException {}

/// Exception thrown when there are too many login attempts.
final class SmsLoginTooManyAttemptsException extends SmsLoginServerException {}

/// Exception thrown when the login request has expired.
final class SmsLoginExpiredException extends SmsLoginServerException {}

/// Exception thrown when the login request is not found.
final class SmsLoginNotFoundException extends SmsLoginServerException {}

/// Exception thrown when a password is required for login.
final class SmsLoginPasswordRequiredException extends SmsLoginServerException {}

/// Exception thrown when the password does not meet the policy requirements during login.
final class SmsLoginPasswordPolicyViolationException
    extends SmsLoginServerException {}

/// Exception thrown when phone bind credentials are invalid.
final class SmsPhoneBindInvalidException extends SmsPhoneBindServerException {}

/// Exception thrown when there are too many phone bind attempts.
final class SmsPhoneBindTooManyAttemptsException
    extends SmsPhoneBindServerException {}

/// Exception thrown when the phone bind request has expired.
final class SmsPhoneBindExpiredException extends SmsPhoneBindServerException {}

/// Exception thrown when the phone is already bound to another user.
final class SmsPhoneAlreadyBoundException extends SmsPhoneBindServerException {}

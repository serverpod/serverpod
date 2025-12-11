/// Base exception for all secret challenge related errors.
///
/// These exceptions are generic and intended to be caught and mapped to
/// more specific exceptions at the provider level (e.g., email, SMS).
sealed class SecretChallengeException implements Exception {}

/// Exception thrown when the operation request is not found.
final class ChallengeRequestNotFoundException
    extends SecretChallengeException {}

/// Exception thrown when the challenge has already been used/verified.
final class ChallengeAlreadyUsedException extends SecretChallengeException {}

/// Exception thrown when the verification code is invalid.
final class ChallengeInvalidVerificationCodeException
    extends SecretChallengeException {}

/// Exception thrown when the challenge has expired.
///
/// This should only be thrown after the verification code has been validated
/// to avoid leaking information about the challenge existence.
final class ChallengeExpiredException extends SecretChallengeException {}

/// Exception thrown when the request has not been verified yet.
///
/// This is expected if trying to complete a request that has no completion
/// challenge linked.
final class ChallengeNotVerifiedException extends SecretChallengeException {}

/// Exception thrown when the completion token is malformed or invalid.
final class ChallengeInvalidCompletionTokenException
    extends SecretChallengeException {}

/// Exception thrown when the rate limit is exceeded.
final class ChallengeRateLimitExceededException
    extends SecretChallengeException {}

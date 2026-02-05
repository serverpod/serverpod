/// Base exception for all passwordless authentication related errors.
sealed class PasswordlessServerException implements Exception {}

/// Base exception for all passwordless login related errors.
sealed class PasswordlessLoginServerException
    extends PasswordlessServerException {}

/// Exception thrown when login credentials are invalid.
final class PasswordlessLoginInvalidException
    extends PasswordlessLoginServerException {}

/// Exception thrown when there are too many login attempts.
final class PasswordlessLoginTooManyAttemptsException
    extends PasswordlessLoginServerException {}

/// Exception thrown when the login request has expired.
final class PasswordlessLoginExpiredException
    extends PasswordlessLoginServerException {}

/// Exception thrown when the login request is not found.
final class PasswordlessLoginNotFoundException
    extends PasswordlessLoginServerException {}

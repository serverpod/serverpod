/// Base class for errors that occur during password hash validation.
class PasswordHashValidatorException implements Exception {
  /// Creates a new [PasswordHashValidatorException].
  ///
  /// [errorMessage] is a human-readable message or an error object describing
  /// the failure. [stackTrace] is the optional stack trace captured when the
  /// error was created.
  PasswordHashValidatorException({this.errorMessage, this.stackTrace});

  /// A human-readable message or error object that describes the failure.
  final Object? errorMessage;

  /// Optional stack trace associated with this exception.
  final StackTrace? stackTrace;
}

/// Thrown when validation of a computed password hash against a stored hash fails.
class PasswordHashValidationFailedException
    extends PasswordHashValidatorException {
  /// Creates a [PasswordHashValidationFailedException].
  ///
  /// [passwordHash] is the computed hash of the provided password.
  /// [storedHash] is the persisted hash being compared against.
  PasswordHashValidationFailedException({
    required this.passwordHash,
    required this.storedHash,
  });

  /// The computed hash of the candidate password.
  final String passwordHash;

  /// The stored hash retrieved from persistence for comparison.
  final String storedHash;
}

/// Base class for all password missing exceptions.
abstract class PasswordMissingException implements Exception {
  /// The name of the password that is missing.
  final String passwordName;

  /// The name of the environment variable that is missing.
  final String envVarName;

  /// Creates a new instance of [PasswordMissingException].
  PasswordMissingException(this.passwordName, this.envVarName);

  /// The user-friendly message of the exception.
  String get message => 'Missing password for "$passwordName". '
      'Please check your config/passwords.yaml file or the '
      '$envVarName environment variable.';

  @override
  String toString() => '$runtimeType: The password "$passwordName" or '
      'the environment variable "$envVarName" is missing.';
}

/// Exception thrown when a database password is missing from the configuration
/// or the environment variable.
final class DatabasePasswordMissingException extends PasswordMissingException {
  /// Creates a new instance of [DatabasePasswordMissingException].
  DatabasePasswordMissingException(super.passwordName, super.envVarName);
}

/// Exception thrown when a Redis password is missing from the configuration
/// or the environment variable.
final class RedisPasswordMissingException extends PasswordMissingException {
  /// Creates a new instance of [RedisPasswordMissingException].
  RedisPasswordMissingException(super.passwordName, super.envVarName);
}

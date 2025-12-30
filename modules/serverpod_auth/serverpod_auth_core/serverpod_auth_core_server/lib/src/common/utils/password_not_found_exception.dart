/// Thrown when a requested password is missing from configuration.
final class PasswordNotFoundException implements Exception {
  /// The password identifier that could not be found.
  final String key;

  /// Creates an exception indicating the missing password [key].
  PasswordNotFoundException(this.key);

  /// The name of the environment variable that is missing.
  String get envVarName => 'SERVERPOD_PASSWORD_$key';

  @override
  String toString() {
    return 'PasswordNotFoundException: $key was not found in config/passwords.yaml or the environment variable $envVarName';
  }
}

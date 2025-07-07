/// Exception class for all password missing exceptions.
base class PasswordMissingException implements Exception {
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
  String toString() =>
      'PasswordMissingException: The password "$passwordName" or '
      'the environment variable "$envVarName" is missing.';
}

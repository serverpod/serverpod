import 'package:serverpod_shared/serverpod_shared.dart';

/// Exception class for all password missing exceptions.
base class PasswordMissingException extends ExitException {
  /// The name of the password that is missing.
  final String passwordName;

  /// The name of the environment variable that is missing.
  String get envVarName => 'SERVERPOD_PASSWORD_$passwordName';

  /// Creates a new instance of [PasswordMissingException].
  PasswordMissingException(this.passwordName) : super(1);

  /// The user-friendly message of the exception.
  @override
  String get message =>
      'Missing password for "$passwordName". '
      'Please check your config/passwords.yaml file or the '
      '$envVarName environment variable.\n'
      'See the documentation to troubleshoot: https://docs.serverpod.dev/troubleshoot/missing-passwords';

  @override
  String toString() =>
      'PasswordMissingException: The password "$passwordName" or '
      'the environment variable "$envVarName" is missing.';
}

enum ExitCodeType {
  /// General errors - This code is often used to indicate generic or
  /// unspecified errors.
  general(1),

  /// Command invoked cannot execute - The specified command was found but
  /// couldn't be executed.
  commandInvokedCannotExecute(126),

  /// Command not found - The specified command was not found or couldn't be
  /// located.
  commandNotFound(127);

  const ExitCodeType(this.exitCode);
  final int exitCode;
}

class ExitException implements Exception {
  ExitException([this.exitCodeType = ExitCodeType.general]);

  final ExitCodeType exitCodeType;

  int get exitCode => exitCodeType.exitCode;
}

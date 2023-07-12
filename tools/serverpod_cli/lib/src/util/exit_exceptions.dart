/// General errors - This code is often used to indicate generic or
/// unspecified errors.
/// Exit code 1.
class GeneralErrorExit implements Exception {
  static const int exitCode = 1;
}

/// Command invoked cannot execute - The specified command was found but
/// couldn't be executed.
/// Exit code 126.
class CommandInvokedCannotExecuteExit implements Exception {
  static const int exitCode = 126;
}

/// Command not found - The specified command was not found or couldn't be
/// located.
/// Exit code 126.
class CommandNotFoundExit implements Exception {
  static const int exitCode = 127;
}

/// Exception used to signal a non-recoverable error that should exit the
/// application.
class ExitException implements Exception {
  /// Creates an instance of [ExitException].
  ExitException(this.exitCode, [this.message = '']);

  /// The error message
  final String message;

  /// The exit code
  final int exitCode;
}

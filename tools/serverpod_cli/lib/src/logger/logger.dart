/// Serverpods internal logger interface.
/// All logging output should go through this interface.
/// The purpose is to simplify implementing and switching out concrete logger
/// implementations.
abstract class Logger {
  /// Display a [message] wrapped in a box.
  /// Commands should use this when they want to highlight a message that otherwise is easily missed.
  void printBox(String message);

  /// Display debug information to the user.
  /// Commands should use this for information that can is important for
  /// debugging.
  void printDebug(String message);

  /// Display an error [message] to the user.
  /// Commands should use this if they want to inform a user that an error
  /// has occurred.
  void printError(String message, {StackTrace? stackTrace});

  /// Display normal information to the user.
  /// Command should use this whenever they want to communicate normal output
  /// such as success or progress messages.
  void printInfo(String message);

  /// Display a warning to the user.
  /// Commands should use this if they have important but not critical
  /// information for the user.
  void printWarning(String message);

  /// Returns a [Future] that completes once all logging is complete.
  Future<void> flush();
}

/// Singleton accessor for the logger.
late final Logger logger;

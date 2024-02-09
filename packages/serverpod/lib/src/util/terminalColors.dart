/// Provides utility functions for working with colors in the terminal
class TerminalColors {
  /// Reset color code
  static String resetColor = '\e[0m';

  /// Matching logLevel string with escape color code
  static const matcher = {
    'FATAL': '\e[0;31m',
    'ERROR': '\e[1;31m',
    'WARNING': '\e[1;33m',
    'INFO': '\e[1;34m',
    'DEBUG': '\e[1;30m',
  };

  /// Adds a color to a text based on the logLevel sting.
  static String colorize(String text, String level) {
    String? color = matcher[level];
    if (color == null) return text;
    return color + text + resetColor;
  }
}

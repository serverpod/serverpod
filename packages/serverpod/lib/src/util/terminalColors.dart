/// Provides utility functions for working with colors in the terminal
class TerminalColors {
  /// Reset color code
  static String resetColor = '\e[0m';

  /// Matching logLevel string with escape color code
  static const matcher = {
    'fatal': '\e[0;31m',
    'error': '\e[1;31m',
    'warning': '\e[1;33m',
    'info': '\e[1;34m',
    'debug': '\e[1;30m',
  };

  /// Adds a color to a text based on the logLevel sting.
  static String colorize(String text, String level) {
    String? color = matcher[level];
    if (color == null) return text;
    return color + text + resetColor;
  }
}

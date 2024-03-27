/// Provides utility functions for working with colors in the terminal
// ignore_for_file: unnecessary_string_escapes
class TerminalColors {
  /// Reset color code
  static String resetColor = '\e[0m';

  /// Matching logLevel string with escape color code
  static const matcher = {
    //logLevels
    'fatal': '\e[0;31m', //red
    'error': '\e[1;31m', //light red
    'warning': '\e[1;33m', //yellow
    'info': '\e[1;34m', //light blue
    'debug': '\e[1;30m', //gray

    //log_manager - magic logLevels
    'method': '\e[0;32m', //green
    'future': '\e[0;35m', //purple
  };

  /// Adds a color to a text based on the logLevel sting.
  static String colorize(String text, String level) {
    String? color = matcher[level];
    if (color == null) return text;
    return color + text + resetColor;
  }
}

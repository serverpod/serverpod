import 'dart:io';

/// Class that will log messages to the console
///
/// Output is only written if [_enabled] is true
class ConsoleLogger {
  final bool _enabled;

  /// ConsoleLogger is either enabled or disabled
  ConsoleLogger(this._enabled);

  /// Log output to the console.
  ///
  /// Nothing is written if [_enabled] is false
  void logVerbose(String message) {
    if (_enabled) {
      stdout.writeln(message);
    }
  }
}

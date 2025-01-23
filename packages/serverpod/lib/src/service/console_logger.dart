import 'dart:io';

/// Class that will log messages to the console
///
/// Output is only written if [_enabled] is true
/// This is a placeholder replacement for Serverpod.logVerbose.
/// It is expected that revisions to the logging system will replace
/// this at some point in the future, but this allows us to, for now,
/// replace 2-way dependencies involving Serverpod
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

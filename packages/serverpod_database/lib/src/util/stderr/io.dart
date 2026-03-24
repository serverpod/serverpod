import 'dart:io' show stderr;

/// Writes a message to stderr.
///
/// Used for diagnostic output that should not be mixed with normal program
/// output.
void writeError(String message) {
  stderr.writeln(message);
}

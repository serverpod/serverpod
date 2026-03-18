/// Writes a message to stderr.
///
/// On web, stderr is not available, so this falls back to [print].
void writeError(String message) {
  // ignore: avoid_print
  print(message);
}

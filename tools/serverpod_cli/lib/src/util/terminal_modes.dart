import 'dart:io';

/// Whether this process can host a terminal UI.
///
/// `stdin.hasTerminal` is not enough, since Dart counts `/dev/null` as one.
bool get terminalSupportsTui =>
    stdinSupportsTerminalModes && stdout.hasTerminal;

/// Whether stdin can report the terminal modes a TUI has to capture.
bool get stdinSupportsTerminalModes {
  try {
    stdin.echoMode;
    return true;
  } catch (_) {
    return false;
  }
}

import 'dart:io';

/// Whether this process can host a terminal UI: stdout is a terminal and
/// stdin can report the modes the UI captures.
///
/// `stdin.hasTerminal` does not answer the second: Dart reports every
/// character device as a terminal, so `< /dev/null` passes that check and
/// then throws anyway. Reading the mode is the only reliable probe.
bool get terminalSupportsTui =>
    stdinSupportsTerminalModes && stdout.hasTerminal;

/// Whether stdin can report the terminal modes a TUI has to capture.
///
/// Any failure to read them means the TUI cannot start, so this deliberately
/// treats every error as "unsupported".
bool get stdinSupportsTerminalModes {
  try {
    stdin.echoMode;
    return true;
  } catch (_) {
    return false;
  }
}

import 'dart:io';

import 'package:nocterm/nocterm.dart';

bool _terminalStateCaptured = false;
bool _terminalStateRestored = false;

late bool _originalEchoMode;
late bool _originalLineMode;

void _captureTerminalState() {
  _originalEchoMode = stdin.echoMode;
  _originalLineMode = stdin.lineMode;
  _terminalStateCaptured = true;
  _terminalStateRestored = false;
}

/// Restores stdin terminal modes captured by [runServerpodApp].
///
/// Safe to call multiple times.
void _restoreServerpodTerminal() {
  if (!_terminalStateCaptured || _terminalStateRestored) return;
  // On Windows, ENABLE_ECHO_INPUT requires ENABLE_LINE_INPUT to be set, or
  // SetConsoleMode rejects with ERROR_INVALID_PARAMETER. Restore lineMode
  // first so echoMode is allowed to follow.
  stdin.lineMode = _originalLineMode;
  stdin.echoMode = _originalEchoMode;
  _terminalStateRestored = true;
}

/// Run a TUI app with terminal settings restoration.
///
/// When [onShutdownSignal] is null (the default), SIGINT/SIGTERM trigger an
/// immediate `shutdownServerpodApp()` and the app exits without running any user
/// cleanup.
///
/// When [onShutdownSignal] is provided, signals invoke that callback instead.
/// The caller is then responsible for running cleanup and eventually calling
/// `shutdownServerpodApp(...)` to tear down the nocterm renderer.
///
/// When [routeSigintThroughApp] is true, SIGINT is not handled here. The
/// nocterm backend converts it into a Ctrl-C keyboard event routed through the
/// component tree, letting the app intercept it (e.g. to copy a selection or
/// require a second press before exiting). SIGTERM is still handled here.
Future<void> runServerpodApp(
  Component app, {
  bool enableHotReload = true,
  TerminalBackend? backend,
  void Function()? onShutdownSignal,
  bool routeSigintThroughApp = false,
}) async {
  _captureTerminalState();

  void onShutDownSignalDefault(ProcessSignal _) {
    shutdownServerpodApp();
  }

  void onShutDownSignalDelegated(ProcessSignal _) {
    _restoreServerpodTerminal();
    onShutdownSignal!.call();
  }

  final handler = onShutdownSignal == null
      ? onShutDownSignalDefault
      : onShutDownSignalDelegated;

  if (!routeSigintThroughApp) {
    ProcessSignal.sigint.watch().listen(handler);
  }
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen(handler);
  }

  await runApp(app, enableHotReload: enableHotReload, backend: backend);
}

/// Restores stdin terminal modes captured by [runServerpodApp]
/// then shuts down the nocterm app with proper terminal cleanup.
void shutdownServerpodApp([int exitCode = 0]) {
  _restoreServerpodTerminal();
  shutdownApp(exitCode);
}

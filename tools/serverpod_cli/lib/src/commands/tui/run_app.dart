import 'dart:io';

import 'package:nocterm/nocterm.dart';

/// Run a TUI app with terminal settings restoration.
///
/// When [onShutdownSignal] is null (the default), SIGINT/SIGTERM trigger an
/// immediate `shutdownApp()` and the app exits without running any user
/// cleanup.
///
/// When [onShutdownSignal] is provided, signals invoke that callback instead.
/// The caller is then responsible for running cleanup and eventually calling
/// `shutdownApp(...)` to tear down the nocterm renderer.
Future<void> runServerpodApp(
  Component app, {
  bool enableHotReload = true,
  TerminalBackend? backend,
  void Function()? onShutdownSignal,
}) async {
  final originalEchoMode = stdin.echoMode;
  final originalLineMode = stdin.lineMode;

  void restoreTerminal() {
    stdin.echoMode = originalEchoMode;
    stdin.lineMode = originalLineMode;
  }

  void onShutDownSignalDefault(ProcessSignal _) {
    restoreTerminal();
    shutdownApp();
  }

  void onShutDownSignalDelegated(ProcessSignal _) {
    onShutdownSignal!.call();
  }

  final handler = onShutdownSignal == null
      ? onShutDownSignalDefault
      : onShutDownSignalDelegated;

  ProcessSignal.sigint.watch().listen(handler);
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen(handler);
  }

  try {
    await runApp(app, enableHotReload: enableHotReload, backend: backend);
  } finally {
    restoreTerminal();
  }
}

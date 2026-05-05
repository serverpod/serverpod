import 'dart:io';

import 'package:nocterm/nocterm.dart';

/// Run a TUI app with terminal settings restoration.
Future<void> runServerpodApp(
  Component app, {
  bool enableHotReload = true,
  TerminalBackend? backend,
}) async {
  final originalEchoMode = stdin.echoMode;
  final originalLineMode = stdin.lineMode;

  void restoreTerminal() {
    stdin.echoMode = originalEchoMode;
    stdin.lineMode = originalLineMode;
  }

  void onShutDownSignal(ProcessSignal _) {
    restoreTerminal();
    shutdownApp();
  }

  ProcessSignal.sigint.watch().listen(onShutDownSignal);

  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen(onShutDownSignal);
  }

  try {
    await runApp(app, enableHotReload: enableHotReload, backend: backend);
  } finally {
    restoreTerminal();
  }
}

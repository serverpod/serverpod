import 'package:nocterm/nocterm.dart';

/// A terminal backend for nocterm that allows executing
/// [preExit] callback before exiting the Dart process.
class ServerpodTerminalBackend extends StdioBackend {
  ServerpodTerminalBackend({required this.preExit});

  final Future<void> Function() preExit;

  @override
  void requestExit([int exitCode = 0]) {
    preExit()
        .then((_) => super.requestExit(exitCode))
        .catchError((_) => super.requestExit(exitCode));
  }
}

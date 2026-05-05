import 'package:nocterm/nocterm.dart';

class ServerpodTerminalBackend extends StdioBackend {
  ServerpodTerminalBackend({required this.preExit});

  final Future<void> Function() preExit;

  @override
  void requestExit([int exitCode = 0]) {
    preExit()
        .then((_) {
          super.requestExit(exitCode);
        })
        .catchError((_) {
          super.requestExit(exitCode);
        });
  }
}

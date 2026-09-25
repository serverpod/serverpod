import 'package:serverpod_cli/src/commands/attach.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';

/// Exits through the attach session's backend with the code in `args[0]`.
void main(List<String> args) {
  final history = StartLogHistory()
    ..addServerLine('WARNING: Database does not match target state.');

  attachTerminalBackend(
    history,
    runnerExitCode: () => 1,
    stoppedBeforeStack: () => false,
  ).requestExit(int.parse(args[0]));
}

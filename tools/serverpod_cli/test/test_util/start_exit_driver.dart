import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_shared/log.dart' show LogEntry, LogLevel, LogScope;

/// Exits through the start session's backend with the code in `args[0]`.
/// `args[1]` says whether the stack reached the ready state.
void main(List<String> args) {
  final state = ServerWatchState();
  if (!args.contains('--no-raw-output')) {
    state.rawLines.add('WARNING: Database does not match target state.');
  }

  final error = args.contains('--fatal-error')
      ? StateError('fatal-startup-marker')
      : null;
  final stackTrace = StackTrace.fromString('fatal-stack-marker');
  ({Object error, StackTrace stackTrace, LogEntry entry})? crash;
  if (error != null) {
    state.logHistory.add(
      LogEntry(
        time: DateTime.now(),
        level: LogLevel.info,
        message: 'Checking startup prerequisites.',
        scope: LogScope.root('serverpod'),
      ),
    );
    final crashEntry = LogEntry(
      time: DateTime.now(),
      level: LogLevel.error,
      message: '$error',
      scope: LogScope.root('serverpod'),
      stackTrace: stackTrace,
    );
    crash = (error: error, stackTrace: stackTrace, entry: crashEntry);
    state.logHistory.add(crashEntry);
  }

  if (args.contains('--clear-history')) state.clearLogs();

  startTerminalBackend(
    state,
    stoppedBeforeStack: () => args[1] == 'starting',
    fatalCrash: () => crash,
  ).requestExit(int.parse(args[0]));
}

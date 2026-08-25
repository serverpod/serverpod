import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_cli/src/runner/runner_client.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_shared/log.dart';

/// Streams a runner's output as plain text, for `--no-tui`.
///
/// No alternate screen and no cursor control, one line per entry, so `grep`
/// and a scrollback buffer both work. Carries the same account as the terminal
/// UI, the CLI's own entries and the pod's structured log, in order.
///
/// The exit code is the runner's own when it announces it is stopping, 1 for a
/// stack that cannot be rebuilt or a runner that stopped answering, and 0 on
/// Ctrl+C, which detaches and leaves the runner running.
///
/// [reconnectDeadline] bounds how long a lost runner is waited for. Nobody is
/// watching this, and a runner killed outright announces nothing, so waiting
/// forever would hang the job that ran it.
Future<int> attachWithLogStream(
  String socketPath, {
  IOSink? out,
  Stream<ProcessSignal>? interrupts,
  Duration reconnectDeadline = const Duration(seconds: 10),
}) async {
  final sink = out ?? stdout;
  final client = RunnerClient(
    socketPath: socketPath,
    reconnectDeadline: reconnectDeadline,
  );
  await client.attach();

  final history = client.history;
  for (final entry in history.serverEntries) {
    sink.writeln(formatHistoryEntry(entry));
  }
  for (final app in history.flutterLines.entries) {
    for (final line in app.value) {
      sink.writeln('[${app.key}] $line');
    }
  }
  for (final operation in history.activeOperations.values) {
    sink.writeln('... ${operation.label} (in progress)');
  }
  sink.writeln(_stageLine(client.stage));

  final done = Completer<int>();

  void leaveIfUnrecoverable(RunnerStage stage) {
    if (stage != RunnerStage.degraded || client.watchModeEnabled) return;
    if (done.isCompleted) return;
    sink.writeln(
      '--- nothing will rebuild it from here: the runner is still up, '
      'rebuild it from `serverpod runner attach` once the errors are fixed, '
      'or stop it with `serverpod runner stop` ---',
    );
    done.complete(1);
  }

  leaveIfUnrecoverable(client.stage);

  unawaited(
    client.gone.then((_) {
      if (done.isCompleted) return;
      sink.writeln('--- the runner is gone ---');
      done.complete(1);
    }),
  );

  final signals = interrupts ?? ProcessSignal.sigint.watch();
  final signalSub = signals.listen((_) {
    if (!done.isCompleted) done.complete(0);
  });

  final eventSub = client.events.listen((event) {
    final line = _formatEvent(event);
    if (line != null) sink.writeln(line);
    if (event case StageChangedEvent(:final stage, :final exitCode)) {
      if (stage == RunnerStage.stopping) {
        if (!done.isCompleted) done.complete(exitCode ?? 0);
      } else {
        leaveIfUnrecoverable(stage);
      }
    }
  });

  final connectionSub = client.connectionChanges.listen((connected) {
    sink.writeln(
      connected
          ? '--- reattached to the runner ---'
          : '--- lost the runner, reattaching ---',
    );
  });

  final exitCode = await done.future;
  await signalSub.cancel();
  await eventSub.cancel();
  await connectionSub.cancel();
  await client.close();
  return exitCode;
}

String _stageLine(RunnerStage stage) => switch (stage) {
  RunnerStage.starting => '--- runner starting ---',
  RunnerStage.running => '--- server running ---',
  RunnerStage.degraded =>
    '--- server not running: the project failed to build ---',
  RunnerStage.stopping => '--- runner stopping ---',
};

String? _formatEvent(RunnerEvent event) => switch (event) {
  ServerLogEvent(:final entry) => formatLogEntryLine(entry),
  ServerLineEvent(:final line, :final duplicatesEntry) =>
    duplicatesEntry ? null : line,
  FlutterLineEvent(:final appId, :final line) => '[$appId] $line',
  FlutterLogEntryEvent(:final appId, :final entry) =>
    '[$appId] ${formatLogEntryLine(entry)}',
  OperationStartedEvent(:final operation) => '... ${operation.label}',
  OperationCompletedEvent(:final operation) =>
    '${operation.success ? '✓' : '✗'} ${operation.label} '
        '(${operation.duration.inMilliseconds}ms)',
  StageChangedEvent(:final stage) => _stageLine(stage),
  FlutterAppStateEvent(:final appId, :final running, :final url) =>
    '[$appId] ${running ? 'running${url == null ? '' : ' at $url'}' : 'stopped'}',
  FlutterAppsChangedEvent() ||
  ManifestChangedEvent() ||
  OperationsDiscardedEvent() => null,
};

String formatHistoryEntry(Object entry) => switch (entry) {
  LogEntry() => formatLogEntryLine(entry),
  _ => entry.toString(),
};

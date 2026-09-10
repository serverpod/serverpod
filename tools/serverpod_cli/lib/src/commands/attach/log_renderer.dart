import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_cli/src/runner/runner_client.dart';
import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart' show CompletedOperation;

/// Streams the runner at [socketPath] as plain text, and returns the exit code.
///
/// The runner's own code when it stops, 1 when nothing will rebuild it or it
/// goes silent past [reconnectDeadline], and 0 on Ctrl+C, which only detaches.
Future<int> attachWithLogStream(
  String socketPath, {
  IOSink? out,
  Stream<ProcessSignal>? interrupts,
  Duration? waitForRunner,
  Duration reconnectDeadline = const Duration(seconds: 10),
}) async {
  final sink = out ?? stdout;
  final client = RunnerClient(
    socketPath: socketPath,
    reconnectDeadline: reconnectDeadline,
  );
  await client.attach(waitFor: waitForRunner);

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
  // A runner stopping before this client attached sends no stage change.
  if (client.stage == RunnerStage.stopping) done.complete(client.exitCode ?? 0);

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
  ServerLogEvent(:final entry, :final duplicatesLine) =>
    duplicatesLine ? null : formatLogEntryLine(entry),
  ServerLineEvent(:final line) => line,
  FlutterLineEvent(:final appId, :final line) => '[$appId] $line',
  FlutterLogEntryEvent(:final appId, :final entry, appendedToLines: true) =>
    '[$appId] ${formatLogEntryLine(entry)}',
  // The app printed this entry itself, and it arrives as a FlutterLineEvent.
  FlutterLogEntryEvent() => null,
  OperationStartedEvent(:final operation) => '... ${operation.label}',
  OperationCompletedEvent(:final operation) => _completedOperationLine(
    operation,
  ),
  StageChangedEvent(:final stage) => _stageLine(stage),
  final FlutterAppStateEvent state =>
    '[${state.appId}] ${_appStateLine(state)}',
  FlutterAppsChangedEvent() ||
  ManifestChangedEvent() ||
  OperationsDiscardedEvent() => null,
};

/// The line for a retained history [entry], as its live event prints it.
///
/// [CompletedOperation] needs a case, since it does not override `toString`.
String formatHistoryEntry(Object entry) => switch (entry) {
  LogEntry() => formatLogEntryLine(entry),
  CompletedOperation() => _completedOperationLine(entry),
  _ => entry.toString(),
};

/// A Flutter app's state as one line, showing a cold build as launching.
String _appStateLine(FlutterAppStateEvent state) {
  if (state.running) {
    final url = state.url;
    return 'running${url == null ? '' : ' at $url'}';
  }
  if (state.launching) {
    final stage = state.launchStage;
    return 'launching${stage == null ? '' : ' ($stage)'}';
  }
  return 'stopped';
}

String _completedOperationLine(CompletedOperation operation) =>
    '${operation.success ? '✓' : '✗'} ${operation.label} '
    '(${operation.duration.inMilliseconds}ms)';

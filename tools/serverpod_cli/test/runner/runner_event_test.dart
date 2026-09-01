import 'dart:convert';

import 'package:serverpod_cli/src/runner/runner_event.dart';
import 'package:serverpod_cli/src/runner/runner_snapshot.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart'
    show CompletedOperation, TrackedOperation;
import 'package:test/test.dart';

/// Encodes [event], puts it through JSON, and decodes it again, so a test
/// exercises the same path a socket does.
RunnerEvent? _roundTrip(RunnerEvent event) => RunnerEvent.fromJson(
  jsonDecode(jsonEncode(event.toJson())) as Map<String, Object?>,
);

void main() {
  group('Given a runner event,', () {
    test(
      'when a server log entry is sent, '
      'then its level, message and time survive',
      () {
        final decoded =
            _roundTrip(
                  ServerLogEvent(
                    LogEntry(
                      time: DateTime.utc(2026, 8, 25, 10, 30),
                      level: LogLevel.error,
                      message: 'Boom.',
                      scope: LogScope.root('server'),
                      error: 'StateError',
                    ),
                  ),
                )
                as ServerLogEvent;

        expect(decoded.entry.level, LogLevel.error);
        expect(decoded.entry.message, 'Boom.');
        expect(decoded.entry.time, DateTime.utc(2026, 8, 25, 10, 30));
        expect(decoded.entry.error, 'StateError');
      },
    );

    test(
      'when an operation starts, '
      'then its label and start time survive, so a late client can time it',
      () {
        final startedAt = DateTime.utc(2026, 8, 25, 11);
        final decoded =
            _roundTrip(
                  OperationStartedEvent(
                    TrackedOperation(id: 'op-7', label: 'Hot restart'),
                    startedAt: startedAt,
                  ),
                )
                as OperationStartedEvent;

        expect(decoded.operation.id, 'op-7');
        expect(decoded.operation.label, 'Hot restart');
        expect(decoded.startedAt, startedAt);
      },
    );

    test(
      'when an operation completes, '
      'then the duration the runner measured and the operation id survive',
      () {
        final decoded =
            _roundTrip(
                  OperationCompletedEvent(
                    CompletedOperation(
                      label: 'Applying migrations',
                      success: false,
                      duration: const Duration(milliseconds: 1234),
                      completedAt: DateTime.utc(2026, 8, 25, 11, 5),
                    ),
                    id: 'op-7',
                  ),
                )
                as OperationCompletedEvent;

        expect(decoded.operation.label, 'Applying migrations');
        expect(decoded.operation.success, isFalse);
        expect(decoded.operation.duration, const Duration(milliseconds: 1234));
        expect(decoded.id, 'op-7');
      },
    );

    test(
      'when a Flutter output line is sent, '
      'then the app it belongs to survives',
      () {
        final decoded =
            _roundTrip(
                  const FlutterLineEvent(appId: 'admin', line: 'Syncing...'),
                )
                as FlutterLineEvent;

        expect(decoded.appId, 'admin');
        expect(decoded.line, 'Syncing...');
      },
    );

    test(
      'when a stage transition is sent, '
      'then the stage and whether the server is up survive',
      () {
        final decoded =
            _roundTrip(
                  const StageChangedEvent(
                    RunnerStage.degraded,
                    isRunning: false,
                  ),
                )
                as StageChangedEvent;

        expect(decoded.stage, RunnerStage.degraded);
        expect(decoded.isRunning, isFalse);
      },
    );

    test(
      'when an app reports a launch stage, '
      'then it survives, so the tab says what the toolchain is doing',
      () {
        final decoded =
            _roundTrip(
                  const FlutterAppStateEvent(
                    appId: 'admin',
                    running: false,
                    launching: true,
                    launchStage: 'Running pub get',
                  ),
                )
                as FlutterAppStateEvent;

        expect(decoded.launchStage, 'Running pub get');
      },
    );

    test(
      'when the runner announces it is stopping, '
      'then the exit code it is leaving with survives',
      () {
        final decoded =
            _roundTrip(
                  const StageChangedEvent(
                    RunnerStage.stopping,
                    isRunning: false,
                    exitCode: 3,
                  ),
                )
                as StageChangedEvent;

        expect(decoded.exitCode, 3);
      },
    );

    test(
      'when a stage transition carries no exit code, '
      'then none is decoded, so a client cannot read one that was never sent',
      () {
        final decoded =
            _roundTrip(
                  const StageChangedEvent(
                    RunnerStage.running,
                    isRunning: true,
                  ),
                )
                as StageChangedEvent;

        expect(decoded.exitCode, isNull);
      },
    );

    test(
      'when the Flutter app registry changes, '
      'then every app id survives',
      () {
        final decoded =
            _roundTrip(
                  FlutterAppsChangedEvent([
                    decodeFlutterApp(const {'id': 'admin', 'name': 'Admin'}),
                    decodeFlutterApp(const {'id': 'shop', 'name': 'Shop'}),
                  ]),
                )
                as FlutterAppsChangedEvent;

        expect([for (final app in decoded.apps) app.id], ['admin', 'shop']);
      },
    );

    test(
      'when an app changes state, '
      'then whether it runs, whether it is launching and its URL survive',
      () {
        final decoded =
            _roundTrip(
                  const FlutterAppStateEvent(
                    appId: 'admin',
                    running: true,
                    launching: false,
                    url: 'http://localhost:5000',
                  ),
                )
                as FlutterAppStateEvent;

        expect(decoded.appId, 'admin');
        expect(decoded.running, isTrue);
        expect(decoded.launching, isFalse);
        expect(decoded.url, 'http://localhost:5000');
      },
    );

    test(
      'when an event kind this client does not know arrives, '
      'then it is skipped rather than breaking the stream',
      () {
        expect(RunnerEvent.fromJson(const {'event': 'teleport'}), isNull);
      },
    );
  });

  group('Given a discarded-operations event,', () {
    test(
      'when it is sent, '
      'then the ids survive, so a client can drop the right operations',
      () {
        final decoded =
            _roundTrip(const OperationsDiscardedEvent(['scope_1', 'scope_2']))
                as OperationsDiscardedEvent;

        expect(decoded.ids, ['scope_1', 'scope_2']);
      },
    );
  });

  group('Given a runner stage name,', () {
    test(
      'when it is one this client knows, '
      'then it decodes to that stage',
      () {
        expect(RunnerStage.byName('degraded'), RunnerStage.degraded);
      },
    );

    test(
      'when it is unknown, '
      'then it falls back to starting rather than throwing',
      () {
        expect(RunnerStage.byName('teleporting'), RunnerStage.starting);
      },
    );
  });
}

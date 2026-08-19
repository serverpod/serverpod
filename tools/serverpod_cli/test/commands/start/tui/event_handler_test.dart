import 'dart:async';

import 'package:nocterm/nocterm.dart' show ClipboardManager;
import 'package:serverpod_cli/src/commands/start/flutter_log_event.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/event_handler.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/tui/tab_model.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';

Event _logEvent(Map<String, Object?> data) {
  return Event(
    kind: EventKind.kExtension,
    timestamp: 0,
    extensionKind: 'ext.serverpod.log',
    extensionData: ExtensionData.parse(data),
  );
}

Event _flutterErrorEvent(Map<String, Object?> data) {
  return Event(
    kind: EventKind.kExtension,
    timestamp: 0,
    extensionKind: 'Flutter.Error',
    extensionData: ExtensionData.parse(data),
  );
}

void main() {
  late ServerWatchState state;
  late StartAppStateHolder holder;
  late StartLogHistory history;

  setUp(() {
    state = ServerWatchState();
    history = state.history;
    holder = StartAppStateHolder(state);
    history.attachHolder(holder);
  });

  group(
    'Given a log event flagged as an alert with copy markup when recorded,',
    () {
      String? previousClipboard;

      setUp(() {
        previousClipboard = ClipboardManager.paste();
        ClipboardManager.copy('previous clipboard content');
        history.recordServerLogEvent(
          _logEvent({
            'type': 'log',
            'level': 'info',
            'message': 'Registration code: <h2k9x3mp>',
            'metadata': {'alert': true},
          }),
        );
      });

      tearDown(() {
        final prev = previousClipboard;
        if (prev != null) ClipboardManager.copy(prev);
      });

      test('then shows the alert with the markup stripped.', () {
        expect(state.alert?.displayText, 'Registration code: h2k9x3mp');
      });

      test('then copies the marked segment to the clipboard.', () {
        expect(ClipboardManager.paste(), 'h2k9x3mp');
      });

      test('then the raw log line keeps the markup.', () {
        final entry = state.logHistory.first as LogEntry;
        expect(entry.message, 'Registration code: <h2k9x3mp>');
      });
    },
  );

  group(
    'Given a log event flagged as an alert without copy markup when recorded,',
    () {
      setUp(() {
        history.recordServerLogEvent(
          _logEvent({
            'type': 'log',
            'level': 'info',
            'message': 'Server requires a restart',
            'metadata': {'alert': true},
          }),
        );
      });

      test('then shows the alert verbatim.', () {
        expect(state.alert?.displayText, 'Server requires a restart');
      });

      test('then the alert has no copy text.', () {
        expect(state.alert?.copyText, isNull);
      });
    },
  );

  group(
    'Given an ordinary log event containing angle brackets when recorded,',
    () {
      setUp(() {
        history.recordServerLogEvent(
          _logEvent({
            'type': 'log',
            'level': 'info',
            'message': 'Parsed List<int> from <html>',
          }),
        );
      });

      test('then no alert is shown.', () {
        expect(state.alert, isNull);
      });

      test('then the markup is left untouched in the log.', () {
        final entry = state.logHistory.first as LogEntry;
        expect(entry.message, 'Parsed List<int> from <html>');
      });
    },
  );

  group(
    'Given a log event whose metadata does not flag an alert when recorded,',
    () {
      setUp(() {
        history.recordServerLogEvent(
          _logEvent({
            'type': 'log',
            'level': 'info',
            'message': 'Some code: <abc>',
            'metadata': {'alert': false},
          }),
        );
      });

      test('then no alert is shown.', () {
        expect(state.alert, isNull);
      });
    },
  );

  group('Given a Flutter app tab and a framework error event,', () {
    late AppLogTab appTab;

    setUp(() {
      appTab = state.getOrCreateAppLogTab(
        appId: 'serverpod-app',
        label: 'Serverpod app',
      );
    });

    test(
      'when the event is dispatched, '
      'then the complete error is added to the app as one structured entry.',
      () {
        const error =
            "'package:flutter/src/widgets/framework.dart': Failed assertion: "
            "line 2168 pos 12: '_elements.contains(element)': is not true.\n"
            'See also: https://docs.flutter.dev/testing/errors';

        history.recordFlutterExtensionEvent(
          'serverpod-app',
          _flutterErrorEvent({
            'errorsSinceReload': 0,
            'renderedErrorText': error,
          }),
        );

        expect(appTab.logHistory, hasLength(1));
        final entry = appTab.logHistory.single as LogEntry;
        expect(entry.level, LogLevel.error);
        expect(entry.time, DateTime.fromMillisecondsSinceEpoch(0));
        expect(entry.message, error);
        expect(entry.metadata, {
          'errorsSinceReload': 0,
          'source': 'flutterError',
          'levelIsInferred': false,
          'timestampIsInferred': false,
        });
        expect(appTab.lines, error.split('\n'));
        expect(state.logHistory, isEmpty);
      },
    );
  });

  group('Given a Flutter app tab and a structured application log event,', () {
    late AppLogTab appTab;

    setUp(() {
      appTab = state.getOrCreateAppLogTab(
        appId: 'serverpod-app',
        label: 'Serverpod app',
      );
    });

    test(
      'when the event is dispatched, '
      'then it is added to the app instead of the server log.',
      () {
        history.recordFlutterExtensionEvent(
          'serverpod-app',
          _logEvent({
            'type': 'log',
            'level': 'warning',
            'message': 'Application warning',
            'timestamp': '2026-07-14T03:00:00.000Z',
          }),
        );

        expect(appTab.logHistory, hasLength(1));
        final entry = appTab.logHistory.single as LogEntry;
        expect(entry.level, LogLevel.warning);
        expect(entry.message, 'Application warning');
        expect(appTab.lines, ['Application warning']);
        expect(state.logHistory, isEmpty);
      },
    );
  });

  group('Given a Flutter app tab receiving unstructured output,', () {
    late AppLogTab appTab;

    setUp(() {
      appTab = state.getOrCreateAppLogTab(
        appId: 'serverpod-app',
        label: 'Serverpod app',
      );
    });

    test(
      'when an stderr line is received, '
      'then it is retained without inventing a second structured entry.',
      () {
        history.addFlutterLine(
          'serverpod-app',
          'libEGL warning: failed to create dri2 screen',
        );

        expect(appTab.lines, [
          'libEGL warning: failed to create dri2 screen',
        ]);
        expect(appTab.logHistory, isEmpty);
      },
    );
  });

  group(
    'Given a Flutter app that produced output before its tab was open,',
    () {
      setUp(() {
        history.addFlutterLine('serverpod-app', 'Launching lib/main.dart');
      });

      test(
        'when the tab is opened, '
        'then it shows the output produced so far.',
        () {
          final appTab = state.getOrCreateAppLogTab(
            appId: 'serverpod-app',
            label: 'Serverpod app',
          );

          expect(appTab.lines, ['Launching lib/main.dart']);
        },
      );
    },
  );

  group('Given a Flutter app tab receiving a source-structured log event,', () {
    late AppLogTab appTab;

    setUp(() {
      appTab = state.getOrCreateAppLogTab(
        appId: 'serverpod-app',
        label: 'Serverpod app',
      );
    });

    test(
      'when the event is dispatched, '
      'then its severity, timestamp, logger, error, and stack trace are preserved.',
      () {
        final time = DateTime.utc(2026, 7, 14, 3);

        history.recordFlutterLogEvent(
          'serverpod-app',
          FlutterLogEvent(
            time: time,
            level: LogLevel.warning,
            message: 'Connection is slow',
            source: FlutterLogSource.vmLogging,
            loggerName: 'sync',
            error: 'TimeoutException',
            stackTrace: '#0 sync (package:app/sync.dart:10:3)',
          ),
        );

        final entry = appTab.logHistory.single as LogEntry;
        expect(entry.level, LogLevel.warning);
        expect(entry.time, time);
        expect(entry.message, '[sync] Connection is slow');
        expect(entry.error, 'TimeoutException');
        expect(
          entry.stackTrace.toString(),
          '#0 sync (package:app/sync.dart:10:3)',
        );
        expect(entry.metadata, {
          'source': 'vmLogging',
          'loggerName': 'sync',
          'levelIsInferred': false,
          'timestampIsInferred': false,
        });
      },
    );

    test(
      'when the event is recorded for an app without a tab, '
      'then nothing is added to the open tab.',
      () {
        history.recordFlutterLogEvent(
          'other-app',
          FlutterLogEvent(
            time: DateTime.utc(2026, 7, 14, 3),
            level: LogLevel.info,
            message: 'Other app started',
            source: FlutterLogSource.vmLogging,
          ),
        );

        expect(appTab.logHistory, isEmpty);
      },
    );
  });

  group('Given runTrackedAction with server ready', () {
    setUp(() {
      state.serverReady = true;
    });

    test('when server not ready then ignores action', () {
      state.serverReady = false;
      var called = false;

      runTrackedAction(holder, 'Test', () async {
        called = true;
      });

      expect(called, isFalse);
      expect(state.activeOperations, isEmpty);
    });

    test('when already busy then ignores action', () {
      state.actionBusy = true;
      var called = false;

      runTrackedAction(holder, 'Test', () async {
        called = true;
      });

      expect(called, isFalse);
    });

    test('when action starts then sets busy and creates operation', () {
      final completer = Completer<void>();

      runTrackedAction(holder, 'Reload', () => completer.future);

      expect(state.actionBusy, isTrue);
      expect(state.activeOperations, hasLength(1));
      expect(state.activeOperations.values.first.label, 'Reload');

      completer.complete();
    });

    test('when action succeeds then clears busy and adds completed', () async {
      runTrackedAction(holder, 'Reload', () async {});

      await Future<void>.delayed(Duration.zero);

      expect(state.actionBusy, isFalse);
      expect(state.activeOperations, isEmpty);
      expect(state.logHistory, hasLength(1));
      final op = state.logHistory.first as CompletedOperation;
      expect(op.label, 'Reload');
      expect(op.success, isTrue);
    });

    test('when action fails then clears busy and marks failed', () async {
      runTrackedAction(
        holder,
        'Migrate',
        () async => throw StateError('fail'),
      );

      await Future<void>.delayed(Duration.zero);

      expect(state.actionBusy, isFalse);
      final op = state.logHistory.first as CompletedOperation;
      expect(op.label, 'Migrate');
      expect(op.success, isFalse);
    });
  });
}

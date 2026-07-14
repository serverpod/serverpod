import 'dart:async';

import 'package:nocterm/nocterm.dart' show ClipboardManager;
import 'package:serverpod_cli/src/commands/start/flutter_log_event.dart';
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

  setUp(() {
    state = ServerWatchState();
    holder = StartAppStateHolder(state);
  });

  group('Given a log event', () {
    setUp(() {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'log',
          'level': 'info',
          'message': 'Server started',
          'timestamp': '2026-04-10T12:00:00.000Z',
        }),
      );
    });

    test('when dispatched then adds to logHistory', () {
      expect(state.logHistory, hasLength(1));
      final entry = state.logHistory.first as LogEntry;
      expect(entry.message, 'Server started');
      expect(entry.level, LogLevel.info);
    });
  });

  group('Given a warning log event', () {
    setUp(() {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'log',
          'level': 'warning',
          'message': 'Slow query',
        }),
      );
    });

    test('when dispatched then parses level correctly', () {
      final entry = state.logHistory.first as LogEntry;
      expect(entry.level, LogLevel.warning);
    });
  });

  group('Given an error log event with error details and stackTrace', () {
    test('when dispatched then stores the error text and stack trace', () {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'log',
          'level': 'error',
          'message': 'Failed to apply database migrations.',
          'error':
              'Exception: DB has migration version 20260428173453748 '
              'registered but it is not found in the project files.',
          'stackTrace': '#0      fake (file:///fake.dart:1:1)',
        }),
      );

      final entry = state.logHistory.first as LogEntry;
      expect(entry.level, LogLevel.error);
      expect(entry.message, 'Failed to apply database migrations.');
      expect(
        entry.error,
        'Exception: DB has migration version 20260428173453748 '
        'registered but it is not found in the project files.',
      );
      expect(entry.stackTrace, isNotNull);
      expect(
        entry.stackTrace.toString(),
        '#0      fake (file:///fake.dart:1:1)',
      );
    });
  });

  group('Given an error log event with an empty stackTrace', () {
    test('when dispatched then leaves the stack trace null', () {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'log',
          'level': 'error',
          'message': 'Something failed.',
          'stackTrace': '',
        }),
      );

      final entry = state.logHistory.first as LogEntry;
      expect(entry.stackTrace, isNull);
    });
  });

  group(
    'Given a log event flagged as an alert with copy markup when dispatched',
    () {
      String? previousClipboard;

      setUp(() {
        previousClipboard = ClipboardManager.paste();
        ClipboardManager.copy('previous clipboard content');
        handleServerLogEvent(
          holder,
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

      test('then shows the alert with the markup stripped', () {
        expect(state.alert?.displayText, 'Registration code: h2k9x3mp');
      });

      test('then copies the marked segment to the clipboard', () {
        expect(ClipboardManager.paste(), 'h2k9x3mp');
      });

      test('then the raw log line keeps the markup', () {
        final entry = state.logHistory.first as LogEntry;
        expect(entry.message, 'Registration code: <h2k9x3mp>');
      });
    },
  );

  group(
    'Given a log event flagged as an alert without copy markup when dispatched',
    () {
      setUp(() {
        handleServerLogEvent(
          holder,
          _logEvent({
            'type': 'log',
            'level': 'info',
            'message': 'Server requires a restart',
            'metadata': {'alert': true},
          }),
        );
      });

      test('then shows the alert verbatim', () {
        expect(state.alert?.displayText, 'Server requires a restart');
      });

      test('then the alert has no copy text', () {
        expect(state.alert?.copyText, isNull);
      });
    },
  );

  group(
    'Given an ordinary log event containing angle brackets when dispatched',
    () {
      setUp(() {
        handleServerLogEvent(
          holder,
          _logEvent({
            'type': 'log',
            'level': 'info',
            'message': 'Parsed List<int> from <html>',
          }),
        );
      });

      test('then no alert is shown', () {
        expect(state.alert, isNull);
      });

      test('then the markup is left untouched in the log', () {
        final entry = state.logHistory.first as LogEntry;
        expect(entry.message, 'Parsed List<int> from <html>');
      });
    },
  );

  group(
    'Given a log event whose metadata does not flag an alert when dispatched',
    () {
      setUp(() {
        handleServerLogEvent(
          holder,
          _logEvent({
            'type': 'log',
            'level': 'info',
            'message': 'Some code: <abc>',
            'metadata': {'alert': false},
          }),
        );
      });

      test('then no alert is shown', () {
        expect(state.alert, isNull);
      });
    },
  );

  group('Given a scope_start event', () {
    setUp(() {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'scope_start',
          'id': 'scope_1',
          'label': 'POST /api/user',
          'timestamp': '2026-04-10T12:00:00.000Z',
        }),
      );
    });

    test('when dispatched then creates tracked operation', () {
      expect(state.activeOperations, contains('scope_1'));
      expect(state.activeOperations['scope_1']!.label, 'POST /api/user');
    });
  });

  group('Given an INTERNAL scope_start event', () {
    setUp(() {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'scope_start',
          'id': 'scope_2',
          'label': 'INTERNAL',
        }),
      );
    });

    test('when dispatched then does not create tracked operation', () {
      expect(state.activeOperations, isEmpty);
    });
  });

  group('Given a scope that is opened and closed', () {
    setUp(() {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'scope_start',
          'id': 'scope_3',
          'label': 'GET /api/data',
        }),
      );
    });

    test('when scope_end arrives then completes as tracked operation', () {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'scope_end',
          'id': 'scope_3',
          'success': true,
          'duration': 0.1,
        }),
      );

      expect(state.activeOperations, isEmpty);
      expect(state.logHistory, hasLength(1));
      final op = state.logHistory.first as CompletedOperation;
      expect(op.label, 'GET /api/data');
      expect(op.success, isTrue);
      expect(op.duration.inMilliseconds, 100);
    });

    test('when scope_end with failure then marks as failed', () {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'scope_end',
          'id': 'scope_3',
          'success': false,
        }),
      );

      final op = state.logHistory.first as CompletedOperation;
      expect(op.success, isFalse);
    });
  });

  group('Given a non-serverpod extension event', () {
    test('when dispatched then ignores it', () {
      final event = Event(
        kind: EventKind.kExtension,
        timestamp: 0,
        extensionKind: 'ext.other.event',
        extensionData: ExtensionData.parse({'type': 'log'}),
      );

      handleServerLogEvent(holder, event);

      expect(state.logHistory, isEmpty);
    });
  });

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

        handleFlutterExtensionEvent(
          holder,
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

    test(
      'when a Flutter error event has no rendered error text, '
      'then it is ignored.',
      () {
        handleFlutterExtensionEvent(
          holder,
          'serverpod-app',
          _flutterErrorEvent({'errorsSinceReload': 0}),
        );

        expect(appTab.logHistory, isEmpty);
        expect(appTab.lines, isEmpty);
      },
    );

    test(
      'when the error text contains ANSI styling, '
      'then both structured and raw histories contain plain text.',
      () {
        handleFlutterExtensionEvent(
          holder,
          'serverpod-app',
          _flutterErrorEvent({
            'renderedErrorText': '\x1b[31mA framework error\x1b[0m',
          }),
        );

        final entry = appTab.logHistory.single as LogEntry;
        expect(entry.message, 'A framework error');
        expect(appTab.lines, ['A framework error']);
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
        handleFlutterExtensionEvent(
          holder,
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
        handleFlutterOutput(
          holder,
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

  group('Given a Flutter app tab and a framework error without a count,', () {
    late AppLogTab appTab;

    setUp(() {
      appTab = state.getOrCreateAppLogTab(
        appId: 'serverpod-app',
        label: 'Serverpod app',
      );
    });

    test(
      'when the event is dispatched, '
      'then its metadata does not contain a null value.',
      () {
        handleFlutterExtensionEvent(
          holder,
          'serverpod-app',
          _flutterErrorEvent({'renderedErrorText': 'A framework error'}),
        );

        final entry = appTab.logHistory.single as LogEntry;
        expect(entry.metadata, {
          'source': 'flutterError',
          'levelIsInferred': false,
          'timestampIsInferred': false,
        });
      },
    );
  });

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

        handleFlutterLogEvent(
          holder,
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
      'when the event contains ANSI styling, '
      'then the rendered message, error, and stack trace contain plain text.',
      () {
        handleFlutterLogEvent(
          holder,
          'serverpod-app',
          FlutterLogEvent(
            time: DateTime.utc(2026, 7, 14, 3),
            level: LogLevel.error,
            message: '\x1b[31mFailed\x1b[0m',
            source: FlutterLogSource.processStderr,
            loggerName: '\x1b[33mflutter\x1b[0m',
            error: '\x1b[31mBad state\x1b[0m',
            stackTrace: '\x1b[2m#0 main (app.dart:1)\x1b[0m',
          ),
        );

        final entry = appTab.logHistory.single as LogEntry;
        expect(entry.message, '[flutter] Failed');
        expect(entry.error, 'Bad state');
        expect(entry.stackTrace.toString(), '#0 main (app.dart:1)');
      },
    );
  });

  group('Given parseLogLevel', () {
    test('when "debug" then returns debug', () {
      expect(parseLogLevel('debug'), LogLevel.debug);
    });

    test('when "info" then returns info', () {
      expect(parseLogLevel('info'), LogLevel.info);
    });

    test('when "warning" then returns warning', () {
      expect(parseLogLevel('warning'), LogLevel.warning);
    });

    test('when "warn" then returns warning', () {
      expect(parseLogLevel('warn'), LogLevel.warning);
    });

    test('when "error" then returns error', () {
      expect(parseLogLevel('error'), LogLevel.error);
    });

    test('when "fatal" then returns fatal', () {
      expect(parseLogLevel('fatal'), LogLevel.fatal);
    });

    test('when unknown then defaults to info', () {
      expect(parseLogLevel('unknown'), LogLevel.info);
    });
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

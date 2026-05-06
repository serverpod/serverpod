import 'dart:async';

import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/event_handler.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:serverpod_shared/log.dart';
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
    test(
      'when dispatched then stores the error text but not the stack trace',
      () {
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
        expect(entry.stackTrace, isNull);
      },
    );
  });

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

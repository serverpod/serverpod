import 'dart:async';

import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/event_handler.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
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
  late AppStateHolder holder;

  setUp(() {
    state = ServerWatchState();
    holder = AppStateHolder(state);
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
      final entry = state.logHistory.first as TuiLogEntry;
      expect(entry.message, 'Server started');
      expect(entry.level, TuiLogLevel.info);
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
      final entry = state.logHistory.first as TuiLogEntry;
      expect(entry.level, TuiLogLevel.warning);
    });
  });

  group('Given a session_start event', () {
    setUp(() {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'session_start',
          'id': 'sess_1',
          'label': 'POST /api/user',
          'timestamp': '2026-04-10T12:00:00.000Z',
        }),
      );
    });

    test('when dispatched then creates tracked operation', () {
      expect(state.activeOperations, contains('sess_1'));
      expect(state.activeOperations['sess_1']!.label, 'POST /api/user');
    });
  });

  group('Given an INTERNAL session_start event', () {
    setUp(() {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'session_start',
          'id': 'sess_2',
          'label': 'INTERNAL',
        }),
      );
    });

    test('when dispatched then does not create tracked operation', () {
      expect(state.activeOperations, isEmpty);
    });
  });

  group('Given a session with sub-entries', () {
    setUp(() {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'session_start',
          'id': 'sess_3',
          'label': 'GET /api/data',
        }),
      );
    });

    test('when session_log arrives then adds sub-entry', () {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'session_log',
          'sessionId': 'sess_3',
          'level': 'info',
          'message': 'Fetching records',
        }),
      );

      final op = state.activeOperations['sess_3']!;
      expect(op.entries, hasLength(1));
      expect(op.entries.first.message, 'Fetching records');
      expect(op.entries.first.level, TuiLogLevel.info);
    });

    test('when session_query arrives then adds query sub-entry', () {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'session_query',
          'sessionId': 'sess_3',
          'query': 'SELECT * FROM users',
          'duration': 0.042,
        }),
      );

      final op = state.activeOperations['sess_3']!;
      expect(op.entries, hasLength(1));
      expect(op.entries.first.message, 'SELECT * FROM users');
      expect(op.entries.first.duration, 0.042);
    });

    test('when session_end arrives then completes as tracked operation', () {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'session_end',
          'id': 'sess_3',
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

    test('when session_end with failure then marks as failed', () {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'session_end',
          'id': 'sess_3',
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

  group('Given session_log for unknown session', () {
    test('when dispatched then silently ignores', () {
      handleServerLogEvent(
        holder,
        _logEvent({
          'type': 'session_log',
          'sessionId': 'nonexistent',
          'level': 'info',
          'message': 'orphan',
        }),
      );

      expect(state.activeOperations, isEmpty);
      expect(state.logHistory, isEmpty);
    });
  });

  group('Given parseTuiLogLevel', () {
    test('when "debug" then returns debug', () {
      expect(parseTuiLogLevel('debug'), TuiLogLevel.debug);
    });

    test('when "info" then returns info', () {
      expect(parseTuiLogLevel('info'), TuiLogLevel.info);
    });

    test('when "warning" then returns warning', () {
      expect(parseTuiLogLevel('warning'), TuiLogLevel.warning);
    });

    test('when "warn" then returns warning', () {
      expect(parseTuiLogLevel('warn'), TuiLogLevel.warning);
    });

    test('when "error" then returns error', () {
      expect(parseTuiLogLevel('error'), TuiLogLevel.error);
    });

    test('when "fatal" then returns fatal', () {
      expect(parseTuiLogLevel('fatal'), TuiLogLevel.fatal);
    });

    test('when unknown then defaults to info', () {
      expect(parseTuiLogLevel('unknown'), TuiLogLevel.info);
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

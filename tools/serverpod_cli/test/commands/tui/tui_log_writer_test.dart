import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:serverpod_cli/src/commands/tui/tui_log_writer.dart';
import 'package:serverpod_shared/log.dart';
import 'package:test/test.dart';

LogEntry _entry(String message, {LogLevel level = LogLevel.info}) => LogEntry(
  time: DateTime.now(),
  level: level,
  message: message,
  scope: LogScope.root('test'),
);

void main() {
  late ServerWatchState state;
  late StartAppStateHolder holder;
  late TuiLogWriter writer;

  setUp(() {
    state = ServerWatchState();
    holder = StartAppStateHolder(state);
    writer = TuiLogWriter();
  });

  group('Given a TuiLogWriter before attach', () {
    test('when logging then buffers messages', () async {
      await writer.log(_entry('hello'));
      await writer.log(_entry('warn', level: LogLevel.warning));

      expect(state.logHistory, isEmpty);
    });

    test('when attaching then flushes buffered messages', () async {
      await writer.log(_entry('first'));
      await writer.log(_entry('second', level: LogLevel.error));

      writer.attach(holder);

      expect(state.logHistory, hasLength(2));
      final first = state.logHistory[0] as LogEntry;
      final second = state.logHistory[1] as LogEntry;
      expect(first.message, 'first');
      expect(first.level, LogLevel.info);
      expect(second.message, 'second');
      expect(second.level, LogLevel.error);
    });
  });

  group('Given a TuiLogWriter after attach', () {
    setUp(() {
      writer.attach(holder);
    });

    test('when logging info then adds to logHistory', () async {
      await writer.log(_entry('hello'));

      expect(state.logHistory, hasLength(1));
      final entry = state.logHistory.first as LogEntry;
      expect(entry.message, 'hello');
      expect(entry.level, LogLevel.info);
    });

    test('when logging debug then adds with debug level', () async {
      await writer.log(_entry('details', level: LogLevel.debug));

      final entry = state.logHistory.first as LogEntry;
      expect(entry.level, LogLevel.debug);
    });

    test('when logging warning then adds with warning level', () async {
      await writer.log(_entry('careful', level: LogLevel.warning));

      final entry = state.logHistory.first as LogEntry;
      expect(entry.level, LogLevel.warning);
    });

    test('when exceeding maxLogEntries then removes oldest', () async {
      for (var i = 0; i < ServerWatchState.maxLogEntries + 10; i++) {
        await writer.log(_entry('msg $i'));
      }

      expect(state.logHistory, hasLength(ServerWatchState.maxLogEntries));
      final first = state.logHistory.first as LogEntry;
      expect(first.message, 'msg 10');
    });
  });

  group('Given a TuiLogWriter with scopes', () {
    setUp(() {
      writer.attach(holder);
    });

    test(
      'when scope opens and closes then creates and completes tracked operation',
      () async {
        final scope = LogScope(
          id: 'test_scope',
          label: 'Loading',
          startTime: DateTime.now(),
        );
        await writer.openScope(scope);

        expect(state.activeOperations, contains('test_scope'));
        expect(state.activeOperations['test_scope']!.label, 'Loading');

        await writer.closeScope(
          scope,
          success: true,
          duration: const Duration(milliseconds: 100),
        );

        expect(state.activeOperations, isEmpty);
        expect(state.logHistory, hasLength(1));
        final op = state.logHistory.first as CompletedOperation;
        expect(op.label, 'Loading');
        expect(op.success, isTrue);
      },
    );

    test('when scope closes with failure then marks as failed', () async {
      final scope = LogScope(
        id: 'fail_scope',
        label: 'Migration',
        startTime: DateTime.now(),
      );
      await writer.openScope(scope);
      await writer.closeScope(
        scope,
        success: false,
        duration: const Duration(seconds: 1),
      );

      final op = state.logHistory.first as CompletedOperation;
      expect(op.success, isFalse);
    });

    test('when scope is active then shows in activeOperations', () async {
      final scope = LogScope(
        id: 'active_scope',
        label: 'Compiling',
        startTime: DateTime.now(),
      );
      await writer.openScope(scope);

      expect(state.activeOperations, hasLength(1));
      expect(state.activeOperations.values.first.label, 'Compiling');

      await writer.closeScope(
        scope,
        success: true,
        duration: Duration.zero,
      );
    });
  });
}

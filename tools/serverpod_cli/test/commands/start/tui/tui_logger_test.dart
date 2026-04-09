import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/tui/tui_logger.dart';
import 'package:test/test.dart';

void main() {
  late ServerWatchState state;
  late AppStateHolder holder;
  late TuiLogger logger;

  setUp(() {
    state = ServerWatchState();
    holder = AppStateHolder(state);
    logger = TuiLogger();
  });

  group('Given a TuiLogger before attach', () {
    test('when logging then buffers messages', () {
      logger.info('hello');
      logger.warning('warn');

      expect(state.logHistory, isEmpty);
    });

    test('when attaching then flushes buffered messages', () {
      logger.info('first');
      logger.error('second');

      logger.attach(holder);

      expect(state.logHistory, hasLength(2));
      final first = state.logHistory[0] as TuiLogEntry;
      final second = state.logHistory[1] as TuiLogEntry;
      expect(first.message, 'first');
      expect(first.level, TuiLogLevel.info);
      expect(second.message, 'second');
      expect(second.level, TuiLogLevel.error);
    });
  });

  group('Given a TuiLogger after attach', () {
    setUp(() {
      logger.attach(holder);
    });

    test('when logging info then adds to logHistory', () {
      logger.info('hello');

      expect(state.logHistory, hasLength(1));
      final entry = state.logHistory.first as TuiLogEntry;
      expect(entry.message, 'hello');
      expect(entry.level, TuiLogLevel.info);
    });

    test('when logging debug then adds with debug level', () {
      logger.debug('details');

      final entry = state.logHistory.first as TuiLogEntry;
      expect(entry.level, TuiLogLevel.debug);
    });

    test('when logging warning then adds with warning level', () {
      logger.warning('careful');

      final entry = state.logHistory.first as TuiLogEntry;
      expect(entry.level, TuiLogLevel.warning);
    });

    test('when logging error with stacktrace then includes it', () {
      final st = StackTrace.current;
      logger.error('broke', stackTrace: st);

      final entry = state.logHistory.first as TuiLogEntry;
      expect(entry.level, TuiLogLevel.error);
      expect(entry.message, contains('broke'));
      expect(entry.message, contains(st.toString()));
    });

    test('when exceeding maxLogEntries then removes oldest', () {
      for (var i = 0; i < ServerWatchState.maxLogEntries + 10; i++) {
        logger.info('msg $i');
      }

      expect(state.logHistory, hasLength(ServerWatchState.maxLogEntries));
      final first = state.logHistory.first as TuiLogEntry;
      expect(first.message, 'msg 10');
    });
  });

  group('Given a TuiLogger with progress', () {
    setUp(() {
      logger.attach(holder);
    });

    test(
      'when progress succeeds then creates and completes tracked operation',
      () async {
        await logger.progress('Loading', () async => true);

        expect(state.activeOperations, isEmpty);
        expect(state.logHistory, hasLength(1));
        final op = state.logHistory.first as CompletedOperation;
        expect(op.label, 'Loading');
        expect(op.success, isTrue);
      },
    );

    test('when progress fails then marks operation as failed', () async {
      await logger.progress('Loading', () async => false);

      final op = state.logHistory.first as CompletedOperation;
      expect(op.success, isFalse);
    });

    test('when progress is running then shows in activeOperations', () async {
      final running = logger.progress('Loading', () async {
        expect(state.activeOperations, hasLength(1));
        expect(state.activeOperations.values.first.label, 'Loading');
        return true;
      });

      await running;
    });
  });
}

import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_shared/log.dart';
import 'package:test/test.dart';

Future<void> _sendCtrlC(NoctermTester tester) {
  return tester.sendKeyEvent(
    const KeyboardEvent(
      logicalKey: LogicalKey.keyC,
      modifiers: ModifierKeys(ctrl: true),
    ),
  );
}

Future<void> _sendKey(NoctermTester tester, LogicalKey key) {
  return tester.sendKeyEvent(KeyboardEvent(logicalKey: key));
}

void main() {
  late NoctermTester tester;
  late ServerWatchState state;
  late StartAppStateHolder holder;

  setUp(() async {
    state = ServerWatchState();
    holder = StartAppStateHolder(state);
    tester = await NoctermTester.create(size: const Size(80, 24));
    await tester.pumpComponent(
      ServerpodWatchApp(holder: holder, onReady: (_) {}),
    );
  });

  tearDown(() async {
    tester.dispose();
    await holder.dispose();
  });

  group('Given a running TUI start app with onQuit callback wired', () {
    late int quitCalls;

    setUp(() {
      quitCalls = 0;
      holder.onQuit = () => quitCalls++;
    });

    test(
      'when Ctrl-C is pressed twice without a selection then onQuit is invoked',
      () async {
        await _sendCtrlC(tester);
        await _sendCtrlC(tester);

        expect(quitCalls, 1);
      },
    );
  });

  group('Given a structured log tab with a stack-traced error entry', () {
    setUp(() {
      state.logHistory.add(
        LogEntry(
          time: DateTime(2026),
          level: LogLevel.error,
          message: 'boom',
          scope: LogScope.root('server'),
          error: 'Exception: boom',
          stackTrace: StackTrace.fromString('#0 a\n#1 b'),
        ),
      );
    });

    test('when e is pressed then stack traces expand and collapse', () async {
      expect(state.expandStackTraces, isFalse);

      await _sendKey(tester, LogicalKey.keyE);
      expect(state.expandStackTraces, isTrue);

      await _sendKey(tester, LogicalKey.keyE);
      expect(state.expandStackTraces, isFalse);
    });

    test('when e is pressed on a raw output tab then traces do not toggle', () async {
      state.selectedTab = 2;

      await _sendKey(tester, LogicalKey.keyE);

      expect(state.expandStackTraces, isFalse);
    });
  });

  group('Given a running TUI start app with the help overlay open', () {
    setUp(() {
      state.showHelp = true;
    });

    test(
      'when Ctrl-C is pressed then it bubbles past the help-mode key absorber and exit is armed',
      () async {
        await _sendCtrlC(tester);

        expect(state.ctrlCHint, 'Press Ctrl-C again to exit');
      },
    );
  });
}

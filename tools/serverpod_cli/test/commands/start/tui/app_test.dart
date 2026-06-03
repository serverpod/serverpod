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

Future<void> _sendCtrlR(NoctermTester tester) {
  return tester.sendKeyEvent(
    const KeyboardEvent(
      logicalKey: LogicalKey.keyR,
      modifiers: ModifierKeys(ctrl: true),
    ),
  );
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

    test(
      'when e is pressed on the Flutter logs tab then traces do not toggle',
      () async {
        state.showFlutterOutput = true;
        state.selectedTab = 1;

        await _sendKey(tester, LogicalKey.keyE);

        expect(state.expandStackTraces, isFalse);
      },
    );

    test('when backtick is pressed then the raw server logs open', () async {
      expect(state.showRawServerLogs, isFalse);

      await _sendKey(tester, LogicalKey.backquote);
      expect(state.showRawServerLogs, isTrue);

      await _sendKey(tester, LogicalKey.backquote);
      expect(state.showRawServerLogs, isFalse);
    });

    test('when period is pressed then the raw server logs open', () async {
      expect(state.showRawServerLogs, isFalse);

      await _sendKey(tester, LogicalKey.period);
      expect(state.showRawServerLogs, isTrue);

      await _sendKey(tester, LogicalKey.period);
      expect(state.showRawServerLogs, isFalse);
    });
  });

  group('Given the raw server logs overlay is open', () {
    setUp(() {
      state.showRawServerLogs = true;
    });

    test('when Esc is pressed then it closes', () async {
      await _sendKey(tester, LogicalKey.escape);

      expect(state.showRawServerLogs, isFalse);
    });

    test('when period is pressed then it closes', () async {
      await _sendKey(tester, LogicalKey.period);

      expect(state.showRawServerLogs, isFalse);
    });
  });

  group('Given a running TUI start app with a Flutter app running', () {
    late int restartCalls;

    setUp(() {
      restartCalls = 0;
      holder.onRestartFlutterApp = () => restartCalls++;
      state.showFlutterOutput = true;
    });

    test(
      'when Ctrl+R is pressed then the Flutter app restart is invoked',
      () async {
        await _sendCtrlR(tester);

        expect(restartCalls, 1);
      },
    );

    test(
      'when Ctrl+R is pressed then it does not fall through to hot reload',
      () async {
        var reloadCalls = 0;
        holder.onHotReload = () => reloadCalls++;
        state.serverReady = true;
        state.showSplash = false;

        await _sendCtrlR(tester);

        expect(reloadCalls, 0);
      },
    );
  });

  group(
    'Given a running TUI start app where the Flutter app has not launched yet but a restart is available',
    () {
      late int restartCalls;

      setUp(() {
        restartCalls = 0;
        holder.onRestartFlutterApp = () => restartCalls++;
        // No Flutter tab shown yet, but the project can launch one.
        state.showFlutterOutput = false;
        state.flutterRestartAvailable = true;
      });

      test(
        'when Ctrl+R is pressed then the Flutter app launch is invoked',
        () async {
          await _sendCtrlR(tester);

          expect(restartCalls, 1);
        },
      );
    },
  );

  group('Given a running TUI start app with no Flutter package', () {
    late int restartCalls;

    setUp(() {
      restartCalls = 0;
      holder.onRestartFlutterApp = () => restartCalls++;
      // Both gates default to false: no Flutter tab and nothing to launch.
    });

    test(
      'when Ctrl+R is pressed then the Flutter app restart is not invoked',
      () async {
        await _sendCtrlR(tester);

        expect(restartCalls, 0);
      },
    );
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

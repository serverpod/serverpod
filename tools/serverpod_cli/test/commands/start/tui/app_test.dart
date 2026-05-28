import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:test/test.dart';

Future<void> _sendCtrlC(NoctermTester tester) {
  return tester.sendKeyEvent(
    const KeyboardEvent(
      logicalKey: LogicalKey.keyC,
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

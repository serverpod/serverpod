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
  late bool quit;

  setUp(() async {
    state = ServerWatchState();
    holder = StartAppStateHolder(state);
    quit = false;
    tester = await NoctermTester.create(size: const Size(80, 24));
    await tester.pumpComponent(
      ServerpodWatchApp(holder: holder, onReady: (_) {}),
    );
    holder.onQuit = () => quit = true;
  });

  tearDown(() async {
    tester.dispose();
    await holder.dispose();
  });

  group('Given text is selected in a log view', () {
    setUp(() {
      state.selectedText = 'a selected log line';
    });

    test(
      'when Ctrl-C is pressed then the selection is copied without exiting',
      () async {
        await _sendCtrlC(tester);

        expect(ClipboardManager.paste(), 'a selected log line');
        expect(state.ctrlCHint, 'Copied to clipboard');
        expect(quit, isFalse);
      },
    );
  });

  group('Given nothing is selected', () {
    test(
      'when Ctrl-C is pressed once then exit is armed without exiting',
      () async {
        await _sendCtrlC(tester);

        expect(state.ctrlCHint, 'Press Ctrl-C again to exit');
        expect(quit, isFalse);
      },
    );

    test('when Ctrl-C is pressed twice then the app quits', () async {
      await _sendCtrlC(tester);
      await _sendCtrlC(tester);

      expect(quit, isTrue);
    });
  });
}

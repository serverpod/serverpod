import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/create/tui/app.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_cli/src/create/create.dart';
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
  late CreateConfigState state;
  late CreateAppStateHolder holder;
  late bool quit;

  setUp(() async {
    state = CreateConfigState(ServerpodTemplateType.server);
    holder = CreateAppStateHolder(state);
    quit = false;
    tester = await NoctermTester.create(size: const Size(80, 24));
    await tester.pumpComponent(
      ServerpodCreateApp(
        name: 'my_project',
        holder: holder,
        onCreate: () {},
        onQuit: () => quit = true,
        onSkipFlutterBuild: () {},
      ),
    );
  });

  tearDown(() async {
    tester.dispose();
    await holder.dispose();
  });

  group('Given text is selected during project creation', () {
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

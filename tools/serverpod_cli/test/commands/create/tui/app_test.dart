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
  group('Given the create TUI', () {
    late NoctermTester tester;
    late CreateConfigState state;
    late CreateAppStateHolder holder;
    late int quitCalls;

    setUp(() async {
      state = CreateConfigState(ServerpodTemplateType.server);
      holder = CreateAppStateHolder(state);
      quitCalls = 0;
      tester = await NoctermTester.create(size: const Size(80, 24));
      await tester.pumpComponent(
        ServerpodCreateApp(
          holder: holder,
          name: 'test_project',
          onCreate: () {},
          onQuit: () => quitCalls++,
          onSkipFlutterBuild: () {},
        ),
      );
    });

    tearDown(() async {
      tester.dispose();
      await holder.dispose();
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
}

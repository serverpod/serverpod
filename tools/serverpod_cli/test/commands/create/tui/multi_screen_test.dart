import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/create/tui/app.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:test/test.dart';

Future<void> _sendKeyAndPump(NoctermTester tester, LogicalKey key) async {
  await tester.sendKey(key);
  await tester.pump();
}

void main() {
  group('Given the create TUI with server template', () {
    late NoctermTester tester;
    late CreateConfigState state;
    late CreateAppStateHolder holder;
    late int createCalls;

    setUp(() async {
      state = CreateConfigState(ServerpodTemplateType.server);
      holder = CreateAppStateHolder(state);
      createCalls = 0;
      tester = await NoctermTester.create(size: const Size(80, 24));
      await tester.pumpComponent(
        ServerpodCreateApp(
          holder: holder,
          onCreate: () => createCalls++,
          onQuit: () {},
        ),
      );
    });

    tearDown(() async {
      tester.dispose();
      await holder.dispose();
    });

    test(
      'when navigating through all config screens, '
      'then the summary screen is reached',
      () async {
        final configCount = state.form.configScreenCount;

        for (var i = 0; i < configCount; i++) {
          expect(state.form.isSummary, isFalse);
          expect(state.form.currentScreenIndex, i);
          await _sendKeyAndPump(tester, LogicalKey.enter);
        }

        expect(state.form.isSummary, isTrue);
      },
    );

    test(
      'when Enter is pressed on the summary screen, '
      'then the state transitions to creating mode and onCreate is called',
      () async {
        for (var i = 0; i < state.form.configScreenCount; i++) {
          await _sendKeyAndPump(tester, LogicalKey.enter);
        }
        expect(state.form.isSummary, isTrue);
        expect(state.creatingProject, isFalse);

        await _sendKeyAndPump(tester, LogicalKey.enter);

        expect(state.creatingProject, isTrue);
        expect(createCalls, 1);
      },
    );
  });
}

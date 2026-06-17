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
      'when Enter is pressed on the first screen '
      'then it advances to the next screen',
      () async {
        expect(state.currentScreenIndex, 0);

        await _sendKeyAndPump(tester, LogicalKey.enter);

        expect(state.currentScreenIndex, 1);
      },
    );

    test(
      'when Escape is pressed on the first screen '
      'then it stays on the first screen',
      () async {
        expect(state.currentScreenIndex, 0);

        await _sendKeyAndPump(tester, LogicalKey.escape);

        expect(state.currentScreenIndex, 0);
      },
    );

    test(
      'when Escape is pressed on a non-first screen '
      'then it goes back to the previous screen',
      () async {
        await _sendKeyAndPump(tester, LogicalKey.enter);
        expect(state.currentScreenIndex, 1);

        await _sendKeyAndPump(tester, LogicalKey.escape);

        expect(state.currentScreenIndex, 0);
      },
    );

    test(
      'when using arrowDown then Space on a non-first screen '
      'then it goes back to the previous screen',
      () async {
        await _sendKeyAndPump(tester, LogicalKey.enter);
        expect(state.currentScreenIndex, 1);

        await _sendKeyAndPump(tester, LogicalKey.arrowDown);
        expect(state.focusOnButton, isTrue);
        expect(state.focusedButtonIndex, 0);

        await _sendKeyAndPump(tester, LogicalKey.space);

        expect(state.currentScreenIndex, 0);
      },
    );

    test(
      'when navigating through all config screens '
      'then the summary screen is reached',
      () async {
        final configCount = state.configScreenCount;

        for (var i = 0; i < configCount; i++) {
          expect(state.isSummary, isFalse);
          expect(state.currentScreenIndex, i);
          await _sendKeyAndPump(tester, LogicalKey.enter);
        }

        expect(state.isSummary, isTrue);
        expect(state.currentScreenIndex, configCount);
      },
    );

    test(
      'when on the summary screen and Enter is pressed '
      'then onCreate is invoked',
      () async {
        for (var i = 0; i < state.configScreenCount; i++) {
          await _sendKeyAndPump(tester, LogicalKey.enter);
        }
        expect(state.isSummary, isTrue);
        expect(createCalls, 0);

        await _sendKeyAndPump(tester, LogicalKey.enter);

        expect(createCalls, 1);
        expect(state.creatingProject, isTrue);
      },
    );

    test(
      'when creating project '
      'then the state transitions to creating mode and onCreate is called',
      () async {
        for (var i = 0; i < state.configScreenCount; i++) {
          await _sendKeyAndPump(tester, LogicalKey.enter);
        }

        expect(state.creatingProject, isFalse);

        await _sendKeyAndPump(tester, LogicalKey.enter);

        expect(state.creatingProject, isTrue);
        expect(createCalls, 1);
      },
    );
  });
}

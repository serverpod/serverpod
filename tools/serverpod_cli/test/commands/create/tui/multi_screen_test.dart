import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/create/tui/app.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:test/test.dart';

const _selectHint = '💡 Space or click to select · Enter to continue';

Future<void> _sendKeyAndPump(NoctermTester tester, LogicalKey key) async {
  await tester.sendKey(key);
  await tester.pump();
}

/// Selects an editor first, since the first screen requires one.
Future<void> _navigateToSummary(
  NoctermTester tester,
  CreateConfigState state,
) async {
  await _sendKeyAndPump(tester, LogicalKey.space);
  for (var i = 0; i < state.form.configScreenCount; i++) {
    await _sendKeyAndPump(tester, LogicalKey.enter);
  }
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
      'when the first screen is shown, '
      'then it is the editor selection with the select and continue hint',
      () {
        expect(
          tester.terminalState.containsText('Code editors & AI agents'),
          isTrue,
        );
        expect(tester.terminalState.containsText(_selectHint), isTrue);
      },
    );

    test(
      'when Enter is pressed without selecting an editor, '
      'then the editor selection is still shown',
      () async {
        await _sendKeyAndPump(tester, LogicalKey.enter);

        expect(state.form.currentScreenIndex, 0);
      },
    );

    test(
      'when the None option is selected and Enter is pressed, '
      'then the next screen is shown',
      () async {
        // None is the last option, one step left of the first.
        await _sendKeyAndPump(tester, LogicalKey.arrowLeft);
        await _sendKeyAndPump(tester, LogicalKey.space);
        // Rebuilds are throttled, wait for the selection to be rendered.
        await tester.pump(const Duration(milliseconds: 100));
        await _sendKeyAndPump(tester, LogicalKey.enter);

        expect(state.form.currentScreenIndex, 1);
      },
    );

    test(
      'when an editor is selected and all config screens are navigated, '
      'then the summary screen is reached',
      () async {
        final configCount = state.form.configScreenCount;

        await _sendKeyAndPump(tester, LogicalKey.space);
        for (var i = 0; i < configCount; i++) {
          expect(state.form.isSummary, isFalse);
          expect(state.form.currentScreenIndex, i);
          await _sendKeyAndPump(tester, LogicalKey.enter);
        }

        expect(state.form.isSummary, isTrue);
      },
    );

    test(
      'when the summary screen is shown, '
      'then the select and continue hint is not shown',
      () async {
        await _navigateToSummary(tester, state);
        await tester.pump(const Duration(milliseconds: 100));

        expect(state.form.isSummary, isTrue);
        expect(tester.terminalState.containsText(_selectHint), isFalse);
      },
    );

    test(
      'when Enter is pressed on the summary screen, '
      'then the state transitions to creating mode and onCreate is called',
      () async {
        await _navigateToSummary(tester, state);
        expect(state.form.isSummary, isTrue);
        expect(state.creatingProject, isFalse);

        await _sendKeyAndPump(tester, LogicalKey.enter);

        expect(state.creatingProject, isTrue);
        expect(createCalls, 1);
      },
    );

    test(
      'when project creation starts, '
      'then the select and continue hint is not shown',
      () async {
        await _navigateToSummary(tester, state);
        await _sendKeyAndPump(tester, LogicalKey.enter);
        await tester.pump(const Duration(milliseconds: 100));

        expect(state.creatingProject, isTrue);
        expect(tester.terminalState.containsText(_selectHint), isFalse);
      },
    );
  });
}

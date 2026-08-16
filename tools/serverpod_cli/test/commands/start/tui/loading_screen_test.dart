import 'package:nocterm/nocterm.dart' hide isEmpty;
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/loading_screen.dart';
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
  group('Given a loading screen mounted hidden', () {
    late NoctermTester tester;

    setUp(() async {
      tester = await NoctermTester.create(size: const Size(80, 24));
      await tester.pumpComponent(const LoadingScreen(visible: false));
    });

    tearDown(() {
      tester.dispose();
    });

    // Ancestors that change their tree shape (e.g. the Ctrl-C hint row
    // appearing) remount the loading screen. A fresh mount never observes
    // the visible true->false transition, so it must hide on its own.
    test('when rendered then the splash is not shown', () {
      final screen = tester.renderToString(showBorders: false);

      expect(screen.trim(), isEmpty);
    });
  });

  group('Given a running TUI start app whose splash has been dismissed', () {
    late NoctermTester tester;
    late ServerWatchState state;
    late StartAppStateHolder holder;

    setUp(() async {
      state = ServerWatchState();
      state.showSplash = false;
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

    test('when rendered then the splash is not shown', () {
      final screen = tester.renderToString(showBorders: false);

      expect(screen, isNot(contains('Serverpod')));
    });

    test('when Ctrl-C arms exit then the splash does not reappear', () async {
      await _sendCtrlC(tester);
      await tester.pump();

      final screen = tester.renderToString(showBorders: false);
      expect(state.ctrlCHint, 'Press Ctrl-C again to exit');
      expect(screen, isNot(contains('Serverpod')));
    });
  });
}

import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ServerWatchState', () {
    late ServerWatchState state;

    setUp(() {
      state = ServerWatchState();
    });

    test('when created then defaults are correct', () {
      expect(state.logHistory, isEmpty);
      expect(state.rawLines, isEmpty);
      expect(state.activeOperations, isEmpty);
      expect(state.selectedTab, 0);
      expect(state.actionBusy, isFalse);
      expect(state.serverReady, isFalse);
      expect(state.showSplash, isTrue);
      expect(state.showHelp, isFalse);
    });
  });
}

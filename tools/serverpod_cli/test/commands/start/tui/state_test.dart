import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_tui/serverpod_tui.dart';
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

  group('Given a ServerWatchState with entries in every log buffer', () {
    late ServerWatchState state;

    setUp(() {
      state = ServerWatchState();
      state.logHistory.add('server entry');
      state.rawLines.add('raw server line');
      state.rawFlutterLines.add('raw flutter line');
    });

    test('when clearLogs is called then every log buffer is emptied', () {
      state.clearLogs();

      expect(state.logHistory, isEmpty);
      expect(state.rawLines, isEmpty);
      expect(state.rawFlutterLines, isEmpty);
    });
  });

  group(
    'Given a ServerWatchState with in-progress operations and log entries',
    () {
      late ServerWatchState state;
      late TrackedOperation operation;

      setUp(() {
        state = ServerWatchState();
        operation = TrackedOperation(id: 'hot-reload', label: 'Hot reload');
        state.activeOperations[operation.id] = operation;
        state.logHistory.add('server entry');
        state.rawLines.add('raw server line');
        state.rawFlutterLines.add('raw flutter line');
      });

      test('when clearLogs is called then activeOperations are preserved', () {
        state.clearLogs();

        expect(state.activeOperations, hasLength(1));
        expect(state.activeOperations[operation.id], same(operation));
      });
    },
  );
}

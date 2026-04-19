import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:test/test.dart';

void main() {
  group('Given a TrackedOperation', () {
    late TrackedOperation op;

    setUp(() {
      op = TrackedOperation(id: 'test', label: 'Test op');
    });

    test('when created then stopwatch is running', () {
      expect(op.stopwatch.isRunning, isTrue);
    });

    test('when stopped then elapsed is non-zero', () async {
      await Future.delayed(const Duration(milliseconds: 10));
      op.stopwatch.stop();

      expect(op.stopwatch.elapsed.inMilliseconds, greaterThan(0));
    });
  });

  group('Given a CompletedOperation', () {
    test('when created then completedAt defaults to now', () {
      final before = DateTime.now();
      final op = CompletedOperation(
        label: 'Test',
        success: true,
        duration: const Duration(milliseconds: 100),
        entries: [],
      );
      final after = DateTime.now();

      expect(
        op.completedAt.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        op.completedAt.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('when created with explicit completedAt then uses it', () {
      final time = DateTime(2026, 1, 1);
      final op = CompletedOperation(
        label: 'Test',
        success: false,
        duration: const Duration(seconds: 5),
        entries: [],
        completedAt: time,
      );

      expect(op.completedAt, time);
    });
  });

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
      expect(state.expandOperations, isFalse);
    });
  });
}

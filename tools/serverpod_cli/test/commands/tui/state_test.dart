import 'package:serverpod_cli/src/commands/tui/state.dart';
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
        completedAt: time,
      );

      expect(op.completedAt, time);
    });
  });
}

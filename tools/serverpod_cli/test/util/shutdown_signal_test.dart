import 'dart:async';

import 'package:serverpod_cli/src/util/shutdown_signal.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given successful work with pending cleanup, '
    'when the work finishes, '
    'then its result is returned only after cleanup completes.',
    () async {
      final cleanupStarted = Completer<void>();
      final releaseCleanup = Completer<void>();
      addTearDown(() {
        if (!releaseCleanup.isCompleted) releaseCleanup.complete();
      });
      var completed = false;

      final result =
          runWithShutdownSignals(
            (_) async => 42,
            cleanup: () async {
              cleanupStarted.complete();
              await releaseCleanup.future;
            },
          ).then((value) {
            completed = true;
            return value;
          });
      await cleanupStarted.future;
      final completedBeforeCleanup = completed;
      releaseCleanup.complete();
      final value = await result;

      expect(completedBeforeCleanup, isFalse);
      expect(value, 42);
    },
  );

  test(
    'Given work that throws with pending cleanup, '
    'when the work fails, '
    'then cleanup finishes before the original error and stack propagate.',
    () async {
      final error = StateError('work failed');
      final stack = StackTrace.current;
      final cleanupStarted = Completer<void>();
      final releaseCleanup = Completer<void>();
      addTearDown(() {
        if (!releaseCleanup.isCompleted) releaseCleanup.complete();
      });
      var propagated = false;

      final result =
          runWithShutdownSignals<void>(
            (_) async => Error.throwWithStackTrace(error, stack),
            cleanup: () async {
              cleanupStarted.complete();
              await releaseCleanup.future;
            },
          ).then<(Object, StackTrace)?>(
            (_) => null,
            onError: (Object caught, StackTrace caughtStack) {
              propagated = true;
              return (caught, caughtStack);
            },
          );
      await cleanupStarted.future;
      final propagatedBeforeCleanup = propagated;
      releaseCleanup.complete();
      final caught = await result;

      expect(propagatedBeforeCleanup, isFalse);
      expect(caught?.$1, same(error));
      expect(caught?.$2.toString(), stack.toString());
    },
  );

  test(
    'Given successful work whose cleanup fails, '
    'when cleanup throws, '
    'then the cleanup error propagates to the caller.',
    () async {
      final error = StateError('cleanup failed');

      final result = runWithShutdownSignals(
        (_) async => 42,
        cleanup: () async => throw error,
      );

      await expectLater(result, throwsA(same(error)));
    },
  );
}

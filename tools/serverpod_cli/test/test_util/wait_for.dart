import 'package:test/test.dart';

/// Polls [condition] until it holds, failing after [timeout].
///
/// For socket state, where `pumpEventQueue` does not wait for pending I/O.
Future<void> waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final waited = Stopwatch()..start();
  while (!condition()) {
    if (waited.elapsed > timeout) {
      fail('Condition was not met within $timeout.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

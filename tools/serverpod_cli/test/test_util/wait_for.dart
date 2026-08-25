import 'package:test/test.dart';

/// Polls [condition] until it holds, failing after [timeout].
///
/// For state that crosses a real socket, where how many event-loop turns it
/// takes is not something a test can assume. `pumpEventQueue` is not a
/// barrier for pending I/O.
Future<void> waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Condition was not met within $timeout.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

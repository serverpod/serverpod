/// Test helper to flush all pending microtasks.
/// Useful for waiting for async events to complete before continuing the test.
///
/// For example, if depending on a generator function to execute up to its `yield`, then the
/// event queue can be flushed to ensure the generator has executed up to that point:
///
/// ```dart
/// var stream = endpoints.someEndoint.listenForNumbersOnSharedStream(session);
/// await flushEventQueue();
/// ```
///
/// Implemenation note: `Future.delayed` will be put on the event loop since it's a timer.
/// Items on the event loop are not processed until all pending microtasks are completed.
Future<void> flushMicrotasks() {
  return Future.delayed(Duration.zero);
}

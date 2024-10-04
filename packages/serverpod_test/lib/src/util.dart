/// Test helper to flush the event queue.
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
/// Implemenation note: `Future.delayed` will be put last in the event queue since it's a timer.
/// This will ensure that all other events are processed before the `Future.delayed` event.
Future<void> flushEventQueue() {
  return Future.delayed(Duration.zero);
}

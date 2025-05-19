import 'dart:io';

/// Manages listeners that are called when the server is shutting down.
///
/// The ShutdownListenerManager allows registering callback functions that will 
/// be executed during the server shutdown process. This is useful for 
/// performing cleanup operations, releasing resources, or saving state before 
/// the server terminates.
///
/// This class is used internally by the Serverpod framework to manage shutdown
/// operations.
class ShutdownListenerManager {
  /// Map of registered shutdown listeners with their identifiers.
  final Map<String, Future<void> Function()> _listeners = {};

  /// Adds a listener function that will be called during server shutdown.
  ///
  /// The [listener] is a callback function that will be executed when the 
  /// server is shutting down. It should return a [Future] that completes when 
  /// the shutdown operation is done.
  ///
  /// An optional [listenerIdentifier] can be provided to identify the listener
  /// in error messages. If not provided, a default identifier will be 
  /// generated.
  void addListener(
    Future<void> Function() listener, {
    String? listenerIdentifier,
  }) {
    final String identifier =
        listenerIdentifier ?? 'Listener ${_listeners.keys.length + 1}';
    _listeners[identifier] = listener;
  }

  /// Executes all registered shutdown listeners.
  ///
  /// This method is called during the server shutdown process. It iterates
  /// through all registered listeners and executes them. If a listener throws
  /// an exception, it will be caught and logged, but the shutdown process will
  /// continue with the remaining listeners.
  ///
  /// Returns a [Future] that completes when all listeners have been executed.
  Future<void> handleShutdown() async {
    _listeners.forEach((key, listener) async {
      try {
        await listener();
      } catch (e, stack) {
        stdout.writeln(
          'Error during shutdownListenerManager at listener: $key\n'
          'Error: $e\n$stack',
        );
      }
    });
  }
}

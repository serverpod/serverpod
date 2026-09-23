import 'push_dispatcher.dart';
import 'push_store_config.dart';

/// Process-global push store state: config and the running dispatcher.
class PushStore {
  /// Returns the singleton instance.
  static PushStore get instance {
    final local = _instance;
    if (local == null) {
      throw StateError(
        'PushStore is not set. Call initializePushStore() or PushStore.set() '
        'before accessing the instance.',
      );
    }
    return local;
  }

  static PushStore? _instance;

  /// Installs the global instance. Does not start the dispatcher.
  static void set({required final PushStoreConfig config}) {
    _instance = PushStore._(config: config);
  }

  /// Clears the global instance. Intended for tests.
  static void reset() {
    _instance = null;
  }

  /// Creates a store handle.
  PushStore._({required this.config});

  /// Dispatcher and enqueue configuration.
  final PushStoreConfig config;

  /// Running dispatcher, if any.
  PushDispatcher? dispatcher;
}

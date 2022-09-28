import 'package:meta/meta.dart';

/// Callback for when internet connectivity changes.
typedef ConnectivityMonitorListener = void Function(bool connected);

/// Keeps track of internet connectivity and notifies its listeners when the
/// internet connection is either lost or regained. For most use cases, use
/// the concrete FlutterConnectivityMonitor class in the serverpod_flutter
/// package.
abstract class ConnectivityMonitor {
  final _listeners = <ConnectivityMonitorListener>{};

  /// Adds a listener to the connectivity monitor.
  void addListener(ConnectivityMonitorListener listener) {
    _listeners.add(listener);
  }

  /// Removes a listener from the connectivity monitor.
  void removeListener(ConnectivityMonitorListener listener) {
    _listeners.remove(listener);
  }

  /// Removes all listeners from the connectivity monitor.
  void dispose() {
    _listeners.clear();
  }

  /// Notifies listeners of changes in connectivity. This method should only
  /// be called by classes that inherits from [ConnectivityMonitor].
  @protected
  void notifyListeners(bool connected) {
    for (var listener in _listeners) {
      listener(connected);
    }
  }
}

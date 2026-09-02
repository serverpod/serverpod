import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

import 'cross_tab_lock.dart';

/// A [CrossTabLock] backed by the browser's Web Locks API, shared across all
/// tabs of the same origin that use the same lock [name].
class WebLocksCrossTabLock implements CrossTabLock {
  /// The name identifying the lock across tabs.
  final String name;

  /// Creates a new [WebLocksCrossTabLock].
  WebLocksCrossTabLock(this.name);

  /// Whether the browser supports the Web Locks API.
  static bool get isSupported => web.window.navigator.has('locks');

  @override
  Future<T> synchronize<T>(Future<T> Function() action) async {
    late T result;
    Object? error;
    StackTrace? errorStackTrace;

    // The lock is held until the promise returned by the callback settles.
    // Errors are captured and rethrown on the Dart side, since a rejection
    // does not reliably preserve the Dart exception across the JS boundary.
    JSPromise<JSAny?> callback(JSAny? lock) => action()
        .then((value) {
          result = value;
        })
        .catchError((Object e, StackTrace stackTrace) {
          error = e;
          errorStackTrace = stackTrace;
        })
        .toJS;

    await web.window.navigator.locks.request(name, callback.toJS).toDart;

    final capturedError = error;
    if (capturedError != null) {
      Error.throwWithStackTrace(capturedError, errorStackTrace!);
    }
    return result;
  }
}

part of '../message/request.dart';

/// Hijacking allows low-level control of an HTTP connection, bypassing the normal
/// request-response lifecycle. This is often used for advanced use cases such as
/// upgrading the connection to WebSocket, custom streaming protocols, or raw data
/// processing.
///
/// Once a connection is hijacked, the server stops managing it, and the developer
/// gains direct access to the underlying socket or data stream.
typedef HijackCallback = void Function(StreamChannel<List<int>>);
typedef HijackHandler = void Function(HijackCallback);

/// A callback for [Request.hijack] and tracking of whether it has been called.
class _OnHijack {
  final HijackHandler _callback;

  bool called = false;

  _OnHijack(this._callback);

  /// Calls `this`.
  ///
  /// Throws a [StateError] if `this` has already been called.
  void run(HijackCallback callback) {
    if (called) throw StateError('This request has already been hijacked.');
    called = true;
    Future.microtask(() => _callback(callback));
  }
}

/// Detaches the socket from the response and passes it to the callback.
void onHijack(io.HttpResponse response, HijackCallback callback) {
  response
      .detachSocket(writeHeaders: false)
      .then((socket) => callback(StreamChannel(socket, socket)));
}

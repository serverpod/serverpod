import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/future_call_manager.dart';

/// Client for working with FutureCallManager
class FutureCallFacade {
  final Server _server;
  final FutureCallManager? _futureCallManager;

  /// Construc a new instace
  FutureCallFacade(this._server, this._futureCallManager);

  /// Registers a [FutureCall] with the [FutureCallManager] and associates it with
  /// the specified name.
  void registerFutureCall(FutureCall call, String name) {
    var futureCallManager = _futureCallManager;
    if (futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    _futureCallManager?.registerFutureCall(call, name);
  }

  /// Calls a [FutureCall] by its name after the specified delay, optionally
  /// passing a [SerializableModel] object as parameter.
  Future<void> futureCallWithDelay(
    String callName,
    SerializableModel? object,
    Duration delay, {
    String? identifier,
  }) async {
    assert(_server.running,
        'Server is not running, call start() before using future calls');
    var futureCallManager = _futureCallManager;
    if (futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    await _futureCallManager?.scheduleFutureCall(
      callName,
      object,
      DateTime.now().toUtc().add(delay),
      _server.serverId,
      identifier,
    );
  }

  /// Calls a [FutureCall] by its name at the specified time, optionally passing
  /// a [SerializableModel] object as parameter.
  Future<void> futureCallAtTime(
    String callName,
    SerializableModel? object,
    DateTime time, {
    String? identifier,
  }) async {
    var futureCallManager = _futureCallManager;
    assert(_server.running,
        'Server is not running, call start() before using future calls');
    if (futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }

    await _futureCallManager?.scheduleFutureCall(
      callName,
      object,
      time,
      _server.serverId,
      identifier,
    );
  }

  /// Cancels a [FutureCall] with the specified identifier. If no future call
  /// with the specified identifier is found, this call will have no effect.
  Future<void> cancelFutureCall(String identifier) async {
    var futureCallManager = _futureCallManager;
    if (futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    await _futureCallManager?.cancelFutureCall(identifier);
  }
}

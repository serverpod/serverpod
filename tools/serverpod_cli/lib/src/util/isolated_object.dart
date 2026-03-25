// TODO: verbatim copy from relic (almost). Should move to separate package.
import 'dart:async';
import 'dart:isolate';

typedef Factory<T> = FutureOr<T> Function();

typedef _Action<T> = ({int id, dynamic Function(T) function});
typedef _Response = ({int id, dynamic result});
typedef _Inflight = Map<int, Completer>;
typedef _Setup = (SendPort, ReceivePort, _Inflight);

/// Wraps an object of type [T] in a dedicated isolate, allowing method calls
/// to be forwarded via [evaluate].
///
/// This is useful for objects that perform work driven by timers or the event
/// loop (e.g. progress spinners), ensuring their timers keep firing even when
/// the calling isolate's event loop is blocked.
class IsolatedObject<T> {
  final Future<_Setup> _connected;

  IsolatedObject(Factory<T> create, {bool keepIsolateAlive = true})
    : _connected = _connect(create, keepIsolateAlive);

  static Future<_Setup> _connect<T>(
    Factory<T> create,
    bool keepIsolateAlive,
  ) async {
    final parentPort = RawReceivePort()..keepIsolateAlive = keepIsolateAlive;
    final setupDone = Completer<_Setup>();

    parentPort.handler = (dynamic message) async {
      if (message case final RemoteError e) {
        parentPort.close();
        setupDone.completeError(e, e.stackTrace);
      } else {
        final toChild = message as SendPort;
        final fromChild = ReceivePort.fromRawReceivePort(parentPort);
        final inflight = _Inflight();
        setupDone.complete((toChild, fromChild, inflight));
      }
    };

    try {
      await _spawn(create, parentPort.sendPort);
    } catch (_) {
      parentPort.close();
      rethrow;
    }

    final result = await setupDone.future;
    final (toChild, fromChild, inflight) = result;

    fromChild.listen(
      (dynamic message) async {
        if (message case final _Response response) {
          final completer = inflight.remove(response.id);
          assert(completer != null, 'PROTOCOL BUG. No such ID ${response.id}');
          if (completer == null) return;
          switch (response.result) {
            case final RemoteError e:
              completer.completeError(e, e.stackTrace);
            default:
              completer.complete(await response.result);
          }
        }
      },
      onDone: () {
        for (final c in inflight.values) {
          if (!c.isCompleted) {
            c.completeError(StateError('IsolatedObject<$T> channel closed'));
          }
        }
        inflight.clear();
      },
    );

    return result;
  }

  static Future<Isolate> _spawn<T>(
    Factory<T> create,
    SendPort toParent,
  ) {
    return Isolate.spawn((SendPort toParent) async {
      final childPort = ReceivePort();
      final T isolatedObject;
      try {
        isolatedObject = await create();
        toParent.send(childPort.sendPort);
      } catch (e, st) {
        toParent.send(RemoteError('$e', '$st'));
        return;
      }

      await for (final message in childPort) {
        if (message == null) {
          childPort.close();
          break;
        } else if (message case final _Action<T> action) {
          try {
            final result = await action.function(isolatedObject);
            toParent.send((id: action.id, result: result));
          } catch (e, st) {
            toParent.send((id: action.id, result: RemoteError('$e', '$st')));
          }
        }
      }
    }, toParent);
  }

  int _nextId = 0;
  bool _isClosed = false;
  bool get isClosed => _isClosed;

  /// Evaluates [function] on the isolated object and returns the result.
  Future<U> evaluate<U>(FutureOr<U> Function(T) function) async {
    if (_isClosed) {
      throw StateError('IsolatedObject<$T> is closed');
    }

    final (toChild, _, inflight) = await _connected;

    final id = _nextId++;
    final completer = Completer<U>();
    inflight[id] = completer;

    toChild.send((id: id, function: function));
    return completer.future;
  }

  /// Shuts down the isolate.
  Future<void> close() async {
    if (_isClosed) return;
    _isClosed = true;

    final (toChild, fromChild, inflight) = await _connected;

    // Fail any outstanding requests.
    for (final c in inflight.values) {
      if (!c.isCompleted) {
        c.completeError(StateError('$runtimeType is closed'));
      }
    }
    inflight.clear();

    toChild.send(null);
    fromChild.close();
  }
}

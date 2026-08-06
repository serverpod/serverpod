import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod_cli/src/vm_proxy/interceptor.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// A small HTTP/WebSocket proxy that sits between a VM-service client (an
/// IDE's DAP, DevTools, ...) and an upstream DDS endpoint.
///
/// Each accepted client connection opens a fresh upstream WebSocket; frames
/// are decoded as JSON-RPC where possible and dispatched to the
/// [RpcInterceptor]. Non-JSON / binary frames are forwarded verbatim.
///
/// Upstream is mutable via [setUpstream] - the proxy survives upstream
/// restarts (pod hot restart, Flutter hot restart) without changing its
/// own URI.
///
/// Upstream may also be `null`, in which case new client connections are
/// held in a waiting queue until [setUpstream] is called with a non-null
/// URI.
///
/// The proxy mints a per-instance token and accepts WebSocket upgrades only
/// on `/<token>=/ws`, mirroring how the Dart VM service authenticates its
/// own URI - this preserves the existing "anyone on loopback can connect
/// only if they know the token" property when the proxy replaces the
/// pod-side VM service URI in `vm-service-info.json`.
class VmServiceProxy {
  /// Upstream WebSocket URI, or `null` when no upstream is currently available.
  Uri? _upstreamWs;
  RpcInterceptor _interceptor;

  /// Directions whose frames are JSON-decoded and dispatched to
  /// [_interceptor]. Frames outside this set forward verbatim without
  /// parsing - the server-to-client event firehose can be skipped when no
  /// interceptor wants to look at it.
  final Set<Direction> _interceptDirections;

  /// Random token guarding the WS upgrade path.
  final String _token;

  /// How long a client may wait before the proxy closes its WS.
  final Duration _waitingClientTimeout;

  HttpServer? _server;
  final Set<_Pair> _pairs = {};
  final Set<_WaitingClient> _waitingClients = {};

  /// Fired the first time a client lands in the waiting queue while no
  /// upstream is bound. Callers use it to demand-start whatever process
  /// would provide that upstream (e.g. a Flutter app spawn triggered by
  /// IDE attach). Fires again if the waiting queue drains to empty and
  /// a new client arrives, so a second IDE attach after a Flutter exit
  /// can re-spawn. Never fires while an upstream is bound.
  final FutureOr<void> Function()? _onWaitingClientArrived;

  VmServiceProxy({
    Uri? upstreamWs,
    RpcInterceptor? interceptor,
    Set<Direction> interceptDirections = const {Direction.clientToServer},
    String? token,
    Duration waitingClientTimeout = const Duration(minutes: 2),
    FutureOr<void> Function()? onWaitingClientArrived,
  }) : _upstreamWs = upstreamWs,
       _interceptor = interceptor ?? passthroughInterceptor,
       _interceptDirections = interceptDirections,
       _token = token ?? _mintToken(),
       _waitingClientTimeout = waitingClientTimeout,
       _onWaitingClientArrived = onWaitingClientArrived;

  /// Replace the live interceptor. The next frame uses the new hook.
  @visibleForTesting
  set interceptor(RpcInterceptor i) => _interceptor = i;

  /// The current upstream URI, or `null` if no upstream is bound.
  Uri? get upstreamWs => _upstreamWs;

  /// Point future client connections at [upstreamWs] (or unbind by passing `null`).
  /// A re-bind to the same URI is a no-op.
  Future<void> setUpstream(Uri? upstreamWs) async {
    if (_upstreamWs == upstreamWs) return;
    _upstreamWs = upstreamWs;
    final live = List.of(_pairs);
    _pairs.clear();
    await [for (final p in live) p.close()].wait;
    if (upstreamWs != null) {
      final waiting = List.of(_waitingClients);
      _waitingClients.clear();
      for (final wc in waiting) {
        wc.timer?.cancel();
      }
      await [
        for (final wc in waiting)
          _attachUpstream(
            wc.ws,
            upstreamWs,
            existingDownSub: wc.sub,
            bufferedClientFrames: wc.buffered,
          ),
      ].wait;
    }
  }

  /// HTTP base URI of the proxy (e.g. `http://127.0.0.1:NNNN/<token>=/`).
  /// Format matches `dart --enable-vm-service` so consumers that derive a
  /// WS URI from the HTTP base land at our `/ws` endpoint.
  Uri get httpUri {
    final s = _server;
    if (s == null) throw StateError('Proxy is not bound.');
    return Uri(
      scheme: 'http',
      host: s.address.host,
      port: s.port,
      path: '/$_token=/',
    );
  }

  /// Binds the proxy. Loopback-only by default. Pass `port: 0` for an
  /// ephemeral port (recommended) and read [httpUri] afterwards.
  Future<void> bind({String host = '127.0.0.1', int port = 0}) async {
    if (_server != null) throw StateError('Proxy is already bound.');
    final server = await HttpServer.bind(host, port);
    _server = server;
    server.listen(_handleRequest, onError: (_) {});
  }

  Future<void> _handleRequest(HttpRequest req) async {
    final path = req.uri.path;
    if (!WebSocketTransformer.isUpgradeRequest(req) || path != '/$_token=/ws') {
      req.response.statusCode = HttpStatus.notFound;
      await req.response.close();
      return;
    }

    WebSocket downstream;
    try {
      downstream = await WebSocketTransformer.upgrade(req);
    } catch (_) {
      return;
    }

    final upstreamWs = _upstreamWs;
    if (upstreamWs == null) {
      _enqueueWaitingClient(downstream);
      return;
    }
    await _attachUpstream(downstream, upstreamWs);
  }

  /// Holds [downstream] in the waiting queue until either [setUpstream]
  /// is called with a non-null upstream, the client disconnects, or
  /// [_waitingClientTimeout] elapses.
  void _enqueueWaitingClient(WebSocket downstream) {
    final wasEmpty = _waitingClients.isEmpty;
    final wc = _WaitingClient(downstream);
    _waitingClients.add(wc);
    final cb = _onWaitingClientArrived;
    if (wasEmpty && cb != null) {
      // Fire-and-forget: don't block the handler on the callback's
      // future (which may include a Flutter spawn taking 30+ seconds).
      // The proxy keeps holding the WS; pairing happens when the
      // callback eventually calls setUpstream. Errors are swallowed
      // here so a failing spawn can't crash the proxy listener; the
      // callback owns its own error reporting.
      unawaited(Future(cb).catchError((Object _, StackTrace _) {}));
    }
    // A real VM-service client (an IDE's DAP) sends its handshake -
    // getVersion, streamListen, etc. - immediately upon connecting; it has
    // no way of knowing an upstream isn't ready yet. Buffer those frames
    // instead of discarding them so they can be replayed once paired
    // (see _Pair._flushBufferedThenResume); otherwise the client is left
    // waiting forever on a response to a request that was never forwarded.
    wc.sub = downstream.listen(
      wc.buffered.add,
      onDone: () {
        if (_waitingClients.remove(wc)) wc.timer?.cancel();
      },
      onError: (_) {},
    );
    wc.timer = Timer(_waitingClientTimeout, () async {
      if (_waitingClients.remove(wc)) {
        await downstream.close(
          WebSocketStatus.normalClosure,
          'no upstream available',
        );
      }
    });
  }

  Future<void> _attachUpstream(
    WebSocket downstream,
    Uri upstreamWs, {
    StreamSubscription<dynamic>? existingDownSub,
    List<Object?> bufferedClientFrames = const [],
  }) async {
    WebSocket upstream;
    try {
      upstream = await WebSocket.connect(upstreamWs.toString());
    } catch (_) {
      await existingDownSub?.cancel();
      await downstream.close(WebSocketStatus.internalServerError);
      return;
    }
    final pair = _Pair(
      downstream,
      upstream,
      () => _interceptor,
      _interceptDirections,
      existingDownSub: existingDownSub,
      bufferedClientFrames: bufferedClientFrames,
    );
    _pairs.add(pair);
    unawaited(pair.done.whenComplete(() => _pairs.remove(pair)));
    pair.start();
  }

  /// Closes the proxy, tears down all live pairs, drops waiting clients.
  Future<void> close() async {
    final liveServer = _server;
    _server = null;
    final waiting = List.of(_waitingClients);
    _waitingClients.clear();
    for (final wc in waiting) {
      wc.timer?.cancel();
    }
    // Don't cancel waiting subs explicitly.
    // Their onDone handlers run when ws.close completes and cleans up.
    await [
      for (final wc in waiting)
        wc.ws.close(WebSocketStatus.normalClosure, 'proxy shutting down'),
      ?liveServer?.close(force: true),
      for (final p in List.of(_pairs)) p.close(),
    ].wait;
  }

  static String _mintToken() =>
      base64Url.encode(generateRandomBytes(16)).replaceAll('=', '');
}

/// One downstream<->upstream connection.
class _Pair {
  final WebSocket _down;
  final WebSocket _up;
  final RpcInterceptor Function() _resolveInterceptor;
  final Set<Direction> _interceptDirections;
  StreamSubscription<dynamic>? _downSub;
  StreamSubscription<dynamic>? _upSub;
  final List<Object?> _bufferedClientFrames;
  final Completer<void> _done = Completer<void>();

  _Pair(
    this._down,
    this._up,
    this._resolveInterceptor,
    this._interceptDirections, {
    StreamSubscription<dynamic>? existingDownSub,
    List<Object?> bufferedClientFrames = const [],
  }) : _downSub = existingDownSub,
       _bufferedClientFrames = bufferedClientFrames;

  Future<void> get done => _done.future;

  void start() {
    final existing = _downSub;
    if (existing != null) {
      // Pause immediately so nothing reaches the still-installed
      // waiting-client handler (which appends to _bufferedClientFrames)
      // while we flush it below - otherwise a frame arriving mid-flush
      // could be lost or, iterating the same list, throw concurrent
      // modification.
      existing.pause();
      unawaited(_flushBufferedThenResume(existing));
    } else {
      _downSub = _down.listen(
        (data) => _onFrame(Direction.clientToServer, data),
        onDone: _close,
        onError: (_) => _close(),
        cancelOnError: false,
      );
    }
    _upSub = _up.listen(
      (data) => _onFrame(Direction.serverToClient, data),
      onDone: _close,
      onError: (_) => _close(),
      cancelOnError: false,
    );
  }

  /// Replays frames the client sent while it was still in the waiting
  /// queue, in order, through the same interceptor path as live traffic,
  /// then re-aims the pre-existing subscription (WebSocket is
  /// single-subscription so we can't listen again) at live forwarding and
  /// resumes it.
  Future<void> _flushBufferedThenResume(
    StreamSubscription<dynamic> existing,
  ) async {
    for (final data in _bufferedClientFrames) {
      await _onFrame(Direction.clientToServer, data);
    }
    existing.onData((data) => _onFrame(Direction.clientToServer, data));
    existing.onDone(_close);
    existing.onError((_) => _close());
    existing.resume();
  }

  Future<void> _onFrame(Direction dir, Object? data) async {
    final to = dir == Direction.clientToServer ? _up : _down;
    final back = dir == Direction.clientToServer ? _down : _up;

    // Fast path: skip JSON decode for directions no interceptor cares
    // about, and for binary frames. Both forward verbatim.
    if (!_interceptDirections.contains(dir) || data is! String) {
      to.add(data);
      return;
    }

    Map<String, Object?>? msg;
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, Object?>) msg = decoded;
    } on FormatException {
      // not JSON
    }
    if (msg == null) {
      to.add(data);
      return;
    }

    final result = await _resolveInterceptor()(msg, dir);
    switch (result) {
      case Forward():
        to.add(data);
      case Replace(message: final m):
        to.add(jsonEncode(m));
      case Respond(response: final r):
        if (dir != Direction.clientToServer || msg['id'] == null) {
          to.add(data); // no Id -> Forward
          return;
        }
        back.add(jsonEncode(r));
      case Drop():
        break;
    }
  }

  Future<void> close() => _close();

  Future<void> _close() async {
    if (_done.isCompleted) return;
    _done.complete();
    await [?_downSub?.cancel(), ?_upSub?.cancel()].wait;
    _downSub = null;
    _upSub = null;
    try {
      await [_down.close(), _up.close()].wait;
    } on ParallelWaitError {
      // Either side may already be closed by its peer
    }
  }
}

/// A client socket waiting for an upstream to become available. We
/// hold an active subscription during the wait so dart:io's WebSocket
/// can process control frames (close, ping) - otherwise our own
/// timeout-close never completes the handshake. On pair-up, the
/// subscription's handlers are re-aimed by [_Pair] via the
/// `onData` / `onDone` / `onError` setters; the underlying single-
/// subscription stream is never re-listened.
class _WaitingClient {
  _WaitingClient(this.ws);
  final WebSocket ws;

  /// Frames the client sent while queued here, in arrival order. Replayed
  /// once an upstream pairs with this client (see
  /// [_Pair._flushBufferedThenResume]).
  final List<Object?> buffered = [];
  StreamSubscription<dynamic>? sub;
  Timer? timer;
}

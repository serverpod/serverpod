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
/// The proxy mints a per-instance token and accepts WebSocket upgrades only
/// on `/<token>=/ws`, mirroring how the Dart VM service authenticates its
/// own URI - this preserves the existing "anyone on loopback can connect
/// only if they know the token" property when the proxy replaces the
/// pod-side VM service URI in `vm-service-info.json`.
class VmServiceProxy {
  /// Upstream WebSocket URI (typically the pod's DDS `ws://.../<token>=/ws`).
  /// Mutable so the proxy can survive pod restarts ([retarget]) without
  /// changing its own URI - existing clients reconnect at the same
  /// proxy URL after they observe their connection drop.
  Uri _upstreamWs;
  RpcInterceptor _interceptor;

  /// Directions whose frames are JSON-decoded and dispatched to
  /// [_interceptor]. Frames outside this set forward verbatim without
  /// parsing - the server-to-client event firehose can be skipped when no
  /// interceptor wants to look at it.
  final Set<Direction> _interceptDirections;

  /// Random token guarding the WS upgrade path.
  final String _token;

  HttpServer? _server;
  final Set<_Pair> _pairs = {};

  VmServiceProxy({
    required Uri upstreamWs,
    RpcInterceptor? interceptor,
    Set<Direction> interceptDirections = const {Direction.clientToServer},
    String? token,
  }) : _upstreamWs = upstreamWs,
       _interceptor = interceptor ?? passthroughInterceptor,
       _interceptDirections = interceptDirections,
       _token = token ?? _mintToken();

  /// Replace the live interceptor. The next frame uses the new hook.
  @visibleForTesting
  set interceptor(RpcInterceptor i) => _interceptor = i;

  /// Point future client connections at a different upstream WS URI and
  /// drop any pairs that are still live - they belong to a now-dead pod.
  /// Clients reconnect on their own; the proxy's published URI is stable.
  Future<void> retarget(Uri upstreamWs) async {
    _upstreamWs = upstreamWs;
    final live = List.of(_pairs);
    _pairs.clear();
    await [for (final p in live) p.close()].wait;
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

    WebSocket upstream;
    try {
      upstream = await WebSocket.connect(_upstreamWs.toString());
    } catch (_) {
      await downstream.close(WebSocketStatus.internalServerError);
      return;
    }

    final pair = _Pair(
      downstream,
      upstream,
      () => _interceptor,
      _interceptDirections,
    );
    _pairs.add(pair);
    unawaited(pair.done.whenComplete(() => _pairs.remove(pair)));
    pair.start();
  }

  /// Closes the proxy and tears down all live pairs.
  Future<void> close() async {
    final liveServer = _server;
    _server = null;
    await [
      ?liveServer?.close(force: true),
      ...[for (final p in List.of(_pairs)) p.close()],
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
  final Completer<void> _done = Completer<void>();

  _Pair(
    this._down,
    this._up,
    this._resolveInterceptor,
    this._interceptDirections,
  );

  Future<void> get done => _done.future;

  void start() {
    _downSub = _down.listen(
      (data) => _onFrame(Direction.clientToServer, data),
      onDone: _close,
      onError: (_) => _close(),
      cancelOnError: false,
    );
    _upSub = _up.listen(
      (data) => _onFrame(Direction.serverToClient, data),
      onDone: _close,
      onError: (_) => _close(),
      cancelOnError: false,
    );
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

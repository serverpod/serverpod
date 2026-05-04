import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/vm_proxy/interceptor.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';
import 'package:test/test.dart';

void main() {
  group('Given a VmServiceProxy in front of a fake DDS', () {
    late _FakeUpstream upstream;
    late VmServiceProxy proxy;

    setUp(() async {
      upstream = await _FakeUpstream.start();
      proxy = VmServiceProxy(upstreamWs: upstream.wsUri);
      await proxy.bind();
    });

    tearDown(() async {
      await proxy.close();
      await upstream.close();
    });

    test(
      'when an arbitrary JSON-RPC request round-trips, '
      'then the response reaches the client unchanged',
      () async {
        final client = await _connectClient(proxy);
        final responses = StreamController<Map<String, Object?>>();
        client.listen(
          (data) =>
              responses.add(jsonDecode(data as String) as Map<String, Object?>),
          onDone: responses.close,
        );

        client.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'id': 7,
            'method': 'getVersion',
            'params': <String, Object?>{},
          }),
        );

        final response = await responses.stream.first;
        expect(response['id'], 7);
        expect(response['result'], isA<Map>());
        expect(
          (response['result'] as Map)['method'],
          'getVersion',
          reason:
              'fake upstream echoes the request method into the result; '
              'a non-matching value means the frame was rewritten',
        );

        await client.close();
      },
    );

    test(
      'when the interceptor observes traffic, '
      'then it sees reloadSources requests in clientToServer direction',
      () async {
        final seen = <Map<String, Object?>>[];
        proxy.interceptor = (message, direction) {
          if (direction == Direction.clientToServer) seen.add(message);
          return const Forward();
        };

        final client = await _connectClient(proxy);
        client.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'id': 1,
            'method': 'reloadSources',
            'params': {'isolateId': 'isolates/1'},
          }),
        );

        // Wait for the request to land at upstream so we know the
        // interceptor saw it.
        await upstream.firstReceived;

        expect(seen, hasLength(1));
        expect(seen.first['method'], 'reloadSources');
        expect((seen.first['params'] as Map)['isolateId'], 'isolates/1');

        await client.close();
      },
    );

    test(
      'when the interceptor returns Respond, '
      'then the synthesized response is delivered and upstream is not hit',
      () async {
        proxy.interceptor = (message, direction) async {
          if (message['method'] == 'reloadSources') {
            return Respond({
              'jsonrpc': '2.0',
              'id': message['id'],
              'result': {'type': 'ReloadReport', 'success': true},
            });
          }
          return const Forward();
        };

        final client = await _connectClient(proxy);
        final responses = StreamController<Map<String, Object?>>();
        client.listen(
          (data) =>
              responses.add(jsonDecode(data as String) as Map<String, Object?>),
          onDone: responses.close,
        );

        client.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'id': 42,
            'method': 'reloadSources',
            'params': <String, Object?>{},
          }),
        );

        final response = await responses.stream.first;
        expect(response['id'], 42);
        expect((response['result'] as Map)['success'], isTrue);
        expect(
          upstream.received,
          isEmpty,
          reason: 'Respond must short-circuit before upstream sees the frame',
        );

        await client.close();
      },
    );

    test(
      'when the client disconnects, '
      'then the upstream connection sees the stream end',
      () async {
        final client = await _connectClient(proxy);
        await upstream.connectionAttached;

        await client.close();

        // The upstream-side stream completes when the proxy closes its
        // upstream socket in response to the downstream close.
        await upstream.streamDone.future;
      },
    );

    test(
      'when the upstream closes, '
      'then the client stream ends',
      () async {
        final client = await _connectClient(proxy);
        final clientDone = Completer<void>();
        client.listen(
          (_) {},
          onDone: clientDone.complete,
          onError: (_) {},
        );
        await upstream.connectionAttached;

        await upstream.lastSocket!.close();

        await clientDone.future;
      },
    );

    test(
      'when an HTTP GET hits a non-token path, '
      'then it is rejected with 404',
      () async {
        final base = proxy.httpUri;
        final wrong = base.replace(path: '/wrong/ws');
        final response = await HttpClient()
            .getUrl(wrong)
            .then(
              (r) => r.close(),
            );
        expect(response.statusCode, HttpStatus.notFound);
      },
    );

    test(
      'when retarget is called with a new upstream, '
      'then the published URI is stable and new connections hit the '
      'new upstream',
      () async {
        final upstream2 = await _FakeUpstream.start();
        addTearDown(upstream2.close);

        // Establish an initial pair against the original upstream.
        final client1 = await _connectClient(proxy);
        client1.listen((_) {}, onError: (_) {});
        await upstream.connectionAttached;

        final preRetargetHttpUri = proxy.httpUri;
        await proxy.retarget(upstream2.wsUri);

        // The proxy's published URI is stable across retarget so consumers
        // can simply reconnect without re-reading vm-service-info.json.
        expect(proxy.httpUri, preRetargetHttpUri);

        // A fresh connection lands on the new upstream and round-trips.
        final client2 = await _connectClient(proxy);
        addTearDown(client2.close);
        await upstream2.connectionAttached;

        final responses = StreamController<Map<String, Object?>>();
        client2.listen(
          (data) =>
              responses.add(jsonDecode(data as String) as Map<String, Object?>),
          onDone: responses.close,
        );

        client2.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'id': 99,
            'method': 'getVersion',
            'params': <String, Object?>{},
          }),
        );

        final response = await responses.stream.first;
        expect(response['id'], 99);
        expect(
          upstream2.received.first['method'],
          'getVersion',
          reason: 'post-retarget frames must reach the new upstream',
        );
      },
    );
  });
}

Future<WebSocket> _connectClient(VmServiceProxy proxy) async {
  final base = proxy.httpUri;
  final ws = base.replace(scheme: 'ws', path: '${base.path}ws');
  return WebSocket.connect(ws.toString());
}

/// A minimal upstream WS server that echoes JSON-RPC requests as responses
/// (`{id, method}` -> `{id, result: {method}}`). Tracks every received
/// frame for assertions.
class _FakeUpstream {
  final HttpServer _server;
  final List<Map<String, Object?>> received = [];
  final Completer<void> _firstReceived = Completer<void>();
  final Completer<WebSocket> _connectionAttached = Completer<WebSocket>();
  final Completer<void> streamDone = Completer<void>();
  WebSocket? lastSocket;

  _FakeUpstream._(this._server) {
    _server.listen(_handle);
  }

  static Future<_FakeUpstream> start() async {
    final server = await HttpServer.bind('127.0.0.1', 0);
    return _FakeUpstream._(server);
  }

  Uri get wsUri => Uri(
    scheme: 'ws',
    host: _server.address.host,
    port: _server.port,
    path: '/ws',
  );

  Future<void> get firstReceived => _firstReceived.future;
  Future<WebSocket> get connectionAttached => _connectionAttached.future;

  Future<void> _handle(HttpRequest req) async {
    if (!WebSocketTransformer.isUpgradeRequest(req) || req.uri.path != '/ws') {
      req.response.statusCode = HttpStatus.notFound;
      await req.response.close();
      return;
    }
    final ws = await WebSocketTransformer.upgrade(req);
    lastSocket = ws;
    if (!_connectionAttached.isCompleted) _connectionAttached.complete(ws);

    ws.listen(
      (data) {
        if (data is! String) return;
        final msg = jsonDecode(data) as Map<String, Object?>;
        received.add(msg);
        if (!_firstReceived.isCompleted) _firstReceived.complete();
        if (msg.containsKey('id') && msg['method'] is String) {
          ws.add(
            jsonEncode({
              'jsonrpc': '2.0',
              'id': msg['id'],
              'result': {'method': msg['method']},
            }),
          );
        }
      },
      onDone: () {
        if (!streamDone.isCompleted) streamDone.complete();
      },
      onError: (_) {
        if (!streamDone.isCompleted) streamDone.complete();
      },
    );
  }

  Future<void> close() async {
    await lastSocket?.close();
    await _server.close(force: true);
  }
}

import 'dart:async';
import 'dart:io';
import 'package:relic/relic.dart';

/// A function that can be called to stop the server.
typedef CloseServerCallback = Future<void> Function();

abstract class TestWebSocketServer {
  /// Starts a simple server that listens for WebSocket connections and
  /// delegates the handling of messages to the [webSocketHandler] callback.
  ///
  /// The [onConnected] callback is called with the WebSocket host address when
  /// the server is ready to accept connections.
  ///
  /// The [onRequest] callback is called with each incoming request's URL,
  /// before the WebSocket upgrade.
  ///
  /// Returns a function that can be called to stop the server.
  static Future<CloseServerCallback> startServer({
    required void Function(RelicWebSocket webSocket) webSocketHandler,
    void Function(Uri webSocketHost)? onConnected,
    void Function(Uri requestUrl)? onRequest,
  }) async {
    var server = await _startServer(
      onConnected,
      webSocketHandler,
      onRequest,
    );

    return server.close;
  }

  static Future<RelicServer> _startServer(
    void Function(Uri webSocketHost)? onConnected,
    void Function(RelicWebSocket webSocket) webSocketHandler,
    void Function(Uri requestUrl)? onRequest,
  ) async {
    FutureOr<Result> requestHandler(Request req) async {
      onRequest?.call(req.url);
      return WebSocketUpgrade(webSocketHandler);
    }

    final server = RelicServer(
      () => IOAdapter.bind(
        InternetAddress.loopbackIPv4,
        port: 0, // Pick an available port
      ),
    );
    await server.mountAndStart(requestHandler);

    var webSocketHost = Uri.parse(
      'ws://${InternetAddress.loopbackIPv4.host}:${server.port}',
    );
    onConnected?.call(webSocketHost);

    return server;
  }
}

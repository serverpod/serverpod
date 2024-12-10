import 'dart:async';
import 'dart:io';

/// A function that can be called to stop the server.
typedef CloseServerCallback = Future<void> Function();

abstract class TestWebSocketServer {
  /// Starts a simple server that listens for WebSocket connections and
  /// delegates the handling of messages to the [webSocketHandler] callback.
  ///
  /// The [onConnected] callback is called with the WebSocket host address when
  /// the server is ready to accept connections.
  ///
  /// Returns a function that can be called to stop the server.
  static Future<CloseServerCallback> startServer({
    required void Function(WebSocket webSocket) webSocketHandler,
    void Function(Uri webSocketHost)? onConnected,
  }) async {
    var server = await _startServer(
      onConnected,
      webSocketHandler,
    );

    return server.close;
  }

  static Future<HttpServer> _startServer(
    void Function(Uri webSocketHost)? onConnected,
    void Function(WebSocket webSocket) webSocketHandler,
  ) async {
    var server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0 /* Pick an available port */,
    );

    var webSocketHost = Uri.http('${server.address.host}:${server.port}');
    webSocketHost = webSocketHost.replace(scheme: 'ws');
    onConnected?.call(webSocketHost);

    unawaited(
      _listenForMessages(
        server: server,
        webSocketHandler: webSocketHandler,
      ),
    );

    return server;
  }

  static Future<void> _listenForMessages({
    required HttpServer server,
    required void Function(WebSocket webSocket) webSocketHandler,
  }) async {
    await for (var request in server) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        await WebSocketTransformer.upgrade(request).then(webSocketHandler);
      } else {
        var response = request.response;
        response.statusCode = HttpStatus.upgradeRequired;
        await response.close();
      }
    }
  }
}

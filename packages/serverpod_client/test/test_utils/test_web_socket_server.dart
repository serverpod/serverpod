import 'dart:async';
import 'dart:io';
import 'package:relic/relic.dart';
import 'package:relic/io_adapter.dart';

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
    required void Function(RelicWebSocket webSocket) webSocketHandler,
    void Function(Uri webSocketHost)? onConnected,
  }) async {
    var server = await _startServer(
      onConnected,
      webSocketHandler,
    );

    return server.close;
  }

  static Future<RelicServer> _startServer(
    void Function(Uri webSocketHost)? onConnected,
    void Function(RelicWebSocket webSocket) webSocketHandler,
  ) async {
    FutureOr<HandledContext> requestHandler(NewContext context) async {
      return context.connect(webSocketHandler);
    }

    var server = await serve(
      requestHandler,
      InternetAddress.loopbackIPv4,
      0, // Pick an available port
    );

    var webSocketHost = Uri.parse(
        'ws://${InternetAddress.loopbackIPv4.host}:${server.adapter.port}');
    onConnected?.call(webSocketHost);

    return server;
  }
}

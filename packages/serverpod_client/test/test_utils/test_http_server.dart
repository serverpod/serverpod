import 'dart:async';
import 'dart:io';

import 'package:relic/relic.dart';
import 'package:relic/io_adapter.dart';

/// A function that can be called to stop the server.
typedef CloseServerCallback = Future<void> Function();

/// A function that handles HTTP requests and returns a response.
/// The function receives the request body and authentication header value,
/// and should return the response body as a string.
/// If an exception should be thrown, the function should throw it.
typedef HttpRequestHandler = Future<Response> Function(Request request);

abstract class TestHttpServer {
  /// Starts a simple HTTP server that listens for HTTP POST requests and
  /// delegates the handling of requests to the [httpRequestHandler] callback.
  ///
  /// The [onConnected] callback is called with the HTTP host address when
  /// the server is ready to accept connections.
  ///
  /// Returns a function that can be called to stop the server.
  static Future<CloseServerCallback> startServer({
    required HttpRequestHandler httpRequestHandler,
    void Function(Uri httpHost)? onConnected,
  }) async {
    var server = await _startServer(
      onConnected,
      httpRequestHandler,
    );

    return server.close;
  }

  static Future<RelicServer> _startServer(
    void Function(Uri httpHost)? onConnected,
    HttpRequestHandler httpRequestHandler,
  ) async {
    FutureOr<HandledContext> requestHandler(NewContext context) async {
      return context.withResponse(await httpRequestHandler(context.request));
    }

    final adapter = IOAdapter(await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0, // Pick an available port
    ));
    final server = RelicServer(
      adapter,
    );
    await server.mountAndStart(requestHandler);

    final httpHost = Uri.parse(
        'http://${InternetAddress.loopbackIPv4.host}:${adapter.port}');
    onConnected?.call(httpHost);

    return server;
  }
}

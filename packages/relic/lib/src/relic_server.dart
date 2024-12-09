import 'dart:async';
import 'dart:io';

import 'package:relic/src/body/body.dart';
import 'package:relic/src/hijack/exception/hijack_exception.dart';
import 'package:relic/src/headers/exception/invalid_header_exception.dart';
import 'package:relic/src/logger/logger.dart';
import 'package:relic/src/message/request.dart';
import 'package:relic/src/message/response.dart';
import 'package:relic/src/util/util.dart';

import 'handler/handler.dart';

/// A [Server] backed by a `dart:io` [HttpServer].
class RelicServer {
  /// The default powered by header to use for responses.
  static const String defaultPoweredByHeader = 'Relic';

  /// The underlying [HttpServer].
  final HttpServer server;

  /// Whether to enforce strict header parsing.
  final bool strictHeaders;

  /// Whether [mountAndStart] has been called.
  Handler? _handler;

  /// The powered by header to use for responses.
  final String poweredByHeader;

  Uri get url {
    if (server.address.isLoopback) {
      return Uri(scheme: 'http', host: 'localhost', port: server.port);
    }

    if (server.address.type == InternetAddressType.IPv6) {
      return Uri(
        scheme: 'http',
        host: '[${server.address.address}]',
        port: server.port,
      );
    }

    return Uri(
      scheme: 'http',
      host: server.address.address,
      port: server.port,
    );
  }

  /// Creates a server with the given parameters.
  static Future<RelicServer> createServer(
    Object address,
    int port, {
    SecurityContext? securityContext,
    int? backlog,
    bool shared = false,
    bool strictHeaders = true,
    String? poweredByHeader,
  }) async {
    backlog ??= 0;
    var server = switch (securityContext == null) {
      true => await HttpServer.bind(
          address,
          port,
          backlog: backlog,
          shared: shared,
        ),
      false => await HttpServer.bindSecure(
          address,
          port,
          securityContext!,
          backlog: backlog,
          shared: shared,
        ),
    };
    return RelicServer._(
      server,
      strictHeaders: strictHeaders,
      poweredByHeader: poweredByHeader ?? defaultPoweredByHeader,
    );
  }

  /// Mounts a handler to the server. Only one handler can be mounted at a time,
  /// and starts listening for requests.
  void mountAndStart(
    Handler handler,
  ) {
    if (_handler != null) {
      throw StateError(
        "Relic server already has a handler mounted.",
      );
    }
    _handler = handler;
    _startListening();
  }

  Future<void> close() => server.close();

  /// Creates a server with the given parameters.
  RelicServer._(
    this.server, {
    required this.strictHeaders,
    required this.poweredByHeader,
  });

  /// Starts listening for requests.
  void _startListening() {
    catchTopLevelErrors(() {
      server.listen(_handleRequest);
    }, (error, stackTrace) {
      logMessage(
        'Asynchronous error\n$error',
        stackTrace: stackTrace,
        type: LoggerType.error,
      );
    });
  }

  /// Handles incoming HTTP requests, passing them to the handler.
  Future<void> _handleRequest(HttpRequest request) async {
    var handler = _handler;
    if (handler == null) {
      throw StateError(
        "No handler mounted. Ensure the server has a handler before handling requests.",
      );
    }

    Request relicRequest;
    try {
      relicRequest = Request.fromHttpRequest(
        request,
        strictHeaders: strictHeaders,
        poweredByHeader: poweredByHeader,
      );
    } catch (error, stackTrace) {
      logMessage(
        'Error parsing request.\n$error',
        stackTrace: stackTrace,
      );

      Response errorResponse;
      // If the error is an [InvalidHeaderException], respond with a 400 Bad Request status.
      if (error is InvalidHeaderException) {
        errorResponse = Response.badRequest(
          body: Body.fromString(error.toString()),
        );
      } else
      // If the error is an [ArgumentError] with the name 'method' or 'requestedUri',
      // respond with a 400 Bad Request status.
      if (error is ArgumentError &&
          (error.name == 'method' || error.name == 'requestedUri')) {
        errorResponse = Response.badRequest();
      } else {
        errorResponse = Response.internalServerError();
      }

      // Write the response to the HTTP response.
      await errorResponse.writeHttpResponse(
        request.response,
      );
      return;
    }

    Response? response;
    try {
      response = await handler(relicRequest);

      // If the response doesn't have a powered by header, add the default one.
      if (response.headers.xPoweredBy == null) {
        response = response.copyWith(
          headers: response.headers.copyWith(
            xPoweredBy: poweredByHeader,
          ),
        );
      }
    } on HijackException catch (error, stackTrace) {
      // If the request is already hijacked, meaning it's being handled by
      // another handler, like a websocket, then don't respond with an error.
      if (!relicRequest.canHijack) return;

      _logError(
        relicRequest,
        "Caught HijackException, but the request wasn't hijacked.",
        stackTrace,
      );
      response = Response.internalServerError();
    } catch (error, stackTrace) {
      _logError(
        relicRequest,
        'Error thrown by handler.\n$error',
        stackTrace,
      );
      response = Response.internalServerError();
    }

    // If the the request is already hijacked, meaning it's being handled by
    // another handler, like a websocket, then respond with a 501 Not Implemented status.
    // This should never happen, but if it does, we don't want to respond with an error.
    if (!relicRequest.canHijack) {
      response = Response.notImplemented();
    }

    await response.writeHttpResponse(request.response);
  }
}

void _logError(Request request, String message, StackTrace stackTrace) {
  var buffer = StringBuffer();
  buffer.write('${request.method} ${request.requestedUri.path}');
  if (request.requestedUri.query.isNotEmpty) {
    buffer.write('?${request.requestedUri.query}');
  }
  buffer.writeln();
  buffer.write(message);

  logMessage(
    buffer.toString(),
    stackTrace: stackTrace,
    type: LoggerType.error,
  );
}

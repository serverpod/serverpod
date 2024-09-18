// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:relic/src/exception/hijack_exception.dart';
import 'package:relic/src/request.dart';
import 'package:relic/src/response.dart';
import 'package:relic/src/util/util.dart';
import 'package:stack_trace/stack_trace.dart';

import 'handler/handler.dart';

/// A [Server] backed by a `dart:io` [HttpServer].
class RelicServer {
  /// The underlying [HttpServer].
  final HttpServer server;

  /// Whether [mount] has been called.
  Handler? _handler;

  Uri get url {
    if (server.address.isLoopback) {
      return Uri(scheme: 'http', host: 'localhost', port: server.port);
    }

    // IPv6 addresses in URLs need to be enclosed in square brackets to avoid
    // URL ambiguity with the ":" in the address.
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

  /// Calls [HttpServer.bind] and wraps the result in an [RelicServer].
  static Future<RelicServer> bind(
    Object address,
    int port, {
    int? backlog,
    bool shared = false,
  }) async {
    backlog ??= 0;
    var server = await HttpServer.bind(
      address,
      port,
      backlog: backlog,
      shared: shared,
    );
    return RelicServer._(server);
  }

  /// Calls [HttpServer.bindSecure] and wraps the result in an [RelicServer].
  static Future<RelicServer> bindSecure(
    Object address,
    int port,
    SecurityContext securityContext, {
    int? backlog,
    bool shared = false,
  }) async {
    backlog ??= 0;
    var server = await HttpServer.bindSecure(
      address,
      port,
      securityContext,
      backlog: backlog,
      shared: shared,
    );
    return RelicServer._(server);
  }
  

  RelicServer._(this.server);

  /// Mounts a handler to the server. Only one handler can be mounted at a time.
  void mount(
    Handler handler, {
    String? poweredByHeader = 'Dart with package:relic_server',
  }) {
    if (_handler != null) {
      throw StateError("Can't mount two handlers for the same server.");
    }
    _handler = handler;
    _serveRequests(poweredByHeader: poweredByHeader);
  }

  Future<void> close() => server.close();

  void _serveRequests({
    required String? poweredByHeader,
  }) {
    catchTopLevelErrors(() {
      server.listen(
        (request) => _handleRequest(
          request,
          poweredByHeader: poweredByHeader,
        ),
      );
    }, (error, stackTrace) {
      _logTopLevelError(
        'Asynchronous error\n$error',
        stackTrace,
      );
    });
  }

  /// Handles incoming HTTP requests, passing them to the handler.
  Future<void> _handleRequest(
    HttpRequest request, {
    required String? poweredByHeader,
  }) async {
    var handler = _handler;
    if (handler == null) {
      throw StateError(
        "No handler mounted. Ensure the server has a handler before handling requests.",
      );
    }

    Request relicRequest;
    try {
      relicRequest = Request.fromHttpRequest(request);
    } catch (error, stackTrace) {
      _logTopLevelError('Error parsing request.\n$error', stackTrace);

      var response = (error is ArgumentError &&
              (error.name == 'method' || error.name == 'requestedUri'))
          ? Response.badRequest()
          : Response.internalServerError();

      await response.writeHttpResponse(
        request.response,
        poweredByHeader: poweredByHeader,
      );
      return;
    }

    Response? response;
    try {
      response = await handler(relicRequest);
    } on HijackException catch (error, stackTrace) {
      // A HijackException should bypass the response-writing logic entirely.
      if (!relicRequest.canHijack) return;
      // If the request wasn't hijacked, we shouldn't be seeing this exception.
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
      return;
    }

    if (relicRequest.canHijack) {
      await response.writeHttpResponse(
        request.response,
        poweredByHeader: poweredByHeader,
      );
      return;
    }

    var message = StringBuffer()
      ..writeln('Got a response for hijacked request '
          '${relicRequest.method} ${relicRequest.requestedUri}:')
      ..writeln(response.statusCode)
      ..writeln(response.headers);
    throw Exception(message.toString().trim());
  }
}

void _logError(
  Request request,
  String message,
  StackTrace stackTrace,
) {
  // Add information about the request itself.
  var buffer = StringBuffer();
  buffer.write('${request.method} ${request.requestedUri.path}');
  if (request.requestedUri.query.isNotEmpty) {
    buffer.write('?${request.requestedUri.query}');
  }
  buffer.writeln();
  buffer.write(message);

  _logTopLevelError(buffer.toString(), stackTrace);
}

void _logTopLevelError(String message, StackTrace stackTrace) {
  final chain = Chain.forTrace(stackTrace)
      .foldFrames((frame) => frame.isCore || frame.package == 'relic_server')
      .terse;

  stderr.writeln('ERROR - ${DateTime.now()}');
  stderr.writeln(message);
  stderr.writeln(chain);
}

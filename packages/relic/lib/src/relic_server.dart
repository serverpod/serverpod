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
import 'server/server.dart';

part './server/logger.dart';

/// A [Server] backed by a `dart:io` [HttpServer].
class RelicServer implements Server {
  /// The underlying [HttpServer].
  final HttpServer server;

  /// Whether [mount] has been called.
  Handler? _handler;

  @override
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

  /// Calls [HttpServer.bind] and wraps the result in an [RelicServer].
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

  @override
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

  @override
  Future<void> close() => server.close();

  /// Serve a [Stream] of [HttpRequest]s.
  ///
  /// [HttpServer] implements [Stream<HttpRequest>] so it can be passed directly
  /// to [_serveRequests].
  ///
  /// Errors thrown by [handler] while serving a request will be printed to the
  /// console and cause a 500 response with no body. Errors thrown asynchronously
  /// by [handler] will be printed to the console or, if there's an active error
  /// zone, passed to that zone.
  ///
  /// {@macro relic_server_header_defaults}
  void _serveRequests({
    required String? poweredByHeader,
  }) {
    catchTopLevelErrors(() {
      server.listen((request) =>
          _handleRequest(request, poweredByHeader: poweredByHeader));
    }, (error, stackTrace) {
      _logTopLevelError('Asynchronous error\n$error', stackTrace);
    });
  }

  /// Uses [handler] to handle [request].
  ///
  /// Returns a [Future] which completes when the request has been handled.
  ///
  /// {@macro relic_server_header_defaults}
  Future<void> _handleRequest(
    HttpRequest request, {
    required String? poweredByHeader,
  }) async {
    var handler = _handler;
    if (handler == null) return;

    Request relicRequest;
    try {
      relicRequest = Request.fromHttpRequest(request);
      // ignore: avoid_catching_errors
    } on ArgumentError catch (error, stackTrace) {
      if (error.name == 'method' || error.name == 'requestedUri') {
        _logTopLevelError('Error parsing request.\n$error', stackTrace);
        final response = Response.badRequest();
        await response.writeHttpResponse(
          request.response,
          poweredByHeader: poweredByHeader,
        );
      } else {
        _logTopLevelError('Error parsing request.\n$error', stackTrace);
        final response = Response.internalServerError();
        await response.writeHttpResponse(
          request.response,
          poweredByHeader: poweredByHeader,
        );
      }
      return;
    } catch (error, stackTrace) {
      _logTopLevelError('Error parsing request.\n$error', stackTrace);
      final response = Response.internalServerError();
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
      await response.writeHttpResponse(
        request.response,
        poweredByHeader: poweredByHeader,
      );
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

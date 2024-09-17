// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A Relic Server adapter for handling [HttpRequest] objects from `dart:io`'s
/// [HttpServer].
///
/// One can provide an instance of [HttpServer] as the `requests` parameter in
/// [serveRequests].
///
/// This adapter supports request hijacking; see [Request.hijack].
///
/// [Request]s passed to a [Handler] will contain the [Request.context] key
/// `"relic.server.connection_info"` containing the [HttpConnectionInfo] object from
/// the underlying [HttpRequest].
///
/// When creating [Response] instances for this adapter, you can set the
/// `"relic.server.buffer_output"` key in [Response.context]. If `true`,
/// (the default), streamed responses will be buffered to improve performance.
/// If `false`, all chunks will be pushed over the wire as they're received.
/// See [HttpResponse.bufferOutput] for more information.
library;

import 'dart:async';
import 'dart:io' as io;

import 'package:stack_trace/stack_trace.dart';

import 'relic.dart';
import 'src/util/util.dart';

export 'src/io_server.dart' show RelicServer;

/// Starts an [HttpServer] that listens on the specified [address] and
/// [port] and sends requests to [handler].
///
/// If a [securityContext] is provided an HTTPS server will be started.
///
/// See the documentation for [HttpServer.bind] and [HttpServer.bindSecure]
/// for more details on [address], [port], [backlog], and [shared].
///
/// {@template relic_server_header_defaults}
/// Every response will get a "date" header and an "X-Powered-By" header.
/// If the either header is present in the `Response`, it will not be
/// overwritten.
/// Pass [poweredByHeader] to set the default content for "X-Powered-By",
/// pass `null` to omit this header.
/// {@endtemplate}
Future<io.HttpServer> serve(
  Handler handler,
  Object address,
  int port, {
  io.SecurityContext? securityContext,
  int? backlog,
  bool shared = false,
  String? poweredByHeader = 'Dart with package:relic_server',
}) async {
  backlog ??= 0;
  var server = await (securityContext == null
      ? io.HttpServer.bind(address, port, backlog: backlog, shared: shared)
      : io.HttpServer.bindSecure(
          address,
          port,
          securityContext,
          backlog: backlog,
          shared: shared,
        ));
  serveRequests(server, handler, poweredByHeader: poweredByHeader);
  return server;
}

/// Serve a [Stream] of [HttpRequest]s.
///
/// [HttpServer] implements [Stream<HttpRequest>] so it can be passed directly
/// to [serveRequests].
///
/// Errors thrown by [handler] while serving a request will be printed to the
/// console and cause a 500 response with no body. Errors thrown asynchronously
/// by [handler] will be printed to the console or, if there's an active error
/// zone, passed to that zone.
///
/// {@macro relic_server_header_defaults}
void serveRequests(
  Stream<io.HttpRequest> requests,
  Handler handler, {
  String? poweredByHeader = 'Dart with package:relic_server',
}) {
  catchTopLevelErrors(() {
    requests.listen((request) =>
        handleRequest(request, handler, poweredByHeader: poweredByHeader));
  }, (error, stackTrace) {
    _logTopLevelError('Asynchronous error\n$error', stackTrace);
  });
}

/// Uses [handler] to handle [request].
///
/// Returns a [Future] which completes when the request has been handled.
///
/// {@macro relic_server_header_defaults}
Future<void> handleRequest(
  io.HttpRequest request,
  Handler handler, {
  String? poweredByHeader = 'Dart with package:relic_server',
}) async {
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
    response = _logError(
      relicRequest,
      "Caught HijackException, but the request wasn't hijacked.",
      stackTrace,
    );
  } catch (error, stackTrace) {
    response = _logError(
      relicRequest,
      'Error thrown by handler.\n$error',
      stackTrace,
    );
  }

  if ((response as dynamic) == null) {
    _logError(
      relicRequest,
      'null response from handler.',
      StackTrace.current,
    ).writeHttpResponse(
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

Response _logError(Request request, String message, StackTrace stackTrace) {
  // Add information about the request itself.
  var buffer = StringBuffer();
  buffer.write('${request.method} ${request.requestedUri.path}');
  if (request.requestedUri.query.isNotEmpty) {
    buffer.write('?${request.requestedUri.query}');
  }
  buffer.writeln();
  buffer.write(message);

  _logTopLevelError(buffer.toString(), stackTrace);
  return Response.internalServerError();
}

void _logTopLevelError(String message, StackTrace stackTrace) {
  final chain = Chain.forTrace(stackTrace)
      .foldFrames((frame) => frame.isCore || frame.package == 'relic_server')
      .terse;

  io.stderr.writeln('ERROR - ${DateTime.now()}');
  io.stderr.writeln(message);
  io.stderr.writeln(chain);
}

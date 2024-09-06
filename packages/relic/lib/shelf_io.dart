// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A Shelf adapter for handling [HttpRequest] objects from `dart:io`'s
/// [HttpServer].
///
/// One can provide an instance of [HttpServer] as the `requests` parameter in
/// [serveRequests].
///
/// This adapter supports request hijacking; see [Request.hijack].
///
/// [Request]s passed to a [Handler] will contain the [Request.context] key
/// `"shelf.io.connection_info"` containing the [HttpConnectionInfo] object from
/// the underlying [HttpRequest].
///
/// When creating [Response] instances for this adapter, you can set the
/// `"shelf.io.buffer_output"` key in [Response.context]. If `true`,
/// (the default), streamed responses will be buffered to improve performance.
/// If `false`, all chunks will be pushed over the wire as they're received.
/// See [HttpResponse.bufferOutput] for more information.
library;

import 'dart:async';
import 'dart:io' as io;

import 'package:stack_trace/stack_trace.dart';

import 'relic.dart';
import 'src/util/util.dart';

export 'src/io_server.dart' show IOServer;

/// Starts an [HttpServer] that listens on the specified [address] and
/// [port] and sends requests to [handler].
///
/// If a [securityContext] is provided an HTTPS server will be started.
///
/// See the documentation for [HttpServer.bind] and [HttpServer.bindSecure]
/// for more details on [address], [port], [backlog], and [shared].
///
/// {@template shelf_io_header_defaults}
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
  String? poweredByHeader = 'Dart with package:shelf',
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
/// {@macro shelf_io_header_defaults}
void serveRequests(
  Stream<io.HttpRequest> requests,
  Handler handler, {
  String? poweredByHeader = 'Dart with package:shelf',
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
/// {@macro shelf_io_header_defaults}
Future<void> handleRequest(
  io.HttpRequest request,
  Handler handler, {
  String? poweredByHeader = 'Dart with package:shelf',
}) async {
  Request shelfRequest;
  try {
    shelfRequest = Request.fromHttpRequest(request);
    // ignore: avoid_catching_errors
  } on ArgumentError catch (error, stackTrace) {
    if (error.name == 'method' || error.name == 'requestedUri') {
      // TODO: use a reduced log level when using package:logging
      _logTopLevelError('Error parsing request.\n$error', stackTrace);
      final response = Response.badRequest();
      await response.writeHttpResponse(request.response, poweredByHeader);
    } else {
      _logTopLevelError('Error parsing request.\n$error', stackTrace);
      final response = Response.internalServerError();
      await response.writeHttpResponse(request.response, poweredByHeader);
    }
    return;
  } catch (error, stackTrace) {
    _logTopLevelError('Error parsing request.\n$error', stackTrace);
    final response = Response.internalServerError();
    await response.writeHttpResponse(request.response, poweredByHeader);
    return;
  }

  // TODO(nweiz): abstract out hijack handling to make it easier to implement an
  // adapter.
  Response? response;
  try {
    response = await handler(shelfRequest);
  } on HijackException catch (error, stackTrace) {
    // A HijackException should bypass the response-writing logic entirely.
    if (!shelfRequest.canHijack) return;

    // If the request wasn't hijacked, we shouldn't be seeing this exception.
    response = _logError(
      shelfRequest,
      "Caught HijackException, but the request wasn't hijacked.",
      stackTrace,
    );
  } catch (error, stackTrace) {
    response = _logError(
      shelfRequest,
      'Error thrown by handler.\n$error',
      stackTrace,
    );
  }

  if ((response as dynamic) == null) {
    _logError(
      shelfRequest,
      'null response from handler.',
      StackTrace.current,
    ).writeHttpResponse(
      request.response,
      poweredByHeader,
    );
    return;
  }
  if (shelfRequest.canHijack) {
    await response.writeHttpResponse(request.response, poweredByHeader);
    return;
  }

  var message = StringBuffer()
    ..writeln('Got a response for hijacked request '
        '${shelfRequest.method} ${shelfRequest.requestedUri}:')
    ..writeln(response.statusCode)
    ..writeln(response.headers);
  throw Exception(message.toString().trim());
}

// TODO(kevmoo) A developer mode is needed to include error info in response
// TODO(kevmoo) Make error output plugable. stderr, logging, etc
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
      .foldFrames((frame) => frame.isCore || frame.package == 'shelf')
      .terse;

  io.stderr.writeln('ERROR - ${DateTime.now()}');
  io.stderr.writeln(message);
  io.stderr.writeln(chain);
}

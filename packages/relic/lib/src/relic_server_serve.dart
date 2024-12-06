/// A Relic Server adapter for handling [HttpRequest] objects from `dart:io`'s
/// [HttpServer].
///
/// One can provide an instance of [HttpServer] as the `requests` parameter in
/// [_serveRequests].
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

import 'package:relic/src/relic_server.dart';

import 'handler/handler.dart';
import 'message/request.dart';
import 'message/response.dart';

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
  bool strictHeaders = false,
  String? poweredByHeader,
}) async {
  backlog ??= 0;

  var server = await RelicServer.createServer(
    address,
    port,
    securityContext: securityContext,
    backlog: backlog,
    shared: shared,
    strictHeaders: strictHeaders,
    poweredByHeader: poweredByHeader,
  );

  server.mountAndStart(handler);
  return server.server;
}

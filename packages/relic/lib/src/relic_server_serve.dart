// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
import 'request.dart';
import 'response.dart';

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

  var server = await switch (securityContext == null) {
    true => RelicServer.bind(
        address,
        port,
        backlog: backlog,
        shared: shared,
      ),
    false => RelicServer.bindSecure(
        address,
        port,
        securityContext!,
        backlog: backlog,
        shared: shared,
      ),
  };
  server.mount(handler, poweredByHeader: poweredByHeader);
  return server.server;
}

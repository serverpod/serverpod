import 'dart:io';

import 'package:serverpod/serverpod.dart';

import 'package:middleware_server/src/web/routes/root.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';
import 'src/middleware/logging_middleware.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Setup a default page at the web root.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
  // Serve all files in the web/static relative directory under /.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));

  // ## Verbose Mode
  //
  // To enable verbose mode to log request and response headers:
  //
  // ```dart
  // pod.server.addMiddleware(loggingMiddleware(verbose: true));
  // ```
  //
  // ## Custom Logger
  //
  // Provide a custom logger function to integrate with your logging system:
  //
  // ```dart
  // pod.server.addMiddleware(
  //   loggingMiddleware(
  //     logger: (message) => myCustomLogger.info(message),
  //     errorLogger: (message) => myCustomLogger.error(message),
  //   ),
  // );
  // ```
  //
  // If only [logger] is provided, errors will also use that logger.
  // If [errorLogger] is provided, errors will use it instead of [logger].
  // If neither is provided, normal logs go to stdout and errors go to stderr.
  //
  pod.server.addMiddleware(loggingMiddleware(verbose: true));

  // Start the server.
  await pod.start();
}

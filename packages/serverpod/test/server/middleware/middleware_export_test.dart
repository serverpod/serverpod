// ignore_for_file: unused_local_variable, prefer_function_declarations_over_variables

import 'package:serverpod/serverpod.dart';

/// Compile-time verification that middleware-related types are properly
/// exported from the serverpod.dart public API.
///
/// This file contains no runtime tests. If any referenced type or function
/// is not exported, this file will fail to compile, which is the test.
void main() {
  // Relic middleware types
  Middleware middleware = (Handler innerHandler) {
    return (Request req) async => await innerHandler(req);
  };

  Handler handler = (Request req) async => Response.ok();

  const pipeline = Pipeline();

  final createdMiddleware = createMiddleware(
    onRequest: (Request request) => null,
  );

  // Serverpod middleware implementations
  final logging = loggingMiddleware();
  final verboseLogging = loggingMiddleware(verbose: true);
  final customLogging = loggingMiddleware(
    logger: (message) {},
  );

  // Complete workflow verification
  final composedPipeline = const Pipeline()
      .addMiddleware(loggingMiddleware())
      .addMiddleware(createMiddleware(onRequest: (req) => null));
}

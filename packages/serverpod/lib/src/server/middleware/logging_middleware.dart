import 'dart:io' as io;

import 'package:relic/relic.dart';

/// Creates a logging middleware that logs HTTP requests and responses.
///
/// This middleware logs information about each HTTP request including:
/// - Request method and URI
/// - Response status code
/// - Request duration
/// - Request and response headers (when verbose mode is enabled)
///
/// The middleware logs to stdout by default, but accepts an optional
/// [logger] function for custom logging implementations.
///
/// ## Basic Usage
///
/// ```dart
/// void run(List<String> args) async {
///   final pod = Serverpod(
///     args,
///     Protocol(),
///     Endpoints(),
///   );
///
///   // Add middleware before starting
///   pod.server.addMiddleware(loggingMiddleware());
///
///   await pod.start();
/// }
/// ```
///
/// ## Verbose Mode
///
/// Enable verbose mode to log request and response headers:
///
/// ```dart
/// pod.server.addMiddleware(loggingMiddleware(verbose: true));
/// ```
///
/// ## Custom Logger
///
/// Provide a custom logger function to integrate with your logging system:
///
/// ```dart
/// pod.server.addMiddleware(
///   loggingMiddleware(
///     logger: (message) => myCustomLogger.info(message),
///     errorLogger: (message) => myCustomLogger.error(message),
///   ),
/// );
/// ```
///
/// If only [logger] is provided, errors will also use that logger.
/// If [errorLogger] is provided, errors will use it instead of [logger].
/// If neither is provided, normal logs go to stdout and errors go to stderr.
///
/// ## Output Format
///
/// Normal mode:
/// ```
/// 2025-10-30 12:34:56.789Z GET /api/users - 200 (125ms)
/// ```
///
/// Verbose mode:
/// ```
/// 2025-10-30 12:34:56.789Z GET /api/users
/// Request headers: {content-type: application/json, ...}
/// Response: 200 (125ms)
/// Response headers: {content-type: application/json, ...}
/// ```
///
/// ## Error Handling
///
/// Errors that occur during request processing are logged and re-thrown to
/// maintain the error propagation chain. Error logging follows the same
/// routing as normal logs:
/// - If [errorLogger] is provided, errors use it
/// - Otherwise, if [logger] is provided, errors use it
/// - Otherwise, errors go to stderr (default behavior)
///
/// ## See Also
///
/// - [Middleware] - The relic middleware type
/// - [Pipeline] - For composing multiple middleware
/// - [Server.addMiddleware] - How to register middleware
Middleware loggingMiddleware({
  bool verbose = false,
  void Function(String)? logger,
  void Function(String)? errorLogger,
}) {
  final log = logger ?? (String message) => io.stdout.writeln(message);
  // Use errorLogger if provided, otherwise fall back to logger, then stderr
  final logError =
      errorLogger ?? logger ?? (String message) => io.stderr.writeln(message);

  return (Handler innerHandler) {
    return (Request req) async {
      // Capture wall-clock time for display (once)
      final wallClockTime = DateTime.now().toUtc();
      // Use monotonic stopwatch for accurate duration measurement
      final stopwatch = Stopwatch()..start();

      final method = req.method;
      final uri = req.requestedUri;

      if (verbose) {
        log('$wallClockTime ${method.value} $uri');
        log('Request headers: ${req.headers}');
      }

      try {
        final result = await innerHandler(req);

        stopwatch.stop();
        final durationMs = stopwatch.elapsedMilliseconds;

        if (result is Response) {
          final statusCode = result.statusCode;

          if (verbose) {
            log('Response: $statusCode (${durationMs}ms)');
            log('Response headers: ${result.headers}');
          } else {
            log(
              '$wallClockTime ${method.value} $uri - $statusCode (${durationMs}ms)',
            );
          }
        } else {
          // Result is not a response (might be a redirect or other result type)
          if (verbose) {
            log('Response: non-response result (${durationMs}ms)');
          } else {
            log(
              '$wallClockTime ${method.value} $uri - non-response (${durationMs}ms)',
            );
          }
        }

        return result;
      } catch (e, stackTrace) {
        stopwatch.stop();
        final durationMs = stopwatch.elapsedMilliseconds;

        logError(
          '$wallClockTime ERROR: ${method.value} $uri (${durationMs}ms)',
        );
        logError('$wallClockTime ERROR: $e');
        logError('$stackTrace');

        rethrow;
      }
    };
  };
}

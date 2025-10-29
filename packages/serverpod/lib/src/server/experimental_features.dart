import 'package:relic/relic.dart';

import 'diagnostic_events/event_handler.dart';

/// Setup of experimental features.
///
/// Experimental features are not yet stable and may change or be removed.
class ExperimentalFeatures {
  /// List of [DiagnosticEventHandler] that will be called for all diagnostic events.
  final List<DiagnosticEventHandler>? diagnosticEventHandlers;

  /// List of [Middleware] to process HTTP requests.
  ///
  /// Middleware is executed in the order it appears in this list using
  /// relic's [Pipeline]. Each middleware can intercept, modify, or
  /// short-circuit requests before they reach the core handler.
  ///
  /// **Note**: This is an experimental feature and the API may change in
  /// future versions. Middleware uses relic's native [Middleware] typedef
  /// which wraps handlers to add functionality.
  ///
  /// **WebSocket Bypass**: WebSocket upgrade requests (`/websocket`,
  /// `/v1/websocket`) bypass middleware entirely as they require direct
  /// access to the connection upgrade mechanism.
  ///
  /// ## Example Usage
  ///
  /// ```dart
  /// // Create middleware before Serverpod instance
  /// final metrics = HttpMetrics();
  /// final middleware = [
  ///   loggingMiddleware(logger: (msg) => print(msg)),
  ///   metricsMiddleware(metrics),
  /// ];
  ///
  /// final pod = await Serverpod(
  ///   args,
  ///   serializationManager,
  ///   endpoints,
  ///   experimentalFeatures: ExperimentalFeatures(
  ///     middleware: middleware,
  ///   ),
  /// );
  /// ```
  ///
  /// ## Creating Custom Middleware
  ///
  /// ### Using Handler wrapping
  /// ```dart
  /// Middleware myMiddleware(Handler innerHandler) {
  ///   return (RequestContext ctx) async {
  ///     // Pre-processing
  ///     final request = ctx.request;
  ///     print('Before: ${request.method}');
  ///
  ///     // Call next handler
  ///     final result = await innerHandler(ctx);
  ///
  ///     // Post-processing
  ///     if (result is ResponseContext) {
  ///       print('After: ${result.response.statusCode}');
  ///     }
  ///
  ///     return result;
  ///   };
  /// }
  /// ```
  ///
  /// See also:
  /// - [Middleware] - Relic's middleware typedef
  final List<Middleware>? middleware;

  /// Creates a new [ExperimentalFeatures] instance.
  ExperimentalFeatures({
    this.diagnosticEventHandlers,
    this.middleware,
  });
}

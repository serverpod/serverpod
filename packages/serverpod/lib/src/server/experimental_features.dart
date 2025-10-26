import 'diagnostic_events/event_handler.dart';
import 'middleware/middleware.dart';

/// Setup of experimental features.
///
/// Experimental features are not yet stable and may change or be removed.
class ExperimentalFeatures {
  /// List of [DiagnosticEventHandler] that will be called for all diagnostic events.
  final List<DiagnosticEventHandler>? diagnosticEventHandlers;

  /// List of [HttpMiddleware] to process HTTP requests.
  ///
  /// Middleware is executed in the order it appears in this list, before
  /// existing hooks like [AuthenticationHandler]. Each middleware can
  /// intercept, modify, or short-circuit requests.
  ///
  /// **Experimental**: This feature is experimental and may change in future
  /// versions. The API is subject to breaking changes as we gather feedback.
  ///
  /// ## Execution Order
  ///
  /// When middleware is enabled, the request flow is:
  /// 1. Middleware chain (in registration order)
  /// 2. Existing hooks (AuthenticationHandler, etc.)
  /// 3. Endpoint method execution
  ///
  /// ## Example Usage
  ///
  /// ```dart
  /// final pod = await Serverpod(
  ///   args,
  ///   serializationManager,
  ///   endpoints,
  ///   experimentalFeatures: ExperimentalFeatures(
  ///     middleware: [
  ///       LoggingMiddleware(serverpod),
  ///       CorsMiddleware(
  ///         allowOrigin: '*',
  ///         allowMethods: ['GET', 'POST', 'PUT', 'DELETE'],
  ///       ),
  ///       MetricsMiddleware(metrics),
  ///     ],
  ///   ),
  /// );
  /// ```
  ///
  /// ## Performance Considerations
  ///
  /// Each middleware adds processing time to every request. Keep middleware
  /// lightweight and avoid blocking operations. Target < 1ms overhead per
  /// middleware.
  ///
  /// ## See Also
  ///
  /// - [HttpMiddleware] - Base interface for all middleware
  /// - [NextFunction] - Function signature for middleware chain
  final List<HttpMiddleware>? middleware;

  /// Creates a new [ExperimentalFeatures] instance.
  ExperimentalFeatures({
    this.diagnosticEventHandlers,
    this.middleware,
  });
}

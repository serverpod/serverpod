import 'dart:async';

import 'package:relic/relic.dart';

/// HTTP middleware for intercepting and processing HTTP requests.
///
/// [HttpMiddleware] provides a mechanism to execute code before and after
/// request processing, enabling cross-cutting concerns like logging,
/// authentication, metrics collection, and response modification.
///
/// **Experimental Feature**: This API is experimental and may change in
/// future versions. Use [ExperimentalFeatures.middleware] to enable.
///
/// ## Execution Model
///
/// Middleware is executed in the order it is registered. Each middleware
/// wraps the next one in the chain, creating a nested execution structure:
///
/// ```
/// Request → [MW1] → [MW2] → [MW3] → Core Handler → Response
///            ↓       ↓       ↓
///         before  before  before
///            ↑       ↑       ↑
///          after   after   after
/// ```
///
/// ## Instance Lifecycle and Concurrency
///
/// **Important**: Middleware instances are created once at server startup
/// and shared across all requests. Each request is handled concurrently,
/// so middleware must be thread-safe.
///
/// ### Thread-Safety Best Practices
///
/// **✅ Safe**: Use local variables for per-request state
/// ```dart
/// class SafeMiddleware implements HttpMiddleware {
///   @override
///   Future<Response> handle(Request request, NextFunction next) async {
///     final startTime = DateTime.now(); // ✅ Local variable
///     final response = await next(request);
///     final duration = DateTime.now().difference(startTime);
///     return response;
///   }
/// }
/// ```
///
/// **❌ Unsafe**: Use instance fields for per-request data
/// ```dart
/// class UnsafeMiddleware implements HttpMiddleware {
///   String? currentUserId; // ❌ Shared across requests!
///
///   @override
///   Future<Response> handle(Request request, NextFunction next) async {
///     currentUserId = request.headers['user']?.first; // Race condition!
///     return next(request);
///   }
/// }
/// ```
///
/// **✅ Safe**: Shared state for counters/metrics (Dart's single-isolate model)
/// ```dart
/// class MetricsMiddleware implements HttpMiddleware {
///   int requestCount = 0; // ✅ Safe in single isolate
///
///   @override
///   Future<Response> handle(Request request, NextFunction next) async {
///     requestCount++; // Atomic in single-threaded event loop
///     return next(request);
///   }
/// }
/// ```
///
/// ## Example Usage
///
/// ### Simple Logging Middleware
/// ```dart
/// class LoggingMiddleware implements HttpMiddleware {
///   final Serverpod serverpod;
///
///   LoggingMiddleware(this.serverpod);
///
///   @override
///   Future<Response> handle(Request request, NextFunction next) async {
///     serverpod.logVerbose('Request: ${request.method} ${request.requestedUri}');
///     final response = await next(request);
///     serverpod.logVerbose('Response: ${response.statusCode}');
///     return response;
///   }
/// }
/// ```
///
/// ### Short-Circuiting (Authentication)
/// ```dart
/// class ApiKeyMiddleware implements HttpMiddleware {
///   final String validApiKey;
///
///   ApiKeyMiddleware(this.validApiKey);
///
///   @override
///   Future<Response> handle(Request request, NextFunction next) async {
///     final apiKey = request.headers['X-API-Key']?.firstOrNull;
///
///     if (apiKey != validApiKey) {
///       // Short-circuit: return response without calling next()
///       return Response.unauthorized(
///         body: Body.fromString('Invalid API key'),
///       );
///     }
///
///     return next(request);
///   }
/// }
/// ```
///
/// ### Modifying Responses
/// ```dart
/// class HeaderMiddleware implements HttpMiddleware {
///   @override
///   Future<Response> handle(Request request, NextFunction next) async {
///     final response = await next(request);
///
///     // Add custom header to response
///     return Response(
///       response.statusCode,
///       body: response.body,
///       headers: response.headers.transform((h) {
///         h['X-Custom-Header'] = ['value'];
///       }),
///     );
///   }
/// }
/// ```
///
/// ### Registering Middleware
/// ```dart
/// final pod = await Serverpod(
///   args,
///   serializationManager,
///   endpoints,
///   experimentalFeatures: ExperimentalFeatures(
///     middleware: [
///       LoggingMiddleware(serverpod),
///       ApiKeyMiddleware('secret-key'),
///       HeaderMiddleware(),
///     ],
///   ),
/// );
/// ```
///
/// ## Performance Considerations
///
/// - Keep middleware lightweight (target < 1ms per middleware)
/// - Use async operations (`await`) instead of blocking calls
/// - Cache expensive lookups when possible
/// - Avoid creating unnecessary objects on each request
/// - Profile middleware impact on request latency
///
/// ## See Also
///
/// - [NextFunction] - Function signature for calling the next middleware
/// - [ExperimentalFeatures] - How to enable middleware
abstract class HttpMiddleware {
  /// Process the request and optionally call the next middleware.
  ///
  /// The [request] parameter contains the incoming HTTP request.
  /// The [next] function continues the middleware chain or invokes
  /// the core request handler if this is the last middleware.
  ///
  /// Returns a [Response] that will be sent to the client.
  ///
  /// **Important**: Always call [next] unless you want to short-circuit
  /// the request (e.g., for authentication failures, rate limiting, etc.)
  ///
  /// ## Examples
  ///
  /// **Calling next to continue the chain:**
  /// ```dart
  /// @override
  /// Future<Response> handle(Request request, NextFunction next) async {
  ///   // Pre-processing
  ///   print('Before request');
  ///
  ///   // Call next middleware/handler
  ///   final response = await next(request);
  ///
  ///   // Post-processing
  ///   print('After request');
  ///
  ///   return response;
  /// }
  /// ```
  ///
  /// **Short-circuiting (not calling next):**
  /// ```dart
  /// @override
  /// Future<Response> handle(Request request, NextFunction next) async {
  ///   if (!isAuthorized(request)) {
  ///     // Don't call next - return error response directly
  ///     return Response.forbidden(
  ///       body: Body.fromString('Forbidden'),
  ///     );
  ///   }
  ///
  ///   return next(request);
  /// }
  /// ```
  FutureOr<Response> handle(Request request, NextFunction next);
}

/// Function signature for the next middleware in the chain.
///
/// Calling this function will invoke the next registered middleware,
/// or the core request handler if no more middleware exist.
///
/// The [request] parameter is the HTTP request to process. Middleware
/// can pass a modified request to the next handler if needed.
///
/// Returns a [Response] that will be returned to the previous middleware
/// in the chain (or to the client if this is the outermost middleware).
///
/// ## Example
///
/// ```dart
/// class ExampleMiddleware implements HttpMiddleware {
///   @override
///   Future<Response> handle(Request request, NextFunction next) async {
///     // Modify request before passing to next handler
///     final modifiedRequest = request.change(
///       headers: request.headers.transform((h) {
///         h['X-Request-ID'] = [uuid.v4()];
///       }),
///     );
///
///     // Call next with modified request
///     return next(modifiedRequest);
///   }
/// }
/// ```
typedef NextFunction = Future<Response> Function(Request request);

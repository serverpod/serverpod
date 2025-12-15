import 'package:serverpod/serverpod.dart';

/// Middleware that falls back to an alternative handler when a response
/// matches a condition.
///
/// This is particularly useful for serving Single Page Applications (SPAs)
/// where missing files should fall back to index.html to enable client-side
/// routing.
///
/// ## Basic SPA Usage
///
/// ```dart
/// final webDir = Directory('web');
/// final indexFile = File('web/index.html');
///
/// pod.webServer.addMiddleware(
///   FallbackMiddleware(
///     fallback: StaticRoute.file(indexFile),
///     on: (response) => response.statusCode == 404,
///   ),
///   '/',
/// );
/// pod.webServer.addRoute(StaticRoute.directory(webDir));
/// ```
///
/// ## Custom Condition Example
///
/// ```dart
/// pod.webServer.addMiddleware(
///   FallbackMiddleware(
///     fallback: errorPageRoute,
///     on: (response) => response.statusCode >= 500,
///   ),
///   '/api',
/// );
/// ```
///
/// ## How It Works
///
/// 1. The middleware wraps the inner handler (typically a StaticRoute)
/// 2. Calls the inner handler and receives its response
/// 3. If the response matches the condition (e.g., status == 404), calls the fallback handler
/// 4. Otherwise, returns the original response
///
/// The fallback route automatically has access to the session because all
/// routes in the WebServer are wrapped with session middleware.
class FallbackMiddleware extends MiddlewareObject {
  /// The fallback route to use when the condition matches
  final Route fallback;

  /// The condition function that determines when to use the fallback
  final bool Function(Response) on;

  /// Creates a new FallbackMiddleware
  const FallbackMiddleware({
    required this.fallback,
    required this.on,
  });

  @override
  Handler call(Handler next) {
    return (Request req) async {
      // Call the primary handler
      final result = await next(req);

      // Check if it's a Response and matches the condition
      if (result is Response && on(result)) {
        // Use fallback route with the original request
        return fallback.asHandler(req);
      }

      // Return original result
      return result;
    };
  }
}

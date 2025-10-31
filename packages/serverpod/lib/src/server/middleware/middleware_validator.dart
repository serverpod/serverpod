import 'package:relic/relic.dart';

/// Validates middleware configurations for the Serverpod server.
///
/// This class provides validation and warnings for middleware configurations
/// to help identify potential issues or performance concerns.
///
/// ## Validation Rules
///
/// 1. **Large Middleware Lists**: Warns if more than 10 middleware are registered.
///    Large middleware lists may impact performance as each request must pass
///    through all middleware in the pipeline.
///
/// 2. **Duplicate Detection Limitation**: Due to Dart's function type system,
///    this validator cannot detect duplicate middleware functions. Middleware
///    functions are compared by reference, not by implementation. If you create
///    the same middleware twice (e.g., `loggingMiddleware()` called twice),
///    both will be registered and executed.
///
/// ## Usage
///
/// The validator is automatically called during Serverpod initialization when
/// middleware is configured via [ExperimentalFeatures.middleware].
///
/// ```dart
/// // This middleware list will trigger a warning (>10 items)
/// experimentalFeatures: ExperimentalFeatures(
///   middleware: [
///     loggingMiddleware(),
///     metricsMiddleware(),
///     // ... 9 more middleware ...
///   ],
/// ),
/// ```
///
/// ## Validation Output
///
/// Warnings are logged via the provided logger function (typically routed
/// through Serverpod's logging system):
/// ```
/// WARNING: Large middleware list detected (12 middleware registered).
/// Consider reducing the number of middleware for better performance.
/// Each request passes through all middleware in sequence.
/// ```
///
/// ## Best Practices
///
/// - Keep middleware lists small (< 10 items) for best performance
/// - Combine related middleware when possible
/// - Avoid registering the same middleware multiple times
/// - Order middleware from most general to most specific
///
/// ## See Also
///
/// - [Middleware] - The relic middleware type
/// - [ExperimentalFeatures.middleware] - How to register middleware
/// - [Pipeline] - How middleware are composed
class MiddlewareValidator {
  /// The recommended maximum number of middleware before warning.
  static const int recommendedMaxMiddleware = 10;

  /// Validates a list of middleware and logs warnings for potential issues.
  ///
  /// This method checks the middleware configuration and logs warnings via
  /// the provided [logWarning] function for:
  /// - Large middleware lists (> [recommendedMaxMiddleware] items)
  ///
  /// **Note on Duplicate Detection**: This validator cannot detect duplicate
  /// middleware functions due to Dart's function type system. Middleware
  /// functions are compared by reference only. Creating the same middleware
  /// multiple times (e.g., calling `loggingMiddleware()` twice) will result
  /// in multiple registrations that cannot be detected as duplicates.
  ///
  /// Example:
  /// ```dart
  /// // These are different references, even if they do the same thing
  /// final middleware1 = loggingMiddleware();
  /// final middleware2 = loggingMiddleware();
  /// assert(identical(middleware1, middleware2) == false);
  /// ```
  ///
  /// Parameters:
  /// - [middleware]: The list of middleware to validate
  /// - [logWarning]: Function to call for logging warnings. This should be
  ///   routed through Serverpod's logging system (e.g., LogManager) to ensure
  ///   warnings are captured by configured log sinks and honor log levels.
  ///
  /// Note that warnings do not prevent the server from starting - they are
  /// informational only.
  static void validate(
    List<Middleware> middleware, {
    required void Function(String message) logWarning,
  }) {
    // Check for large middleware lists
    if (middleware.length > recommendedMaxMiddleware) {
      logWarning(
        'WARNING: Large middleware list detected (${middleware.length} middleware registered). '
        'Consider reducing the number of middleware for better performance. '
        'Each request passes through all middleware in sequence.',
      );
    }

    // Document limitation: Cannot detect duplicates due to function types
    // Middleware are functions, and Dart functions are compared by reference.
    // Two calls to loggingMiddleware() produce different function references,
    // even if they have identical behavior.
  }
}

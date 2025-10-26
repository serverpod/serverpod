import 'package:serverpod/src/server/middleware/middleware.dart';

/// Validates middleware configuration.
///
/// This is extracted for testability. It performs the following checks:
/// - Detects duplicate middleware instances
/// - Warns if the middleware list is unusually large (>10 items)
///
/// Throws [ArgumentError] if validation fails.
/// Returns warning messages if any (for logging in verbose mode).
///
/// This function is package-private and used by Serverpod internally.
List<String> validateMiddleware(List<HttpMiddleware>? middleware) {
  final warnings = <String>[];

  if (middleware == null || middleware.isEmpty) {
    return warnings;
  }

  // Check for duplicate middleware instances
  final seen = <HttpMiddleware>{};
  final duplicates = <HttpMiddleware>[];

  for (var mw in middleware) {
    if (seen.contains(mw)) {
      duplicates.add(mw);
    } else {
      seen.add(mw);
    }
  }

  if (duplicates.isNotEmpty) {
    throw ArgumentError(
      'Middleware list contains duplicate instances. '
      'The same middleware object is registered multiple times. '
      'This is likely a configuration error. '
      'Found ${duplicates.length} duplicate(s).',
    );
  }

  // Warn if middleware list is unusually large
  if (middleware.length > 10) {
    warnings.add(
      'WARNING: Middleware list contains ${middleware.length} items. '
      'Each middleware adds latency to requests. '
      'Consider consolidating middleware or reviewing your configuration.',
    );
  }

  warnings.add(
    'Middleware validation passed: ${middleware.length} middleware configured',
  );

  return warnings;
}

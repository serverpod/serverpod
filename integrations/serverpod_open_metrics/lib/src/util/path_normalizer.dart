/// Path normalization for metrics to prevent unbounded cardinality.
///
/// Converts dynamic paths like `/api/user/123` to patterns like `/api/user/:id`
/// to ensure metric labels don't grow unboundedly.
library;

/// Normalizes HTTP paths to prevent unbounded cardinality in metrics.
///
/// This class identifies dynamic path segments (like IDs, UUIDs, etc.) and
/// replaces them with placeholder names to ensure metric labels remain bounded.
///
/// Example:
/// ```dart
/// final normalizer = PathNormalizer();
/// print(normalizer.normalize('/api/user/123'));  // /api/user/:id
/// print(normalizer.normalize('/api/user/abc-def-123'));  // /api/user/:id
/// print(normalizer.normalize('/api/posts/2024-01-15'));  // /api/posts/:id
/// ```
class PathNormalizer {
  /// Pattern for numeric segments (integers, floats, or hex).
  /// Examples: 123, 45.67, 0x1a2b, -42
  static final _numericPattern = RegExp(r'^-?(?:0x[\da-fA-F]+|\d+(?:\.\d+)?)$');

  /// Pattern for UUID segments.
  /// Examples: 550e8400-e29b-41d4-a716-446655440000
  static final _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  /// Pattern for hash-like and slug segments (alphanumeric strings with mixed digits).
  /// Examples: a1b2c3d4e5f6, 1a2b3c4d5e6f7g8h, abc-def-123, post_42_edit
  /// Requires at least 8 characters AND must contain both letters and digits
  /// to distinguish from regular words like "getUserInfo" or "download".
  /// Allows hyphens and underscores to match common slug patterns.
  static final _hashPattern = RegExp(
    r'^(?=.*[0-9])(?=.*[a-zA-Z])[a-zA-Z0-9_-]{8,}$',
  );

  /// Pattern for ISO date segments.
  /// Examples: 2024-01-15, 2024-12-31
  static final _datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  /// Pattern for timestamp segments (Unix epoch in milliseconds).
  /// Examples: 1704067200000, 1735689600000
  static final _timestampPattern = RegExp(r'^\d{10,13}$');

  /// Normalize a URL path to a pattern with placeholders.
  ///
  /// Segments that look like dynamic values (IDs, UUIDs, hashes, dates, etc.)
  /// are replaced with `:id` to prevent unbounded cardinality.
  ///
  /// Segments that look like static API parts (strings with letters) are kept.
  ///
  /// Examples:
  /// - `/api/user/123` → `/api/user/:id`
  /// - `/api/user/abc123def` → `/api/user/:id`
  /// - `/api/posts/2024-01-15` → `/api/posts/:id`
  /// - `/api/users` → `/api/users` (unchanged)
  /// - `/api/v1/users` → `/api/v1/users` (unchanged)
  String normalize(final String path) {
    // Handle empty or root path
    if (path.isEmpty || path == '/') {
      return '/';
    }

    // Remove leading slash for processing
    var workingPath = path;
    final hasLeadingSlash = path.startsWith('/');
    if (hasLeadingSlash) {
      workingPath = path.substring(1);
    }

    // Remove trailing slash
    if (workingPath.endsWith('/')) {
      workingPath = workingPath.substring(0, workingPath.length - 1);
    }

    // Handle empty path after trimming
    if (workingPath.isEmpty) {
      return '/';
    }

    // Split into segments and normalize each
    final segments = workingPath.split('/');
    final normalized = segments.map(_normalizeSegment).toList();

    // Reconstruct path
    final result = normalized.join('/');
    return hasLeadingSlash ? '/$result' : result;
  }

  /// Normalize a single path segment.
  ///
  /// Returns `:id` for dynamic-looking segments, or the original segment
  /// for static-looking segments.
  String _normalizeSegment(final String segment) {
    if (segment.isEmpty) {
      return segment;
    }

    // Check for various dynamic patterns
    if (_numericPattern.hasMatch(segment) ||
        _uuidPattern.hasMatch(segment) ||
        _hashPattern.hasMatch(segment) ||
        _datePattern.hasMatch(segment) ||
        _timestampPattern.hasMatch(segment)) {
      return ':id';
    }

    // Keep the segment as-is if it looks static
    return segment;
  }
}

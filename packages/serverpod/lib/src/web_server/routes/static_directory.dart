import 'dart:async';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';

/// A path pattern to match, and the max age that paths that match the pattern
/// should be cached for, in seconds.
class PathCacheMaxAge {
  /// The path pattern to match.
  final Pattern pathPattern;

  /// The max age that paths that match the pattern should be cached for, in
  /// seconds.
  final Duration maxAge;

  /// A value for [maxAge] that indicates that the path should not be cached.
  static const Duration noCache = Duration.zero;

  /// A value for [maxAge] that indicates that the path should be cached for
  /// one year.
  static const Duration oneYear = Duration(days: 365);

  /// Creates a new [PathCacheMaxAge] with the given [pathPattern] and [maxAge].
  PathCacheMaxAge({
    required this.pathPattern,
    required this.maxAge,
  });

  bool _shouldCache(String path) {
    var pattern = pathPattern;

    if (pattern is String) {
      return path == pattern;
    } else if (pattern is RegExp) {
      return pattern.hasMatch(path);
    }

    return false;
  }
}

// This class has been cleared out and marked abstract.
// It is only left behind to add a deprecation annotation
// to help people move to use StaticRoute.
/// Route for serving a directory of static files.
@Deprecated('Use StaticRoute.directory instead')
abstract class RouteStaticDirectory extends Route {}

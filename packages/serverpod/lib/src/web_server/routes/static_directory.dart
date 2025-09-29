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

/// Route for serving a directory of static files.
@Deprecated('Use StaticRoute.directory instead')
class RouteStaticDirectory extends Route {
  /// The path to the directory to serve relative to the web/ directory.
  final String serverDirectory;

  /// A regular expression that will be used to determine if a path should not
  /// be cached.
  late final List<PathCacheMaxAge>? _pathCachePatterns;

  /// Creates a static directory with the [serverDirectory] as its root.
  ///
  /// If [pathCachePatterns] is provided, paths matching the requested
  /// patterns will be cached for the requested amount of time. Paths that
  /// are do not match any provided pattern are cached for one year.
  RouteStaticDirectory({
    required this.serverDirectory,
    List<PathCacheMaxAge>? pathCachePatterns,
  }) : super(methods: {Method.get, Method.head}) {
    _pathCachePatterns = pathCachePatterns;
    _handler = createStaticHandler(
      p.join('web', serverDirectory),
      cacheControl: (ctx, fileInfo) {
        // Get the max age for the path
        var pathCacheMaxAge = _pathCachePatterns
                ?.firstWhereOrNull(
                    (pattern) => pattern._shouldCache(ctx.remainingPath.path))
                ?.maxAge ??
            // Default to a max age of one year if no pattern matched
            PathCacheMaxAge.oneYear;

        // Set Cache-Control header
        return pathCacheMaxAge == PathCacheMaxAge.noCache
            // Don't cache this path
            ? CacheControlHeader(
                maxAge: 0, sMaxAge: 0, noCache: true, noStore: true)
            : CacheControlHeader(maxAge: pathCacheMaxAge.inSeconds);
      },
    );
  }

  late final Handler _handler;

  @override
  FutureOr<HandledContext> handleCall(Session session, NewContext context) =>
      _handler(context);
}

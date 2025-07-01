import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';

// TODO: Add more content type mappings.
final _contentTypeMapping = <String, ContentType>{
  '.js': ContentType('text', 'javascript'),
  '.json': ContentType('application', 'json'),
  '.wsam': ContentType('application', 'wasm'),
  '.css': ContentType('text', 'css'),
  '.png': ContentType('image', 'png'),
  '.jpg': ContentType('image', 'jpeg'),
  '.jpeg': ContentType('image', 'jpeg'),
  '.svg': ContentType('image', 'svg+xml'),
  '.ttf': ContentType('application', 'x-font-ttf'),
  '.woff': ContentType('application', 'x-font-woff'),
  '.mp3': ContentType('audio', 'mpeg'),
  '.pdf': ContentType('application', 'pdf'),
};

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
class RouteStaticDirectory extends Route {
  /// The path to the directory to serve relative to the web/ directory.
  final String serverDirectory;

  /// The path to the directory to serve static files from.
  final String? basePath;

  /// The path to serve as the root path ('/'), e.g. '/index.html'.
  final String? serveAsRootPath;

  /// A regular expression that will be used to determine if a path should not
  /// be cached.
  late final List<PathCacheMaxAge>? _pathCachePatterns;

  /// Creates a static directory with the [serverDirectory] as its root.
  /// If [basePath] is provided, the directory will be served from that path.
  /// If [pathCachePatterns] is provided, paths matching the requested
  /// patterns will be cached for the requested amount of time. Paths that
  /// are do not match any provided pattern are cached for one year.
  RouteStaticDirectory({
    required this.serverDirectory,
    this.basePath,
    this.serveAsRootPath,
    List<PathCacheMaxAge>? pathCachePatterns,
  }) {
    _pathCachePatterns = pathCachePatterns;
  }

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    var path = Uri.decodeFull(request.requestedUri.path);

    var rootPath = serveAsRootPath;
    if (rootPath != null && path == '/') {
      path = rootPath;
    }

    try {
      // Remove version control string
      var dir = serverDirectory;
      var base = p.basenameWithoutExtension(path);
      var extension = p.extension(path);

      var baseParts = base.split('@');
      if (baseParts.length > 1 && baseParts.last.startsWith('v')) {
        baseParts.removeLast();
      }
      base = baseParts.join('@');

      var localBasePath = basePath;
      if (localBasePath != null && path.startsWith(localBasePath)) {
        var requestDir = p.dirname(path);
        var middlePath = requestDir.substring(localBasePath.length);

        if (middlePath.isNotEmpty) {
          path = p.join(dir, middlePath, base + extension);
        } else {
          path = p.join(dir, base + extension);
        }
      } else {
        path = p.join(dir, base + extension);
      }

      // Set content type.
      extension = extension.toLowerCase();
      var contentType = _contentTypeMapping[extension];
      if (contentType != null) {
        request.response.headers.contentType = contentType;
      }

      // Get the max age for the path
      var pathCacheMaxAge = _pathCachePatterns
              ?.firstWhereOrNull((pattern) => pattern._shouldCache(path))
              ?.maxAge ??
          // Default to a max age of one year if no pattern matched
          PathCacheMaxAge.oneYear;

      // Set Cache-Control header
      request.response.headers.set(
        'Cache-Control',
        pathCacheMaxAge == PathCacheMaxAge.noCache
            // Don't cache this path
            ? 'max-age=0, s-maxage=0, no-cache, no-store'
            // Cache for the specified amount of time, or the default
            // of one year if no pattern matched
            : 'max-age=${pathCacheMaxAge.inSeconds}',
      );

      var filePath = path.startsWith('/') ? path.substring(1) : path;
      filePath = 'web/$filePath';

      var fileContents = await File(filePath).readAsBytes();
      request.response.add(fileContents);
      return true;
    } catch (e) {
      // Couldn't find or load file.
      return false;
    }
  }
}

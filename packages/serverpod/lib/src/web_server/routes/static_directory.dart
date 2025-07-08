import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';

// TODO: Add more content type mappings.
const _mimeTypeMapping = <String, MimeType>{
  '.js': MimeType.javascript,
  '.json': MimeType.json,
  '.wasm': MimeType('application', 'wasm'),
  '.css': MimeType.css,
  '.png': MimeType('image', 'png'),
  '.jpg': MimeType('image', 'jpeg'),
  '.jpeg': MimeType('image', 'jpeg'),
  '.svg': MimeType('image', 'svg+xml'),
  '.ttf': MimeType('application', 'x-font-ttf'),
  '.woff': MimeType('application', 'x-font-woff'),
  '.mp3': MimeType('audio', 'mpeg'),
  '.pdf': MimeType.pdf,
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
  FutureOr<HandledContext> handleCall(
    Session session,
    NewContext context,
  ) async {
    final request = context.request;
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
      if (baseParts.last.startsWith('v')) {
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

      var filePath = path.startsWith('/') ? path.substring(1) : path;
      filePath = 'web/$filePath';

      final file = File(filePath);
      if (!await file.exists()) {
        return context.withResponse(Response.notFound());
      }

      // Set mime-type.
      extension = extension.toLowerCase();
      var mimeType = _mimeTypeMapping[extension];

      // Get the max age for the path
      var pathCacheMaxAge = _pathCachePatterns
              ?.firstWhereOrNull((pattern) => pattern._shouldCache(path))
              ?.maxAge ??
          // Default to a max age of one year if no pattern matched
          PathCacheMaxAge.oneYear;

      // Set Cache-Control header
      final headers = Headers.build((mh) => mh.cacheControl =
          pathCacheMaxAge == PathCacheMaxAge.noCache
              // Don't cache this path
              ? CacheControlHeader(
                  maxAge: 0, sMaxAge: 0, noCache: true, noStore: true)
              : CacheControlHeader(maxAge: pathCacheMaxAge.inSeconds));

      final body = Body.fromDataStream(
        file.openRead().cast(),
        mimeType: mimeType,
      );
      return context.withResponse(Response.ok(body: body, headers: headers));
    } catch (e) {
      // Couldn't find or load file.
      rethrow;
    }
  }
}

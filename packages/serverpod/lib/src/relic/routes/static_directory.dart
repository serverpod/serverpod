import 'dart:io';

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

/// Route for serving a directory of static files.
class RouteStaticDirectory extends Route {
  /// The path to the directory to serve relative to the web/ directory.
  final String serverDirectory;

  /// The path to the directory to serve static files from.
  final String? basePath;

  /// A regular expression that will be used to determine if a path should not
  /// be cached.
  late final RegExp? noCachePathRegexp;

  /// Creates a static directory with the [serverDirectory] as its root.
  /// If [basePath] is provided, the directory will be served from that path.
  /// If [noCachePathPattern] is provided, paths matching the provided pattern
  /// will not be cached. (Otherwise, all paths will be cached for a year.)
  RouteStaticDirectory({
    required this.serverDirectory,
    this.basePath,
    String? noCachePathPattern,
  }) {
    // Pre-compile the regexp pattern, if provided
    final regexpPath = noCachePathPattern;
    noCachePathRegexp = regexpPath == null ? null : RegExp(regexpPath);
  }

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    session as MethodCallSession;

    var path = Uri.decodeFull(session.uri.path);

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

      if (basePath != null && path.startsWith(basePath!)) {
        var requestDir = p.dirname(path);
        var middlePath = requestDir.substring(basePath!.length);

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

      // Enforce strong cache control.
      if (noCachePathRegexp != null && noCachePathRegexp!.hasMatch(path)) {
        request.response.headers
            .set('Cache-Control', 'max-age=0, s-maxage=0, no-cache, no-store');
      } else {
        request.response.headers.set('Cache-Control', 'max-age=31536000');
      }

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

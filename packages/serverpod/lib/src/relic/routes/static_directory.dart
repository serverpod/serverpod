import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/relic/util/log_utils.dart';

final _contentTypeMapping = <String, ContentType>{
  '.js': ContentType('text', 'javascript'),
  '.json': ContentType('application', 'json'),
  '.wasm': ContentType('application', 'wasm'),
  '.css': ContentType('text', 'css'),
  '.png': ContentType('image', 'png'),
  '.jpg': ContentType('image', 'jpeg'),
  '.jpeg': ContentType('image', 'jpeg'),
  '.svg': ContentType('image', 'svg+xml'),
  '.ttf': ContentType('application', 'x-font-ttf'),
  '.woff': ContentType('application', 'x-font-woff'),
  '.mp3': ContentType('audio', 'mpeg'),
  '.pdf': ContentType('application', 'pdf'),
  '.html': ContentType('text', 'html'),
  '.htm': ContentType('text', 'html'),
  '.gif': ContentType('image', 'gif'),
  '.mp4': ContentType('video', 'mp4'),
};

/// Route for serving a directory of static files.
class RouteStaticDirectory extends Route {
  /// The path to the directory to serve relative to the web/ directory.
  final String serverDirectory;

  /// The path to the directory to serve static files from.
  final String? basePath;

  /// The path to serve as the root path ('/'), e.g. '/index.html'.
  final String? serveAsRootPath;

  /// Creates a static directory with the [serverDirectory] as its root.
  RouteStaticDirectory({
    required String serverDirectory,
    String? basePath,
    this.serveAsRootPath,
  })  : serverDirectory = p.normalize(serverDirectory),
        basePath = basePath != null ? p.normalize(basePath) : null;

  @override
  Future<Response> handleCall(Session session, Request request) async {
    var path = Uri.decodeFull(request.requestedUri.path);

    var rootPath = serveAsRootPath;
    if (rootPath != null && path == '/') {
      path = rootPath;
    }

    try {
      // Normalize path to prevent directory traversal attacks, example:
      // Original Path 1: /home/user/../documents/./file.txt
      // Normalized Path 1: /home/documents/file.txt
      path = p.normalize(path);

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

      // Set content type.
      extension = extension.toLowerCase();
      var contentType = _contentTypeMapping[extension];

      if (contentType == null) {
        logDebug('Unknown content type for extension: $extension');
      }

      var filePath = path.startsWith('/') ? path.substring(1) : path;
      filePath = 'web/$filePath';

      var fileContents = await File(filePath).readAsBytes();

      return Response.ok(
        body: Body.fromData(fileContents),
        headers: Headers.response(
          custom: CustomHeaders(
            {
              'Cache-Control': ['max-age=31536000'],
              'Content-Type': [
                contentType?.mimeType ?? 'application/octet-stream',
              ],
            },
          ),
        ),
      );
    } catch (e) {
      // Log error and return not found response
      logError('Error serving file $path: $e');
      return Response.notFound();
    }
  }
}

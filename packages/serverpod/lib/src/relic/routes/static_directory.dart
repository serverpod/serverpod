import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';

/// Route for serving a directory of static files.
class RouteStaticDirectory extends Route {
  /// The path to the directory to serve relative to the web/ directory.
  final String serverDirectory;

  /// The path to the directory to serve static files from.
  final String? basePath;

  /// Creates a static directory with the [serverDirectory] as its root.
  RouteStaticDirectory({required this.serverDirectory, this.basePath});

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

      // TODO: Correctly set headers for more types
      extension = extension.toLowerCase();
      if (extension == '.js') {
        request.response.headers.contentType =
            ContentType('text', 'javascript');
      } else if (extension == '.css') {
        request.response.headers.contentType = ContentType('text', 'css');
      } else if (extension == '.png') {
        request.response.headers.contentType = ContentType('image', 'png');
      } else if (extension == '.jpg') {
        request.response.headers.contentType = ContentType('image', 'jpeg');
      } else if (extension == '.svg') {
        request.response.headers.contentType = ContentType('image', 'svg+xml');
      } else if (extension == '.ttf') {
        request.response.headers.contentType =
            ContentType('application', 'x-font-ttf');
      } else if (extension == '.woff') {
        request.response.headers.contentType =
            ContentType('application', 'x-font-woff');
      } else if (extension == '.mp3') {
        request.response.headers.contentType = ContentType('audio', 'mpeg');
      }

      // Enforce strong cache control
      request.response.headers.set('Cache-Control', 'max-age=31536000');

      var filePath = path.startsWith('/') ? path.substring(1) : path;
      filePath = 'web/$filePath';

      var fileContents = await File(filePath).readAsBytes();
      request.response.add(fileContents);
      return true;
    } catch (e) {
      return false;
    }
  }
}

import 'package:path/path.dart' as p;

/// Provides utility functions for working with paths.
class PathUtil {
  /// Tests if a file is in a whitelisted path. File paths should all be
  /// relative. Complete directories can be whitelisted by adding a trailing
  /// slash. The path and whitelisted paths are case sensitive and should be
  /// in unix/posix format.
  static bool isFileWhitelisted(String path, Set<String> whitelistedFiles) {
    for (var whitelistedFile in whitelistedFiles) {
      if (whitelistedFile.endsWith('/')) {
        if (path.startsWith(whitelistedFile)) {
          return true;
        }
      } else {
        if (path == whitelistedFile) {
          return true;
        }
      }
    }
    return false;
  }

  /// Converts a relative path in unix/posix format to a platform specific
  /// relative path.
  static String relativePathToPlatformPath(String relativeUnixPath) {
    return p.context.joinAll(p.posix.split(relativeUnixPath));
  }
}

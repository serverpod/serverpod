import 'dart:io';

import 'package:path/path.dart' as p;

class WindowsUtil {
  static String? commandPath(String command) {
    var pathEnv = Platform.environment[Platform.isWindows ? 'path' : 'PATH'];
    if (pathEnv == null) {
      return null;
    }
    var paths = pathEnv.split(Platform.isWindows ? ';' : ':');
    for (var path in paths) {
      if (path.isEmpty) {
        continue;
      }
      var possibleCommandPath = p.join(path, command);
      var possibleCommandFile = File(possibleCommandPath);
      if (possibleCommandFile.existsSync()) {
        return possibleCommandPath;
      }
    }
    return null;
  }
}

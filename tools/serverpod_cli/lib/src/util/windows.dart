import 'dart:io';
import 'package:path/path.dart' as p;

class WindowsUtil {
  static String? commandPath(String command) {
    var pathEnv = Platform.environment['Path'];
    if (pathEnv == null) {
      return null;
    }
    var paths = pathEnv.split(';');
    for (var path in paths) {
      if (path.isEmpty) {
        continue;
      }
      var possibleCommandPath = p.join(path, command);

      // Check name without extension.
      var possibleCommandFile = File(possibleCommandPath);
      if (possibleCommandFile.existsSync()) {
        return possibleCommandPath;
      }

      // Check name with bat extension.
      possibleCommandFile = File('$possibleCommandPath.bat');
      if (possibleCommandFile.existsSync()) {
        return possibleCommandPath;
      }
    }
    return null;
  }
}

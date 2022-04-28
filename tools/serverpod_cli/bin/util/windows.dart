import 'dart:io';

class WindowsUtil {
  static String? commandPath(String command) {
    String? pathEnv = Platform.environment['Path'];
    if (pathEnv == null) {
      return null;
    }
    List<String> paths = pathEnv.split(';');
    for (String path in paths) {
      if (path.isEmpty) {
        continue;
      }
      String possibleCommandPath = path + Platform.pathSeparator + command;
      File possibleCommandFile = File(possibleCommandPath);
      if (possibleCommandFile.existsSync()) {
        return possibleCommandPath;
      }
    }
    return null;
  }
}

import 'dart:io';

import '../generated/version.dart';
import 'package:path/path.dart' as p;

String serverpodHome = '';

bool loadEnvironmentVars() {
  if (!productionMode) {
    var home = Platform.environment['SERVERPOD_HOME'] ??
        p.join(
            Platform.isWindows
                ? Platform.environment['USERPROFILE']!
                : Platform.environment['HOME']!,
            'Documents');
    if (home.isEmpty || !Directory(home).existsSync()) {
      print(
          'The SERVERPOD_HOME environmental variable is required in development mode');
      return false;
    }
    serverpodHome = home;
  }

  return true;
}

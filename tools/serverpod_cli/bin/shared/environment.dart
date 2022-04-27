import 'dart:io';

import '../generated/version.dart';

String serverpodHome = '';

bool loadEnvironmentVars() {
  if (!productionMode) {
    var home = Platform.environment['SERVERPOD_HOME'];
    if (home == null || !Directory(home).existsSync()) {
      print(
          'The SERVERPOD_HOME environmental variable is required in development mode');
      return false;
    }
    serverpodHome = home;
  }

  return true;
}

import 'dart:io';

import 'package:serverpod_cli/src/logger/logger.dart';

import '../generated/version.dart';

String serverpodHome = '';

bool loadEnvironmentVars() {
  if (!productionMode) {
    var home = Platform.environment['SERVERPOD_HOME'];
    if (home == null || home == '' || !Directory(home).existsSync()) {
      log.error(
        'The SERVERPOD_HOME environmental variable is required in development mode,',
      );
      return false;
    }
    serverpodHome = home;
  }

  return true;
}

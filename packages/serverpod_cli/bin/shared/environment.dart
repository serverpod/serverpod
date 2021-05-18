import 'dart:io';

String serverpodHome = '';

bool loadEnvironmentVars() {
  var home = Platform.environment['SERVERPOD_HOME'];
  if (home == null || !Directory(home).existsSync()) {
    print('The SERVERPOD_HOME environmental variable isn\'t set or is invalid');
    return false;
  }
  serverpodHome = home;

  return true;
}
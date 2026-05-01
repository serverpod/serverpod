import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../generated/version.dart';

String get serverpodHome {
  if (_serverpodHome == null) {
    loadEnvironmentVars();
  }
  return _serverpodHome!;
}

String? _serverpodHome;

/// Loads the environment variables for the serverpod CLI.
///
/// If in dev mode and the SERVERPOD_HOME environment variable is not set,
/// it will throw an ExitException.error().
void loadEnvironmentVars() {
  if (_serverpodHome != null) {
    return;
  }

  if (!productionMode) {
    var home = Platform.environment['SERVERPOD_HOME'];

    if (home == null || home == '') {
      log.error(
        'The "SERVERPOD_HOME" environmental variable is required in development mode.',
      );
      throw ExitException.error();
    } else if (!Directory(home).existsSync()) {
      log.error(
        'The "SERVERPOD_HOME" environmental variable points to a non-existent directory: "$home"',
      );
      throw ExitException.error();
    }

    log.debug('Set "SERVERPOD_HOME" to "$home"');
    _serverpodHome = home;
  }

  _serverpodHome ??= '';
  return;
}

import 'dart:async';

import 'package:cli_tools/config.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

class VersionCommand extends ServerpodCommand {
  static const usageDescription =
      'Prints the active version of the Serverpod CLI.';

  @override
  final name = 'version';

  @override
  final description = usageDescription;

  @override
  FutureOr<void>? runWithConfig(final Configuration commandConfig) {
    // The format that the version is printed in is important, as it is used by
    // the Serverpod Language Server to determine if the CLI is compatible.
    log.info('Serverpod version: $templateVersion');
  }
}

import 'dart:async';

import 'package:config/command.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

class VersionCommand extends ServerpodCommand<OptionDefinition> {
  final Version _cliVersion;
  VersionCommand(Version cliVersion)
    : _cliVersion = cliVersion,
      super(options: []);

  static const usageDescription =
      'Prints the active version of the Serverpod CLI.';

  @override
  final name = 'version';

  @override
  final description = usageDescription;

  @override
  Future<void> run(CommandContext<OptionDefinition, void> context) async {
    printServerpodCliVersion(_cliVersion);
  }
}

/// Prints the active CLI version.
///
/// The format is important: the Serverpod Language Server uses it to decide
/// whether the CLI is compatible.
void printServerpodCliVersion(Version version) {
  log.info('Serverpod version: $version');
}

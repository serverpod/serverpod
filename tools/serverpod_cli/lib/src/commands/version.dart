import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/logger/logger.dart';

class VersionCommand extends Command {
  @override
  final name = 'version';

  @override
  final description = 'Prints the active version of the Serverpod CLI.';

  @override
  void run() {
    log.info('Serverpod version: $templateVersion');
  }
}

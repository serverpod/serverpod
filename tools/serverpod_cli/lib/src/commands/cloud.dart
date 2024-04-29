import 'package:serverpod_cli/src/commands/cloud/login.dart';
import 'package:serverpod_cli/src/commands/cloud/logout.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

class CloudCommand extends ServerpodCommand {
  @override
  final name = 'cloud';

  @override
  final description = 'Manage cloud resources.';

  CloudCommand() {
    addSubcommand(CloudLoginCommand());
    addSubcommand(CloudLogoutCommand());
  }
}

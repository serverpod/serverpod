import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/status.dart';

/// The commands that act on the development stack: the runner itself, and the
/// clients that drive one.
///
/// A group rather than a command. `runner` names the thing acted on, and each
/// verb under it is an action on that runner.
class RunnerCommand extends ServerpodCommand<OptionDefinition> {
  RunnerCommand() : super(options: const []) {
    addSubcommand(StatusCommand());
  }

  @override
  final name = 'runner';

  @override
  final description = 'Manage the development stack for this project.';

  @override
  void runWithConfig(Configuration<OptionDefinition> commandConfig) {}
}

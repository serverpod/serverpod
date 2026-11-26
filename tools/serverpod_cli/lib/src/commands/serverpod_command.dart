import 'dart:async';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/command.dart';
import 'package:config/config.dart';

abstract class ServerpodCommand<O extends OptionDefinition>
    extends BetterCommand<O, void> {
  /// The shell exit code for a command that was found but cannot execute.
  static const int commandInvokedCannotExecute = 126;

  ServerpodCommand({super.options});

  /// Runs this command. Leaf commands override this method.
  ///
  /// A branch command is never run: a command line that ends on it is a usage
  /// error.
  @override
  FutureOr<void> run(CommandContext<O, void> context) =>
      throw UnsupportedError('Branch command $name should not be run.');
}

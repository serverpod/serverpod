import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

abstract class ServerpodCommand extends BetterCommand {
  /// Exit code for when a command is invoked but cannot execute.
  static const int commandInvokedCannotExecute = 126;

  ServerpodCommand()
      : super(
          wrapTextColumn: log.wrapTextColumn,
          passOutput: MessageOutput(logUsage: log.info),
        );
}

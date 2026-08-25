import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import 'serverpod_command_runner.dart';

abstract class ServerpodCommand<O extends OptionDefinition>
    extends BetterCommand<O, void> {
  /// Shell convention for a command found but not executable.
  static const int commandInvokedCannotExecute = 126;

  /// The [ServerpodCommandRunner] running this command.
  ServerpodCommandRunner get serverpodRunner =>
      runner as ServerpodCommandRunner;

  ServerpodCommand({
    super.options,
  }) : super(
         wrapTextColumn: log.wrapTextColumn,
       );

  /// This command's usage text, with the runner's global options appended.
  ///
  /// `args` lists only a command's own options, so a command's `--help` would
  /// otherwise omit globals like `--no-interactive`.
  @override
  String get usage {
    final baseUsage = super.usage;

    final runner = this.runner;
    if (runner is! ServerpodCommandRunner) return baseUsage;

    final globalOptionsParser = ArgParser(
      usageLineLength: argParser.usageLineLength,
    );
    prepareOptionsForParsing(runner.globalOptions, globalOptionsParser);

    return '$baseUsage\n\nGlobal options:\n${globalOptionsParser.usage}';
  }
}

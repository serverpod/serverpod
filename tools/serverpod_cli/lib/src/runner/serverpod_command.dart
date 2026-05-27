import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import 'serverpod_command_runner.dart';

abstract class ServerpodCommand<O extends OptionDefinition>
    extends BetterCommand<O, void> {
  /// Exit code for when a command is invoked but cannot execute.
  static const int commandInvokedCannotExecute = 126;

  /// Returns the [ServerpodCommandRunner] instance running this command.
  ServerpodCommandRunner get serverpodRunner =>
      runner as ServerpodCommandRunner;

  ServerpodCommand({
    super.options,
  }) : super(
         wrapTextColumn: log.wrapTextColumn,
       );

  /// The global options (e.g. `--no-interactive`) apply to every command, but
  /// the `args` package only lists a command's own options in its usage and
  /// merely points to the top-level help for the rest. Append the global
  /// options to the command usage so they are discoverable directly from
  /// `serverpod <command> --help`.
  @override
  String get usage {
    final baseUsage = super.usage;

    final runner = this.runner;
    if (runner is! ServerpodCommandRunner) return baseUsage;

    final globalOptionsParser = ArgParser(
      usageLineLength: argParser.usageLineLength,
    );
    prepareOptionsForParsing(runner.globalOptions, globalOptionsParser);
    final globalOptionsSection =
        'Global options:\n${globalOptionsParser.usage}';

    // Replace the `args` note that points to the top-level help with the
    // global options themselves, falling back to appending them if the note
    // can no longer be found.
    final globalOptionsNote = RegExp(
      r'Run\s+"\S+\s+help"\s+to\s+see\s+global\s+options\.',
    );
    if (baseUsage.contains(globalOptionsNote)) {
      return baseUsage.replaceFirst(globalOptionsNote, globalOptionsSection);
    }

    return '$baseUsage\n\n$globalOptionsSection';
  }
}

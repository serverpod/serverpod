import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

abstract class ServerpodCommand extends Command {
  @override
  void printUsage() {
    log.info(usage);
  }

  @override
  ArgParser get argParser => _argParser;
  final ArgParser _argParser = ArgParser(usageLineLength: log.wrapTextColumn);
}

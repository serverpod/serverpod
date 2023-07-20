import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/logger/logger.dart';

abstract class ServerpodCommand extends Command {
  @override
  void printUsage() {
    log.info(usage, style: const RawLog());
  }

  @override
  ArgParser get argParser => _argParser;
  final ArgParser _argParser = ArgParser(usageLineLength: log.wrapTextColumn);
}

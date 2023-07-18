import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/analytics.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/update_prompt/prompt_to_update.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';

abstract class GlobalFlags {
  static const developmentPrint = 'development-print';
}

class ServerpodCommandRunner extends CommandRunner {
  final Analytics _analytics;
  final bool _productionMode;
  ServerpodCommandRunner(
    this._analytics,
    this._productionMode,
    super.executableName,
    super.description,
  ) {
    argParser.addFlag(
      GlobalFlags.developmentPrint,
      defaultsTo: true,
      negatable: true,
      help: 'Prints additional information useful for development.',
    );
  }

  static ServerpodCommandRunner createCommandRunner(
    Analytics analytics,
    bool productionMode,
  ) {
    return ServerpodCommandRunner(
      analytics,
      productionMode,
      'serverpod',
      'Manage your serverpod app development',
    );
  }

  @override
  ArgResults parse(Iterable<String> args) {
    try {
      return super.parse(args);
    } on UsageException catch (e) {
      _analytics.track(event: 'invalid');
      log.error(e.toString(), style: const LogStyle());
      throw ExitException(ExitCodeType.commandNotFound);
    }
  }

  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    // TODO: [GlobalFlags.developmentPrint] should silence all logging with a
    // suitable name. Make this once we have a centralized logging and printing.
    if (topLevelResults[GlobalFlags.developmentPrint] && _productionMode) {
      await _preCommandPrints();
    }

    try {
      await super.runCommand(topLevelResults);
      if (topLevelResults.command == null) {
        _analytics.track(event: 'help');
      } else {
        _analytics.track(event: topLevelResults.command!.name!);
      }
    } on UsageException catch (e) {
      log.error(e.toString(), style: const LogStyle());
      _analytics.track(event: 'invalid');
      throw ExitException(ExitCodeType.commandNotFound);
    }
  }

  @override
  void printUsage() {
    log.info(usage, style: const LogStyle());
  }

  @override
  ArgParser get argParser => _argParser;
  final ArgParser _argParser = ArgParser(usageLineLength: log.wrapTextColumn);

  Future<void> _preCommandPrints() async {
    if (!_productionMode) {
      log.debug(
        'Development mode. Using templates from: ${resourceManager.templateDirectory.path}',
      );
      log.debug('SERVERPOD_HOME is set to $serverpodHome');

      if (!resourceManager.isTemplatesInstalled) {
        log.warning('Could not find templates.');
      }
    } else {
      await promptToUpdateIfNeeded(Version.parse(templateVersion));
    }
  }
}

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/generate_pubspecs.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/util/print.dart';

import 'analytics/analytics.dart';
import 'downloads/resource_manager.dart';
import 'generated/version.dart';
import 'shared/environment.dart';
import 'util/command_line_tools.dart';

late Analytics analytics;

class CliCommandRunner extends CommandRunner<int> {
  CliCommandRunner()
      : super(
          'serverpod',
          'A command-line utility for Serverpod development.',
        ) {
    addCommand(VersionCommand());
    addCommand(CreateCommand());
    addCommand(GenerateCommand());
    addCommand(GeneratePubspecsCommand());
  }

  @override
  Future<int> run(Iterable<String> args) async {
    analytics = Analytics();

    if (Platform.isWindows) {
      printwwln('WARNING! Windows is not officially supported yet. '
          'Things may or may not work as expected.');
    }

    // Check that required tools are installed
    if (!await CommandLineTools.existsCommand('dart')) {
      printww(
          'Failed to run serverpod. You need to have dart installed and in your'
          ' \$PATH');
      return -1;
    }
    if (!await CommandLineTools.existsCommand('flutter')) {
      printww(
          'Failed to run serverpod. You need to have flutter installed and in '
          'your \$PATH');
      return -1;
    }

    if (!loadEnvironmentVars()) {
      return -1;
    }

    // Make sure all necessary downloads are installed
    if (!productionMode) {
      printww('Development mode. Using templates from: '
          '${resourceManager.templateDirectory.path}');
      printww('SERVERPOD_HOME is set to $serverpodHome');
      if (!resourceManager.isTemplatesInstalled) {
        printww('WARNING! Could not find templates.');
      }
    }

    if (!resourceManager.isTemplatesInstalled) {
      try {
        await resourceManager.installTemplates();
      } catch (e) {
        printww('Failed to download templates.');
      }

      if (!resourceManager.isTemplatesInstalled) {
        printww('Could not download the required resources for Serverpod. '
            'Make sure that you are connected to the internet and that you are '
            'using the latest version of Serverpod.');
        return -1;
      }
    }

    var result = await super.run(args);

    if (result == null) {
      analytics.track(event: 'invalid');
      return -1;
    } else {
      return 0;
    }
  }

  @override
  void printUsage() {
    super.printUsage();
    analytics.track(event: 'help');
  }
}

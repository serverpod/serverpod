import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/command_runner.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/generator/generator_continuous.dart';

class GenerateCommand extends Command<int> {
  GenerateCommand() {
    argParser
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Output more detailed information',
      )
      ..addFlag(
        'watch',
        abbr: 'w',
        negatable: false,
        help: 'Watch for changes and continuously generate code.',
      );
  }

  @override
  String get name => 'generate';

  @override
  String get description =>
      'Generate code from yaml files for server and clients.';

  @override
  FutureOr<int> run() async {
    analytics.track(event: name);

    var verbose = argResults!.command!['verbose'];
    var watch = argResults!.command!['watch'];

    // TODO: add a -d option to select the directory
    var config = GeneratorConfig.load();
    if (config == null) {
      return -1;
    }

    var endpointsAnalyzer = EndpointsAnalyzer(config);

    await performGenerate(
      verbose: verbose,
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
    );
    if (watch) {
      print('Initial code generation complete. Listening for changes.');
      performGenerateContinuously(
        verbose: verbose,
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
      );
    } else {
      print('Done.');
    }
    return 0;
  }
}

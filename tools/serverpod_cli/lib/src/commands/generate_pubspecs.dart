import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/command_runner.dart';
import 'package:serverpod_cli/src/internal_tools/generate_pubspecs.dart';

class GeneratePubspecsCommand extends Command<int> {
  GeneratePubspecsCommand() {
    argParser
      ..addOption(
        'version', mandatory: true,
        // help: '',
      )
      ..addOption(
        'mode',
        allowed: ['development', 'production'],
        // help: '',
      );
  }

  @override
  String get name => 'generate-pubspecs';

  @override
  String get description => 'Internal tool for maintaining files in the '
      'Serverpod repository.';

  @override
  bool get hidden => true;

  @override
  FutureOr<int> run() async {
    analytics.track(event: name);

    performGeneratePubspecs(
      argResults!.command!['version'],
      argResults!.command!['mode'],
    );

    //TODO: return error code on failure.
    return 0;
  }
}

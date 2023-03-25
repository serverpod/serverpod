import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/command_runner.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/util/print.dart';

class VersionCommand extends Command<int> {
  @override
  String get name => 'version';

  @override
  String get description => 'Prints the active version of the Serverpod CLI.';

  @override
  FutureOr<int> run() async {
    analytics.track(event: name);

    printww('Serverpod version: $templateVersion');
    return 0;
  }
}

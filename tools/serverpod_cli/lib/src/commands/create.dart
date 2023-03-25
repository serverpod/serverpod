import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/command_runner.dart';

import '../create/create.dart';

class CreateCommand extends Command<int> {
  CreateCommand() {
    argParser
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Output more detailed information',
      )
      ..addFlag(
        'force',
        abbr: 'f',
        negatable: false,
        help: 'Create the project even if there are issues that prevents if '
            'from running out of the box',
      )
      ..addOption('template',
          abbr: 't',
          defaultsTo: 'server',
          allowed: ['server', 'module'],
          help: 'Template to use when creating a new project.',
          allowedHelp: {
            'server': 'Create a project using Serverpod.',
            'module': 'Create a module that can be used in other Serverpod'
                'projects.',
          });
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Creates a new Serverpod project, specify project '
      'name (must be lowercase with no special characters).';

  @override
  String get invocation {
    var parents = [name];
    for (var command = parent; command != null; command = command.parent) {
      parents.add(command.name);
    }
    parents.add(runner!.executableName);

    var invocation = parents.reversed.join(' ');
    return '$invocation [arguments] <project name>';
  }

  @override
  FutureOr<int> run() async {
    analytics.track(event: this.name);

    if (argResults!.rest.length != 1) {
      printUsage();
      return -1;
    }

    var name = argResults!.rest.single;
    bool verbose = argResults!.command!['verbose'];
    String template = argResults!.command!['template'];
    bool force = argResults!.command!['force'];

    if (name == 'server' || name == 'module' || name == 'create') {
      printUsage();
      return -1;
    }

    var re = RegExp(r'^[a-z0-9_]+$');
    if (re.hasMatch(name)) {
      await performCreate(name, verbose, template, force);
      return 0;
    }

    printUsage();
    return -1;
  }
}

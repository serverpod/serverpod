import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/create/create.dart';

class CreateCommand extends Command {
  @override
  final name = 'create';

  @override
  final description =
      'Creates a new Serverpod project, specify project name (must be lowercase with no special characters).';

  CreateCommand() {
    argParser.addFlag('verbose',
        abbr: 'v', negatable: false, help: 'Output more detailed information.');
    argParser.addFlag(
      'force',
      abbr: 'f',
      negatable: false,
      help:
          'Create the project even if there are issues that prevents if from running out of the box.',
    );
    argParser.addOption(
      'template',
      abbr: 't',
      defaultsTo: 'server',
      allowed: <String>['server', 'module'],
      help:
          'Template to use when creating a new project, valid options are "server" or "module".',
    );
  }

  @override
  Future run() async {
    var name = argResults!.arguments.last;
    bool verbose = argResults!['verbose'];
    String template = argResults!['template'];
    bool force = argResults!['force'];

    if (name == 'server' || name == 'module' || name == 'create') {
      // TODO: Use built in usage printer
      // _printUsage(parser);
      return;
    }

    await performCreate(name, verbose, template, force);
  }
}

import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

class CreateCommand extends ServerpodCommand {
  @override
  final name = 'create';

  @override
  final description =
      'Creates a new Serverpod project, specify project name (must be lowercase with no special characters).';

  CreateCommand() {
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
  Future<void> run() async {
    var name = argResults!.arguments.last;
    String template = argResults!['template'];
    bool force = argResults!['force'];

    if (name == 'server' || name == 'module' || name == 'create') {
      printUsage();
      return;
    }

    await performCreate(name, template, force);
  }
}

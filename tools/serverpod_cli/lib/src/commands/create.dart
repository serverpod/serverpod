import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';

class CreateCommand extends ServerpodCommand {
  final templateTypes =
      ServerpodTemplateType.values.map((t) => t.name).toList();

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
      defaultsTo: ServerpodTemplateType.server.name,
      allowed: templateTypes,
      help:
          'Template to use when creating a new project, valid options are "server" or "module".',
    );
  }

  @override
  Future<void> run() async {
    var rest = argResults?.rest;

    if (rest == null || rest.isEmpty) {
      log.error('Project name missing.');
      printUsage();
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    if (rest.length > 1) {
      log.error('Multiple project names specified, please specify only.');
      printUsage();
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    var name = rest.last;
    var template = ServerpodTemplateType.tryParse(argResults!['template']);
    bool force = argResults!['force'];

    if (template == null || templateTypes.contains(name) || name == 'create') {
      printUsage();
      return;
    }

    if (!await performCreate(name, template, force)) {
      throw ExitException();
    }
  }
}

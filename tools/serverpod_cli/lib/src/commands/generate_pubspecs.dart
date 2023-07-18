import 'package:serverpod_cli/src/internal_tools/generate_pubspecs.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';

class GeneratePubspecsCommand extends ServerpodCommand {
  @override
  final name = 'generate-pubspecs';

  @override
  final description = '';

  GeneratePubspecsCommand() {
    argParser.addOption('version', defaultsTo: 'X');
    argParser.addOption(
      'mode',
      defaultsTo: 'development',
      allowed: ['development', 'production'],
    );
  }

  @override
  void run() {
    if (argResults!['version'] == 'X') {
      log.error('--version is not specified');
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }
    performGeneratePubspecs(argResults!['version'], argResults!['mode']);
  }
}

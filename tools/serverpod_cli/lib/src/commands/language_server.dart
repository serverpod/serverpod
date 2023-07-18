import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/language_server/language_server.dart';

class LanguageServerCommand extends Command {
  @override
  final name = 'language-server';

  @override
  final description =
      'Launches a serverpod language server communicating with JSON-RPC-2 intended to be used with a client integrated in an IDE.';

  LanguageServerCommand() {
    argParser.addFlag(
      'stdio',
      defaultsTo: true,
      help: 'Use stdin/stdout channels for communication.',
    );
  }

  @override
  Future run() async {
    await runLanguageServer();
  }
}

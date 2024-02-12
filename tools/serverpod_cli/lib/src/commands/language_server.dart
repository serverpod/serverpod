import 'package:serverpod_cli/src/language_server/language_server.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

class LanguageServerCommand extends ServerpodCommand {
  static String commandName = 'language-server';

  @override
  final name = commandName;

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
  Future<void> run() async {
    await runLanguageServer();
  }
}

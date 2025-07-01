import 'package:cli_tools/config.dart';
import 'package:serverpod_cli/src/language_server/language_server.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

enum LanguageServerOption<V> implements OptionDefinition<V> {
  // This option has no effect! Kept for possible backwards compatibility.
  stdio(FlagOption(
    argName: 'stdio',
    defaultsTo: true,
  ));

  const LanguageServerOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class LanguageServerCommand extends ServerpodCommand<LanguageServerOption> {
  static const String commandName = 'language-server';

  @override
  final name = commandName;

  @override
  final description =
      'Launches a serverpod language server communicating with JSON-RPC-2 intended to be used with a client integrated in an IDE.';

  LanguageServerCommand() : super(options: LanguageServerOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<LanguageServerOption> commandConfig,
  ) async {
    await runLanguageServer();
  }
}

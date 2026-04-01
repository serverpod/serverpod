import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/platform_check.dart';

/// Options for the `mcp` command.
enum McpOption<V> implements OptionDefinition<V> {
  directory(
    StringOption(
      argName: 'directory',
      argAbbrev: 'd',
      defaultsTo: '',
      helpText:
          'The server directory (defaults to auto-detect from current directory).',
    ),
  );

  const McpOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Connects to a running serverpod watch instance's MCP socket and bridges
/// stdin/stdout for use as an MCP transport.
class McpCommand extends ServerpodCommand<McpOption> {
  @override
  final name = 'mcp';

  @override
  final description =
      "Create stdio bridge to a running `serverpod start --watch` process's MCP server.";

  @override
  String get invocation => 'serverpod mcp';

  McpCommand() : super(options: McpOption.values);

  @override
  Configuration<McpOption> resolveConfiguration(ArgResults? argResults) {
    return Configuration.resolveNoExcept(
      options: options,
      argResults: argResults,
      env: envVariables,
    );
  }

  @override
  Future<void> runWithConfig(Configuration<McpOption> commandConfig) async {
    final directory = commandConfig.value(McpOption.directory);

    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load(
        serverRootDir: directory,
        interactive: interactive,
      );
    } catch (e) {
      stderr.writeln('$e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
    final socketPath = p.join(serverDir, '.dart_tool', 'serverpod', 'mcp.sock');

    // Connect to the Unix socket. The existence check is a fast-fail for a
    // better error message, but the socket could disappear between the check
    // and the connect (TOCTOU), so we catch SocketException too.
    if (FileSystemEntity.typeSync(socketPath) ==
        FileSystemEntityType.notFound) {
      stderr.writeln(
        'No running serverpod watch instance found.\n'
        'Start one with: serverpod start --watch',
      );
      throw ExitException.error();
    }

    Socket socket;
    try {
      socket = await connectUnixSocket(socketPath);
    } on SocketException {
      stderr.writeln(
        'No running serverpod watch instance found.\n'
        'Start one with: serverpod start --watch',
      );
      throw ExitException.error();
    }

    // stdin -> socket. Close socket on stdin EOF so the server sees disconnect.
    final stdinSub = stdin.listen(
      socket.add,
      onDone: () => socket.close(),
    );

    // socket -> stdout (with explicit flush for non-TTY stdout).
    try {
      await for (final data in socket) {
        stdout.add(data);
        await stdout.flush();
      }
    } finally {
      await stdinSub.cancel();
    }
  }
}

import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:serverpod_cli/src/config/config.dart'
    show ServerpodProjectNotFoundException;
import 'package:serverpod_cli/src/mcp/bridge_mcp_server.dart';
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show hasUnixSocketSupport;

/// Options for the `mcp-server` command.
enum McpOption<V> implements OptionDefinition<V> {
  serverDir(
    StringOption(
      argName: 'server-dir',
      argAbbrev: 's',
      helpText:
          'Path to the server project directory (the package that contains '
          'a `serverpod` dependency). Auto-detected from the current '
          'working directory if omitted. Pass this flag explicitly in '
          'monorepos with multiple server projects.',
    ),
  ),
  ;

  const McpOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Long-lived stdio MCP server that proxies to a single
/// `serverpod start --watch` instance.
///
/// The runner's MCP socket lives at `<serverDir>/.dart_tool/serverpod/mcp.sock`.
/// The bridge auto-connects on the first tool/resource call and reconnects
/// transparently if the runner restarts. There is no `connect`/`spawn`
/// surface - one bridge per server project, configured per entry in the
/// agent's MCP config.
class McpCommand extends ServerpodCommand<McpOption> {
  @override
  final name = 'mcp-server';

  @override
  final description =
      'Start an MCP bridge to the `serverpod start` runner of one '
      'server project.';

  @override
  String get invocation => 'serverpod mcp-server';

  McpCommand() : super(options: McpOption.values);

  @override
  Future<void> runWithConfig(Configuration<McpOption> commandConfig) async {
    if (!hasUnixSocketSupport()) {
      log.error(
        'The serverpod MCP bridge requires Unix domain socket support, '
        'which on Windows requires Dart 3.11+ '
        '(current: ${Platform.version.split(' ').first}).',
      );
      throw ExitException.error();
    }

    final explicit = commandConfig.optionalValue(McpOption.serverDir);
    final Directory serverDir;
    try {
      serverDir = await ServerDirectoryFinder.findOrPrompt(
        startDir: (explicit != null && explicit.isNotEmpty)
            ? Directory(explicit)
            : null,
        interactive: false,
      );
    } on ServerpodProjectNotFoundException catch (e) {
      log.error('${e.message}\nPass --server-dir <path> to point at one.');
      throw ExitException.error();
    }

    final socketPath = serverpodMcpSocketPath(serverDir.path);
    final channel = stdioChannel(input: stdin, output: stdout);
    final server = BridgeMcpServer(channel, socketPath: socketPath);
    await server.done;
  }
}

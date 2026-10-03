import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/status.dart'
    show resolveServerDirectory;
import 'package:serverpod_cli/src/mcp/bridge_mcp_server.dart';
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

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
    final serverDir = await resolveServerDirectory(
      commandConfig.optionalValue(McpOption.serverDir),
      flag: '--server-dir',
    );

    final String socketPath;
    try {
      socketPath = runnerSocketPath(
        serverDir.path,
        serverpodMcpSocketName,
        projectId: RunnerRegistry.idFor(serverDir.path),
      );
    } on SocketException catch (e) {
      log.error(e.message);
      throw ExitException.error();
    }
    final channel = stdioChannel(input: stdin, output: stdout);
    final server = BridgeMcpServer(channel, socketPath: socketPath);
    await server.done;
  }
}

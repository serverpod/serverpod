import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:serverpod_cli/src/mcp/bridge_mcp_server.dart';
import 'package:serverpod_cli/src/mcp/serverpod_mcp_bridge.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/platform_check.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

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
  ),
  ;

  const McpOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Long-lived stdio MCP server that bridges to running
/// `serverpod start --watch` instances.
///
/// Discovers instances via the shared socket directory, lets the client
/// pick one with the `connect` tool, and forwards tool calls to it.
/// Survives runner restarts - the client can `connect` again after the
/// runner comes back up without restarting the bridge.
class McpCommand extends ServerpodCommand {
  @override
  final name = 'mcp';

  @override
  final description =
      'Start an MCP bridge that discovers running '
      '`serverpod start --watch` instances and forwards tool calls to one '
      'at a time.';

  @override
  String get invocation => 'serverpod mcp';

  @override
  Future<void> runWithConfig(Configuration commandConfig) async {
    if (!hasUnixSocketSupport()) {
      log.error(
        'The serverpod MCP bridge requires Unix domain socket support, '
        'which on Windows requires Dart 3.11+ '
        '(current: ${Platform.version.split(' ').first}).',
      );
      throw ExitException.error();
    }

    final bridge = ServerpodMcpBridge();
    await bridge.scan();
    bridge.startWatching();

    final channel = stdioChannel(input: stdin, output: stdout);
    final server = BridgeMcpServer(channel, bridge: bridge);

    // Block until the MCP client (stdin) disconnects, then shut everything
    // down cleanly.
    await server.done;
    await bridge.dispose();
  }
}

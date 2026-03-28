import 'package:dart_mcp/server.dart';
import 'package:serverpod_cli/src/generated/version.dart';

/// MCP server that exposes serverpod dev tools.
///
/// Runs inside the CLI process during watch mode, letting AI agents trigger
/// operations that require explicit intent (like applying migrations).
base class ServerpodMcpServer extends MCPServer with ToolsSupport {
  /// Callback to apply pending database migrations.
  Future<void> Function()? onApplyMigration;

  ServerpodMcpServer(super.channel)
    : super.fromStreamChannel(
        implementation: Implementation(
          name: 'serverpod',
          version: templateVersion,
        ),
        instructions:
            'Manage a running Serverpod server process started by '
            '`serverpod start --watch`.',
      ) {
    registerTool(_applyMigrationsTool, _applyMigrations);
  }

  static final _applyMigrationsTool = Tool(
    name: 'apply_migrations',
    description:
        'Apply pending database migrations. The server restarts with '
        '`--apply-migrations`. Call after creating a migration with '
        '`serverpod create-migration`.',
    inputSchema: Schema.object(),
  );

  Future<CallToolResult> _applyMigrations(CallToolRequest request) async {
    final callback = onApplyMigration;
    if (callback == null) {
      return CallToolResult(
        content: [TextContent(text: 'Watch session not connected.')],
        isError: true,
      );
    }

    try {
      await callback();
      return CallToolResult(
        content: [
          TextContent(
            text:
                'Migrations applied. The database schema now matches the '
                'latest migration definitions.',
          ),
        ],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to apply migrations: $e')],
        isError: true,
      );
    }
  }
}

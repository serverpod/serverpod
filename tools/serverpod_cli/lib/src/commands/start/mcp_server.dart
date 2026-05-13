import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/server.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_shared/log.dart';

/// Result of a `create_migration` MCP call. [message] is returned to the
/// caller verbatim; [isError] marks the tool result as an error.
class CreateMigrationMcpResult {
  const CreateMigrationMcpResult({
    required this.message,
    this.isError = false,
  });

  final String message;
  final bool isError;
}

/// MCP server that exposes serverpod dev tools.
///
/// Runs inside the CLI process during watch mode, letting AI agents trigger
/// operations that require explicit intent (like applying migrations).
base class ServerpodMcpServer extends MCPServer
    with ToolsSupport, ResourcesSupport {
  /// Callback to apply pending database migrations.
  Future<void> Function()? onApplyMigration;

  /// Callback to create a new migration from the current model definitions.
  /// Returns a human-readable status message describing the outcome.
  Future<CreateMigrationMcpResult> Function({String? tag, bool force})?
  onCreateMigration;

  /// Callback to recompile and hot-reload the running server isolate.
  Future<void> Function()? onHotReload;

  /// Returns the current log history snapshot.
  List<Object> Function()? getLogHistory;

  /// Returns the current HTTP VM service URI, or `null` if not yet available.
  String? Function()? getVmServiceUri;

  StreamSubscription<void>? _vmServiceUriSub;

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
    registerTool(_createMigrationTool, _createMigration);
    registerTool(_hotReloadTool, _hotReload);
    registerTool(_tailLogsTool, _tailLogs);

    addResource(_vmServiceResource, _readVmService);
  }

  /// Wires a stream whose events signal that the VM service URI has changed.
  /// Each event triggers a resource-updated notification for
  /// `serverpod://vm-service`.
  set vmServiceUriChanges(Stream<void>? stream) {
    _vmServiceUriSub?.cancel();
    _vmServiceUriSub = stream?.listen((_) {
      if (ready) updateResource(_vmServiceResource);
    });
  }

  @override
  Future<void> shutdown() async {
    await _vmServiceUriSub?.cancel();
    _vmServiceUriSub = null;
    await super.shutdown();
  }

  static final _applyMigrationsTool = Tool(
    name: 'apply_migrations',
    description:
        'Apply pending database migrations. The server restarts with '
        '`--apply-migrations`. Call after `create_migration` (or '
        '`serverpod create-migration`) has written the migration files.',
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

  static final _createMigrationTool = Tool(
    name: 'create_migration',
    description:
        'Create a new database migration from the current model definitions. '
        'Writes the migration files to disk; does not restart the server or '
        'apply the migration. Follow up with `apply_migrations` to run it '
        'against the database.',
    inputSchema: Schema.object(
      properties: {
        'tag': Schema.string(
          description: 'Optional tag appended to the migration version name.',
        ),
        'force': Schema.bool(
          description:
              'Create the migration even if warnings are present (data may '
              'be destroyed).',
        ),
      },
    ),
  );

  Future<CallToolResult> _createMigration(CallToolRequest request) async {
    final callback = onCreateMigration;
    if (callback == null) {
      return CallToolResult(
        content: [TextContent(text: 'Watch session not connected.')],
        isError: true,
      );
    }

    final tagArg = request.arguments?['tag'];
    final forceArg = request.arguments?['force'];
    final tag = tagArg is String && tagArg.isNotEmpty ? tagArg : null;
    final force = forceArg is bool ? forceArg : false;

    try {
      final result = await callback(tag: tag, force: force);
      return CallToolResult(
        content: [TextContent(text: result.message)],
        isError: result.isError ? true : null,
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to create migration: $e')],
        isError: true,
      );
    }
  }

  static final _vmServiceResource = Resource(
    uri: 'serverpod://vm-service',
    name: 'VM service',
    description:
        'Dart VM service HTTP URI for the running server isolate. Stable '
        'across hot reloads; changes on restart (apply_migrations, crash '
        'recovery). Subscribe to be notified when the URI changes.',
    mimeType: 'application/json',
  );

  ReadResourceResult _readVmService(ReadResourceRequest request) {
    final uri = getVmServiceUri?.call();
    return ReadResourceResult(
      contents: [
        TextResourceContents(
          uri: request.uri,
          text: jsonEncode({'uri': uri}),
        ),
      ],
    );
  }

  static final _hotReloadTool = Tool(
    name: 'hot_reload',
    description:
        'Recompile the server kernel and hot-reload the running isolate. '
        'Falls back to a full restart if reload is not possible.',
    inputSchema: Schema.object(),
  );

  Future<CallToolResult> _hotReload(CallToolRequest request) async {
    final callback = onHotReload;
    if (callback == null) {
      return CallToolResult(
        content: [TextContent(text: 'Watch session not connected.')],
        isError: true,
      );
    }
    try {
      await callback();
      return CallToolResult(
        content: [TextContent(text: 'Hot reload completed.')],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Hot reload failed: $e')],
        isError: true,
      );
    }
  }

  static final _tailLogsTool = Tool(
    name: 'tail_logs',
    description:
        'Return recent log entries from the running watch session '
        '(structured log entries plus completed operations). Newest last.',
    inputSchema: Schema.object(
      properties: {
        'limit': Schema.int(
          description: 'Max entries to return (default 200, max 10000).',
          minimum: 1,
          maximum: 10000,
        ),
      },
    ),
  );

  Future<CallToolResult> _tailLogs(CallToolRequest request) async {
    final get = getLogHistory;
    if (get == null) {
      return CallToolResult(
        content: [TextContent(text: 'Log history not available.')],
        isError: true,
      );
    }
    final limitArg = request.arguments?['limit'];
    final limit = switch (limitArg) {
      int v => v.clamp(1, 10000),
      _ => 200,
    };
    final all = get();
    final tail = all.length <= limit ? all : all.sublist(all.length - limit);
    final encoded = tail.map(_encodeLogHistoryItem).toList();
    return CallToolResult(
      content: [
        TextContent(
          text: jsonEncode(encoded, toEncodable: (o) => o.toString()),
        ),
      ],
    );
  }
}

Map<String, Object?> _encodeLogHistoryItem(Object item) {
  if (item is LogEntry) {
    return {
      'type': 'log',
      'time': item.time.toIso8601String(),
      'level': item.level.name,
      'message': item.message,
      'scope': {'id': item.scope.id, 'label': item.scope.label},
      if (item.error != null) 'error': item.error.toString(),
      if (item.stackTrace != null) 'stackTrace': item.stackTrace.toString(),
      if (item.metadata != null) 'metadata': item.metadata,
    };
  }
  if (item is CompletedOperation) {
    return {
      'type': 'operation',
      'label': item.label,
      'success': item.success,
      'durationMs': item.duration.inMilliseconds,
      'completedAt': item.completedAt.toIso8601String(),
    };
  }
  return {'type': 'unknown', 'value': item.toString()};
}

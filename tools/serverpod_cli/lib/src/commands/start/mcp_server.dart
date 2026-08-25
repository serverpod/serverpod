import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/server.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/mcp/runner_surface.dart';
import 'package:serverpod_cli/src/runner/migration_result.dart';
import 'package:serverpod_cli/src/runner/runner_api.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// MCP server that exposes serverpod dev tools.
///
/// Runs inside the CLI process during watch mode, letting AI agents trigger
/// operations that require explicit intent (like applying migrations).
base class ServerpodMcpServer extends MCPServer
    with ToolsSupport, ResourcesSupport {
  InProcessRunnerApi? _runner;
  StreamSubscription<void>? _vmServiceUriSub;

  ServerpodMcpServer(super.channel)
    : super.fromStreamChannel(
        implementation: Implementation(
          name: 'serverpod',
          version: templateVersion,
        ),
        instructions:
            'Manage a running Serverpod server process started by '
            '`serverpod start`.',
      ) {
    registerTool(applyMigrationsTool, _applyMigrations);
    registerTool(createMigrationTool, _createMigration);
    registerTool(createRepairMigrationTool, _createRepairMigration);
    registerTool(hotReloadTool, _hotReload);
    registerTool(hotRestartTool, _hotRestart);
    registerTool(tailLogsTool, _tailLogs);
    registerTool(tailFlutterLogsTool, _tailFlutterLogs);
    registerTool(spawnFlutterAppTool, _spawnFlutterApp);
    registerTool(getFlutterAppDtdTool, _getFlutterAppDtd);

    addResource(vmServiceResource, _readVmService);
  }

  /// The runner this server exposes, or `null` before the watch session has
  /// attached.
  ///
  /// Every tool reports [_notConnectedError] until it is set.
  ///
  /// Setting it also subscribes to [RunnerApi.vmServiceUriChanges], so a
  /// restart or crash recovery raises a resource-updated notification for
  /// `serverpod://vm-service`.
  set runner(InProcessRunnerApi? runner) {
    _runner = runner;
    _vmServiceUriSub?.cancel();
    _vmServiceUriSub = runner?.vmServiceUriChanges.listen((_) {
      if (ready) updateResource(vmServiceResource);
    });
  }

  @override
  Future<void> shutdown() async {
    await _vmServiceUriSub?.cancel();
    _vmServiceUriSub = null;
    await super.shutdown();
  }

  Future<CallToolResult> _applyMigrations(CallToolRequest request) async {
    final runner = _runner;
    if (runner == null) {
      return _notConnectedError();
    }

    try {
      await runner.applyMigrations();
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

  Future<CallToolResult> _createMigration(CallToolRequest request) async {
    final runner = _runner;
    if (runner == null) {
      return _notConnectedError();
    }

    final tag = _stringArg(request, 'tag');
    final force = _boolArg(request, 'force');

    try {
      final result = await runner.createMigration(tag: tag, force: force);
      return CallToolResult(
        content: [TextContent(text: _migrationMessage(result))],
        isError: result.isError ? true : null,
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to create migration: $e')],
        isError: true,
      );
    }
  }

  Future<CallToolResult> _createRepairMigration(CallToolRequest request) async {
    final runner = _runner;
    if (runner == null) {
      return _notConnectedError();
    }

    try {
      final result = await runner.createRepairMigration(
        tag: _stringArg(request, 'tag'),
        force: _boolArg(request, 'force'),
        targetVersion: _stringArg(request, 'version'),
      );
      return CallToolResult(
        content: [TextContent(text: _migrationMessage(result))],
        isError: result.isError ? true : null,
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Failed to create repair migration: $e')],
        isError: true,
      );
    }
  }

  ReadResourceResult _readVmService(ReadResourceRequest request) {
    final uri = _runner?.vmServiceUri;
    return ReadResourceResult(
      contents: [
        TextResourceContents(
          uri: request.uri,
          text: jsonEncode({'uri': uri}),
        ),
      ],
    );
  }

  Future<CallToolResult> _hotReload(CallToolRequest request) async {
    final runner = _runner;
    if (runner == null) {
      return _notConnectedError();
    }
    try {
      await runner.hotReload();
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

  Future<CallToolResult> _hotRestart(CallToolRequest request) async {
    final runner = _runner;
    if (runner == null) {
      return _notConnectedError();
    }
    try {
      await runner.hotRestart();
      return CallToolResult(
        content: [TextContent(text: 'Hot restart completed.')],
      );
    } catch (e) {
      return CallToolResult(
        content: [TextContent(text: 'Hot restart failed: $e')],
        isError: true,
      );
    }
  }

  Future<CallToolResult> _tailLogs(CallToolRequest request) async {
    final runner = _runner;
    if (runner == null) {
      return CallToolResult(
        content: [TextContent(text: 'Log history not available.')],
        isError: true,
      );
    }
    final limit = _tailLimit(request);
    final all = runner.logHistory;
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

  Future<CallToolResult> _tailFlutterLogs(CallToolRequest request) async {
    final runner = _runner;
    if (runner == null) {
      return CallToolResult(
        content: [TextContent(text: 'Flutter log history not available.')],
        isError: true,
      );
    }
    final ids = _flutterAppIds(runner);
    if (ids.isEmpty) {
      return CallToolResult(
        content: [TextContent(text: 'No Flutter apps are configured.')],
        isError: true,
      );
    }

    // Resolve which app to read. The result shape is always a single list of
    // lines, so a null appId with more than one app is an explicit error that
    // names the available ids rather than a differently-shaped payload.
    final (appId, error) = _resolveFlutterAppId(request, ids);
    if (error != null) return error;

    final lines = runner.flutterLogHistory(appId!);

    final limit = _tailLimit(request);
    final tail = lines.length <= limit
        ? lines
        : lines.sublist(lines.length - limit);
    return CallToolResult(
      content: [TextContent(text: jsonEncode(tail))],
    );
  }

  Future<CallToolResult> _spawnFlutterApp(CallToolRequest request) async {
    final runner = _runner;
    if (runner == null) {
      return CallToolResult(
        content: [TextContent(text: 'Flutter app launching is not available.')],
        isError: true,
      );
    }
    final ids = _flutterAppIds(runner);
    if (ids.isEmpty) {
      return CallToolResult(
        content: [TextContent(text: 'No Flutter apps are configured.')],
        isError: true,
      );
    }

    // Resolve which app to launch using the same single-app/multi-app rules as
    // `tail_flutter_logs`: one configured app is implicit, a missing `appId`
    // with more than one app is an error naming the options.
    final (appId, error) = _resolveFlutterAppId(request, ids);
    if (error != null) return error;

    try {
      final alreadyRunning = await runner.launchFlutterApp(appId!);
      return CallToolResult(
        content: [
          TextContent(
            text: alreadyRunning
                ? 'Flutter app "$appId" is already running.'
                : 'Launching Flutter app "$appId". Use `tail_flutter_logs` to '
                      'follow its startup output.',
          ),
        ],
      );
    } catch (e) {
      return CallToolResult(
        content: [
          TextContent(text: 'Failed to launch Flutter app "$appId": $e'),
        ],
        isError: true,
      );
    }
  }

  Future<CallToolResult> _getFlutterAppDtd(CallToolRequest request) async {
    final runner = _runner;
    if (runner == null) {
      return CallToolResult(
        content: [TextContent(text: 'Flutter DTD not available.')],
        isError: true,
      );
    }
    return CallToolResult(
      content: [TextContent(text: jsonEncode(runner.flutterDtdUris))],
    );
  }
}

/// Resolves the Flutter app id for a tool call against the configured [ids],
/// applying the rules shared by `tail_flutter_logs` and `spawn_flutter_app`: a
/// single configured app is used implicitly, a missing `appId` with more than
/// one app is an error naming the options, and an unknown id is an error.
///
/// Returns the resolved id with a null error, or a null id with the error
/// [CallToolResult] to return to the caller.
(String?, CallToolResult?) _resolveFlutterAppId(
  CallToolRequest request,
  List<String> ids,
) {
  var appId = _stringArg(request, 'appId');
  if (appId == null) {
    if (ids.length > 1) {
      return (
        null,
        CallToolResult(
          content: [
            TextContent(
              text:
                  'Multiple Flutter apps are available. Pass `appId` to '
                  'choose one of: ${ids.join(', ')}.',
            ),
          ],
          isError: true,
        ),
      );
    }
    appId = ids.first;
  }

  if (!ids.contains(appId)) {
    return (
      null,
      CallToolResult(
        content: [
          TextContent(
            text:
                'Unknown Flutter app id "$appId". Available: ${ids.join(', ')}.',
          ),
        ],
        isError: true,
      ),
    );
  }

  return (appId, null);
}

int _tailLimit(CallToolRequest request) {
  final limitArg = request.arguments?['limit'];
  return switch (limitArg) {
    int v => v.clamp(1, 10000),
    _ => 200,
  };
}

/// Returns the configured Flutter app ids, in configuration order.
List<String> _flutterAppIds(InProcessRunnerApi runner) => [
  for (final app in runner.flutterApps) app.id,
];

/// Returns [result]'s message with the MCP-specific retry and follow-up hints
/// appended.
///
/// [MigrationResult] deliberately carries no instruction for retrying past
/// warnings, since the terminal UI words it as a key binding and MCP as a tool
/// argument.
String _migrationMessage(MigrationResult result) {
  final buffer = StringBuffer(result.message);
  if (result.abortedForWarnings) {
    buffer.write(' Call again with `force: true` to create it anyway.');
  }
  if (result.created) {
    buffer.write(' Call `apply_migrations` to run it against the database.');
  }
  return buffer.toString();
}

/// Returns the standard error response for tools whose runner is unset because
/// the watch session has not yet attached.
CallToolResult _notConnectedError() => CallToolResult(
  content: [TextContent(text: 'Watch session not connected.')],
  isError: true,
);

/// Reads a string argument; treats missing, non-string, and empty values as
/// `null`.
String? _stringArg(CallToolRequest request, String name) {
  final v = request.arguments?[name];
  return v is String && v.isNotEmpty ? v : null;
}

/// Reads a bool argument; treats missing or non-bool values as [defaultValue].
bool _boolArg(
  CallToolRequest request,
  String name, {
  bool defaultValue = false,
}) {
  final v = request.arguments?[name];
  return v is bool ? v : defaultValue;
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

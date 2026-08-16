import 'dart:async';
import 'dart:convert';

import 'package:dart_mcp/server.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/mcp/runner_surface.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

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

  /// Callback to create a repair migration that brings the database in line
  /// with a target migration version.
  Future<CreateMigrationMcpResult> Function({
    String? tag,
    bool force,
    String? targetMigrationVersion,
  })?
  onCreateRepairMigration;

  /// Callback to recompile and hot-reload the running server isolate.
  Future<void> Function()? onHotReload;

  /// Callback to perform a full server process restart, clearing in-memory
  /// state. Boots from the current compiled kernel; does not recompile.
  Future<void> Function()? onHotRestart;

  /// Returns the current log history snapshot.
  List<Object> Function()? getLogHistory;

  /// Returns configured Flutter app ids.
  List<String> Function()? getFlutterAppIds;

  /// Returns raw Flutter log lines for a configured app id.
  List<String> Function(String appId)? getFlutterLogHistory;

  /// Launches a configured Flutter app by id. Completes with `true` when the
  /// app was already running (so no new process was spawned) and `false` when
  /// a launch was started.
  Future<bool> Function(String appId)? onSpawnFlutterApp;

  /// Returns the current HTTP VM service URI, or `null` if not yet available.
  String? Function()? getVmServiceUri;

  /// Returns DTD URIs keyed by launched app id. Apps not launched are absent;
  /// a launched app that has not published its DTD yet maps to `null`.
  Map<String, String?> Function()? getFlutterDtdUris;

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

  /// Wires a stream whose events signal that the VM service URI has changed.
  /// Each event triggers a resource-updated notification for
  /// `serverpod://vm-service`.
  set vmServiceUriChanges(Stream<void>? stream) {
    _vmServiceUriSub?.cancel();
    _vmServiceUriSub = stream?.listen((_) {
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
    final callback = onApplyMigration;
    if (callback == null) {
      return _notConnectedError();
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

  Future<CallToolResult> _createMigration(CallToolRequest request) async {
    final callback = onCreateMigration;
    if (callback == null) {
      return _notConnectedError();
    }

    final tag = _stringArg(request, 'tag');
    final force = _boolArg(request, 'force');

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

  Future<CallToolResult> _createRepairMigration(CallToolRequest request) async {
    final callback = onCreateRepairMigration;
    if (callback == null) {
      return _notConnectedError();
    }

    try {
      final result = await callback(
        tag: _stringArg(request, 'tag'),
        force: _boolArg(request, 'force'),
        targetMigrationVersion: _stringArg(request, 'version'),
      );
      return CallToolResult(
        content: [TextContent(text: result.message)],
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

  Future<CallToolResult> _hotReload(CallToolRequest request) async {
    final callback = onHotReload;
    if (callback == null) {
      return _notConnectedError();
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

  Future<CallToolResult> _hotRestart(CallToolRequest request) async {
    final callback = onHotRestart;
    if (callback == null) {
      return _notConnectedError();
    }
    try {
      await callback();
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
    final get = getLogHistory;
    if (get == null) {
      return CallToolResult(
        content: [TextContent(text: 'Log history not available.')],
        isError: true,
      );
    }
    final limit = _tailLimit(request);
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

  Future<CallToolResult> _tailFlutterLogs(CallToolRequest request) async {
    final getIds = getFlutterAppIds;
    final getLines = getFlutterLogHistory;
    if (getIds == null || getLines == null) {
      return CallToolResult(
        content: [TextContent(text: 'Flutter log history not available.')],
        isError: true,
      );
    }
    final ids = getIds();
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

    final lines = getLines(appId!);

    final limit = _tailLimit(request);
    final tail = lines.length <= limit
        ? lines
        : lines.sublist(lines.length - limit);
    return CallToolResult(
      content: [TextContent(text: jsonEncode(tail))],
    );
  }

  Future<CallToolResult> _spawnFlutterApp(CallToolRequest request) async {
    final getIds = getFlutterAppIds;
    final spawn = onSpawnFlutterApp;
    if (getIds == null || spawn == null) {
      return CallToolResult(
        content: [TextContent(text: 'Flutter app launching is not available.')],
        isError: true,
      );
    }
    final ids = getIds();
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
      final alreadyRunning = await spawn(appId!);
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
    final get = getFlutterDtdUris;
    if (get == null) {
      return CallToolResult(
        content: [TextContent(text: 'Flutter DTD not available.')],
        isError: true,
      );
    }
    return CallToolResult(
      content: [TextContent(text: jsonEncode(get()))],
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

/// Returns the standard error response for tools whose callback is unset
/// because the watch session has not yet attached.
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

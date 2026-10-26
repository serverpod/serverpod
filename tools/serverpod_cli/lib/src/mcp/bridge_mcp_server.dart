import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:dart_mcp/server.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/mcp/runner_surface.dart';
import 'package:serverpod_cli/src/mcp/serverpod_issue_reporter.dart';
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show connectUnixSocket;

const _notRunningErrorTag = 'not-running';

final _bridgeImplementation = Implementation(
  name: 'serverpod-bridge',
  version: templateVersion,
);

/// MCP server that bridges a single MCP client to the runner
/// (`serverpod start` process) for a single server project.
///
/// The bridge is long-lived: it survives runner restarts, reconnecting to
/// the runner socket on demand.
base class BridgeMcpServer extends MCPServer
    with ToolsSupport, ResourcesSupport {
  /// Absolute path of the runner's MCP socket
  /// (`<serverDir>/.dart_tool/serverpod/mcp.sock`).
  final String socketPath;

  /// The runner's log file. Not derived from [socketPath], which may be a
  /// registry link the runner removes when it stops.
  final String logPath;

  /// The canonical absolute path of the server package this bridge serves.
  final String serverDir;

  final ServerpodIssueReporter _issueReporter;

  final MCPClient _client = MCPClient(_bridgeImplementation);

  ServerConnection? _connection;
  Future<void>? _pendingConnect;
  StreamSubscription<ResourceUpdatedNotification>? _resourceUpdatedSub;

  BridgeMcpServer(
    super.channel, {
    required this.socketPath,
    required this.logPath,
    required this.serverDir,
    ServerpodIssueReporter? issueReporter,
  }) : _issueReporter = issueReporter ?? ServerpodIssueReporter(),
       super.fromStreamChannel(
         implementation: _bridgeImplementation,
         instructions:
             'Manage the Serverpod server in $serverDir and its Flutter app, '
             'running under the Serverpod runner. This bridge serves that '
             'server package only, whatever the current directory is. Use '
             'these tools to read Serverpod and Flutter logs, create and apply '
             'database migrations, hot reload or restart the server and '
             "Flutter app, and get the Flutter app's Dart Tooling Daemon (DTD) "
             'URI. If a tool reports the server is not running, call '
             '`tail_runner_logs` to see whether it is still starting or why '
             'it stopped, then run `serverpod runner start` with '
             '`--directory` set to `$serverDir` and call the tool again. '
             'Report any Serverpod bug you hit with `report_serverpod_issue`.',
       ) {
    for (final tool in runnerStaticTools) {
      registerTool(tool, _makeToolForwarder(tool.name));
    }
    registerTool(tailRunnerLogsTool, _tailRunnerLogs);
    registerTool(reportServerpodIssueTool, _reportServerpodIssue);
    for (final resource in runnerStaticResources) {
      addResource(resource, _makeResourceReader(resource.uri));
    }
  }

  bool get _isConnected => _connection != null;

  CallToolResult _textResult(String text, {bool? isError}) => CallToolResult(
    content: [TextContent(text: text)],
    isError: isError,
  );

  CallToolResult _notRunningError() => CallToolResult(
    content: [
      TextContent(
        text:
            'The server in $serverDir is not running. Call '
            '`tail_runner_logs` to see whether it is still starting or why it '
            'stopped, then run `serverpod runner start` with '
            '`--directory` set to `$serverDir` and call this tool again.',
      ),
    ],
    isError: true,
  );

  /// Reads the file directly, since the runner may be starting or gone.
  Future<CallToolResult> _tailRunnerLogs(CallToolRequest request) async {
    final file = File(logPath);
    if (!await file.exists()) {
      return CallToolResult(
        content: [
          TextContent(
            text:
                'No runner log at $logPath. The runner writes one once '
                'started; nothing has been started for this project yet. '
                'Run `serverpod runner start` with `--directory` set to '
                '`$serverDir`.',
          ),
        ],
        isError: true,
      );
    }
    final limit = switch (request.arguments?['limit']) {
      int v => v.clamp(1, 10000),
      _ => 200,
    };
    final lines = await file.readAsLines();
    final tail = lines.length <= limit
        ? lines
        : lines.sublist(lines.length - limit);
    return CallToolResult(content: [TextContent(text: jsonEncode(tail))]);
  }

  Future<CallToolResult> _reportServerpodIssue(CallToolRequest request) async {
    String? arg(String name) => switch (request.arguments?[name]) {
      String v when v.trim().isNotEmpty => v.trim(),
      _ => null,
    };

    final title = arg('title');
    final description = arg('description');
    if (title == null || description == null) {
      return _textResult(
        '`title` and `description` are required and must not be empty.',
        isError: true,
      );
    }

    final result = await _issueReporter.send(
      ServerpodIssueReport(
        title: title,
        description: description,
        type: arg('type') == 'bug'
            ? ServerpodIssueReportType.bug
            : ServerpodIssueReportType.feedback,
      ),
      agent: clientInfo.name,
      agentVersion: clientInfo.version,
      mcpVersion: protocolVersion.versionString,
    );

    return switch (result) {
      ServerpodIssueReportCreated(:final url, :final id) => _textResult(
        'Report sent to the Serverpod team.'
        '${url != null
            ? ' Issue: $url'
            : id != null
            ? ' Issue id: $id'
            : ''}',
      ),
      ServerpodIssueReportRejected(:final reason) => _textResult(
        'The report was rejected: $reason Fix it and call again.',
        isError: true,
      ),
      ServerpodIssueReportFailed(:final reason, :final retryable) =>
        _textResult(
          'Failed to send the report: $reason '
          '${retryable ? 'You may retry once later. ' : ''}'
          'If it still fails, tell the user, so they can file it at '
          'https://github.com/serverpod/serverpod/issues instead.',
          isError: true,
        ),
    };
  }

  /// Attempt to (re)connect to the runner socket. Coalesces concurrent
  /// callers so we don't open multiple parallel connections during a burst
  /// of tool calls. Failures (no listener, refused, etc.) are swallowed -
  /// the caller checks [_isConnected] afterwards.
  Future<void> _ensureConnected() async {
    if (_isConnected) return;
    final inFlight = _pendingConnect;
    if (inFlight != null) {
      await inFlight;
      return;
    }
    final attempt = _connectOnce();
    _pendingConnect = attempt;
    try {
      await attempt;
    } finally {
      _pendingConnect = null;
    }
  }

  Future<void> _connectOnce() async {
    Socket socket;
    try {
      socket = await connectUnixSocket(
        socketPath,
        timeout: const Duration(seconds: 2),
      );
    } catch (_) {
      return;
    }

    final channel = socketChannel(socket);
    final connection = _client.connectServer(channel);

    try {
      final initResult = await connection.initialize(
        InitializeRequest(
          protocolVersion: ProtocolVersion.latestSupported,
          capabilities: _client.capabilities,
          clientInfo: _client.implementation,
        ),
      );
      if (initResult.protocolVersion?.isSupported != true) {
        await connection.shutdown();
        return;
      }
      connection.notifyInitialized(InitializedNotification());
    } catch (_) {
      await connection.shutdown();
      return;
    }

    _connection = connection;

    _resourceUpdatedSub = connection.resourceUpdated.listen((n) {
      for (final r in runnerStaticResources) {
        if (r.uri == n.uri && ready) {
          updateResource(r);
          return;
        }
      }
    });

    await Future.wait(
      runnerStaticResources.map((r) async {
        try {
          await connection.subscribeResource(SubscribeRequest(uri: r.uri));
        } catch (_) {
          // Resource may not support subscription; reads still work.
        }
      }),
    );

    // Drop state when the runner dies so the next call reconnects.
    unawaited(
      connection.done.then((_) async {
        if (_connection == connection) {
          _connection = null;
          await _resourceUpdatedSub?.cancel();
          _resourceUpdatedSub = null;
        }
      }),
    );
  }

  @override
  Future<void> shutdown() async {
    final conn = _connection;
    _connection = null;
    await _resourceUpdatedSub?.cancel();
    _resourceUpdatedSub = null;
    if (conn != null) {
      try {
        await conn.shutdown();
      } catch (_) {
        // Already gone.
      }
    }
    await super.shutdown();
  }

  Future<CallToolResult> Function(CallToolRequest) _makeToolForwarder(
    String name,
  ) {
    return (request) async {
      if (!_isConnected) await _ensureConnected();
      final conn = _connection;
      if (conn == null) return _notRunningError();
      return conn.callTool(
        CallToolRequest(name: name, arguments: request.arguments),
      );
    };
  }

  Future<ReadResourceResult> Function(ReadResourceRequest) _makeResourceReader(
    String uri,
  ) {
    return (request) async {
      if (!_isConnected) await _ensureConnected();
      final conn = _connection;
      if (conn == null) {
        return ReadResourceResult(
          contents: [
            TextResourceContents(
              uri: request.uri,
              text: jsonEncode({'uri': null, 'error': _notRunningErrorTag}),
            ),
          ],
        );
      }
      return conn.readResource(ReadResourceRequest(uri: uri));
    };
  }
}

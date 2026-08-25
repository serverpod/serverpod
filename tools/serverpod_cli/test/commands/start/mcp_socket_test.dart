import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';

import '../../test_util/fake_runner_api.dart';

void main() {
  group('Given an McpSocketServer,', skip: !hasUnixSocketSupport(), () {
    late Directory tempServerDir;
    late McpSocketServer server;

    setUp(() async {
      // Short server-dir basename keeps the resulting socket path under
      // macOS' ~104 char sun_path limit (the systemTemp prefix can eat ~50).
      tempServerDir = await Directory.systemTemp.createTemp('mst');
      server = McpSocketServer(serverDir: tempServerDir.path);
      await server.start();
    });

    tearDown(() async {
      await server.close();
      await _safeDelete(tempServerDir);
    });

    test(
      'when started, '
      'then the socket file lives at .dart_tool/serverpod/mcp.sock under the server dir',
      () {
        expect(
          server.socketPath,
          equals(
            p.join(
              tempServerDir.path,
              '.dart_tool',
              'serverpod',
              'mcp.sock',
            ),
          ),
        );
        expect(
          FileSystemEntity.typeSync(server.socketPath),
          isNot(FileSystemEntityType.notFound),
        );
      },
    );

    test(
      'when closed, '
      'then the socket file is removed',
      () async {
        final path = server.socketPath;
        await server.close();
        expect(
          FileSystemEntity.typeSync(path),
          FileSystemEntityType.notFound,
        );
      },
    );

    test(
      'when two clients connect at once, '
      'then both are served and neither displaces the other',
      () async {
        var applyCalls = 0;
        server.connect(
          FakeRunnerApi()
            ..onApplyMigrations = () async {
              applyCalls++;
            },
        );

        final first = await _connectMcpClient(server.socketPath);
        final second = await _connectMcpClient(server.socketPath);
        addTearDown(first.dispose);
        addTearDown(second.dispose);

        final firstResult = await first.connection.callTool(
          CallToolRequest(name: 'apply_migrations'),
        );
        final secondResult = await second.connection.callTool(
          CallToolRequest(name: 'apply_migrations'),
        );

        expect(firstResult.isError, anyOf(isNull, isFalse));
        expect(secondResult.isError, anyOf(isNull, isFalse));
        expect(applyCalls, 2);
      },
    );

    test(
      'when a runner is attached after a client connected, '
      'then that client sees the new runner',
      () async {
        final client = await _connectMcpClient(server.socketPath);
        addTearDown(client.dispose);

        var applyCalls = 0;
        server.connect(
          FakeRunnerApi()
            ..onApplyMigrations = () async {
              applyCalls++;
            },
        );

        final result = await client.connection.callTool(
          CallToolRequest(name: 'apply_migrations'),
        );

        expect(result.isError, anyOf(isNull, isFalse));
        expect(applyCalls, 1);
      },
    );

    test(
      'when a client connects, '
      'then it can send and receive MCP messages',
      () async {
        server.connect(FakeRunnerApi());

        final client = await Socket.connect(
          InternetAddress(server.socketPath, type: InternetAddressType.unix),
          0,
        );

        // Send an MCP initialize request.
        final initRequest = jsonEncode({
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'initialize',
          'params': {
            'protocolVersion': '2024-11-05',
            'capabilities': {},
            'clientInfo': {'name': 'test', 'version': '0.1.0'},
          },
        });
        client.write('$initRequest\n');
        await client.flush();

        // Read the response.
        final response = await client
            .cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .first;

        final json = jsonDecode(response) as Map<String, dynamic>;
        expect(json['id'], 1);
        expect(json['result'], isNotNull);
        final result = json['result'] as Map<String, dynamic>;
        final serverInfo = result['serverInfo'] as Map<String, dynamic>;
        expect(serverInfo['name'], 'serverpod');

        client.destroy();
      },
    );
  });

  group(
    'Given an McpSocketServer with retained session logs and no TUI,',
    skip: !hasUnixSocketSupport(),
    () {
      late Directory tempServerDir;
      late McpSocketServer server;
      late ServerConnection connection;

      setUp(() async {
        // Short server-dir basename keeps the resulting socket path under
        // macOS' ~104 char sun_path limit (the systemTemp prefix can eat ~50).
        tempServerDir = await Directory.systemTemp.createTemp('mst');
        server = McpSocketServer(serverDir: tempServerDir.path);
        await server.start();

        final history = StartLogHistory();
        history.recordServerLogEvent(
          Event(
            kind: EventKind.kExtension,
            timestamp: 0,
            extensionKind: 'ext.serverpod.log',
            extensionData: ExtensionData.parse({
              'type': 'log',
              'level': 'info',
              'message': 'Server log retained without a TUI.',
              'timestamp': '2026-08-10T12:00:00.000Z',
            }),
          ),
        );
        history.addFlutterLine(
          'admin',
          'Flutter log retained without a TUI.',
        );
        server.connect(
          FakeRunnerApi()
            ..logHistory = history.serverEntries.toList()
            ..flutterAppIds = ['admin']
            ..flutterLogs = {
              'admin': history.flutterLinesFor('admin').toList(),
            },
        );

        final socket = await Socket.connect(
          InternetAddress(server.socketPath, type: InternetAddressType.unix),
          0,
        );
        final client = MCPClient(
          Implementation(name: 'test-client', version: '0.1.0'),
        );
        connection = client.connectServer(socketChannel(socket));
        await connection.initialize(
          InitializeRequest(
            protocolVersion: ProtocolVersion.latestSupported,
            capabilities: ClientCapabilities(),
            clientInfo: Implementation(
              name: 'test-client',
              version: '0.1.0',
            ),
          ),
        );
      });

      tearDown(() async {
        await connection.shutdown();
        await server.close();
        await _safeDelete(tempServerDir);
      });

      test(
        'when tail_server_logs is called, '
        'then it returns the retained server log.',
        () async {
          final result = await connection.callTool(
            CallToolRequest(name: 'tail_server_logs'),
          );

          expect(result.isError, isNull);
          final logs =
              jsonDecode((result.content.single as TextContent).text)
                  as List<dynamic>;
          expect(logs, hasLength(1));
          expect(
            (logs.single as Map<String, dynamic>)['message'],
            'Server log retained without a TUI.',
          );
        },
      );

      test(
        'when tail_flutter_logs is called, '
        'then it returns the retained Flutter log.',
        () async {
          final result = await connection.callTool(
            CallToolRequest(name: 'tail_flutter_logs'),
          );

          expect(result.isError, isNull);
          expect(
            jsonDecode((result.content.single as TextContent).text),
            ['Flutter log retained without a TUI.'],
          );
        },
      );
    },
  );

  group(
    'Given a stale socket file left behind by a previous run',
    skip: !hasUnixSocketSupport(),
    () {
      test(
        'when start is called, '
        'then the stale file is unlinked and a fresh bind succeeds',
        () async {
          final tempServerDir = await Directory.systemTemp.createTemp('mst');
          addTearDown(() => _safeDelete(tempServerDir));

          // Write a stale, non-bound file at the expected socket path.
          final socketDir = Directory(
            p.join(tempServerDir.path, '.dart_tool', 'serverpod'),
          )..createSync(recursive: true);
          final stalePath = p.join(socketDir.path, 'mcp.sock');
          File(stalePath).writeAsStringSync('');

          final server = McpSocketServer(serverDir: tempServerDir.path);
          addTearDown(server.close);

          await server.start();
          expect(server.socketPath, stalePath);
          expect(
            FileSystemEntity.typeSync(stalePath),
            isNot(FileSystemEntityType.notFound),
          );
        },
      );
    },
  );

  group(
    'Given Windows with Dart < 3.11',
    skip: hasUnixSocketSupport(),
    () {
      test(
        'when starting an McpSocketServer, '
        'then it throws a SocketException',
        () async {
          final tempServerDir = await Directory.systemTemp.createTemp('mst');
          addTearDown(() => _safeDelete(tempServerDir));

          final server = McpSocketServer(serverDir: tempServerDir.path);
          expect(server.start(), throwsA(isA<SocketException>()));
        },
      );

      test(
        'when calling requireUnixSocketSupport, '
        'then it throws a SocketException',
        () {
          expect(
            requireUnixSocketSupport,
            throwsA(isA<SocketException>()),
          );
        },
      );
    },
  );
}

Future<void> _safeDelete(Directory dir) async {
  try {
    await dir.delete(recursive: true);
  } on FileSystemException {
    // Best effort.
  }
}

/// Connects an MCP client to the socket at [socketPath] and initializes it.
Future<({ServerConnection connection, Future<void> Function() dispose})>
_connectMcpClient(String socketPath) async {
  final socket = await Socket.connect(
    InternetAddress(socketPath, type: InternetAddressType.unix),
    0,
  );
  final client = MCPClient(
    Implementation(name: 'test-client', version: '0.1.0'),
  );
  final connection = client.connectServer(socketChannel(socket));
  await connection.initialize(
    InitializeRequest(
      protocolVersion: ProtocolVersion.latestSupported,
      capabilities: ClientCapabilities(),
      clientInfo: Implementation(name: 'test-client', version: '0.1.0'),
    ),
  );
  connection.notifyInitialized();
  return (connection: connection, dispose: connection.shutdown);
}

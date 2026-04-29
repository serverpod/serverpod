import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/util/platform_check.dart';
import 'package:test/test.dart';

void main() {
  group('Given an McpSocketServer', skip: !hasUnixSocketSupport(), () {
    late McpSocketServer server;

    setUp(() async {
      // Project name kept short: macOS limits Unix socket paths to ~104 chars
      // and the systemTemp prefix can use ~50 of them on its own.
      server = McpSocketServer(
        project: 'mst${DateTime.now().microsecondsSinceEpoch % 100000}',
      );
      await server.start();
    });

    tearDown(() async {
      await server.close();
    });

    test(
      'when started, '
      'then the socket file exists in the shared serverpod socket dir',
      () {
        expect(
          FileSystemEntity.typeSync(server.socketPath),
          isNot(FileSystemEntityType.notFound),
        );
        expect(
          server.socketPath,
          matches(r'[\\/]serverpod[\\/]serverpod-\d+-mst\d+\.sock$'),
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
      'when a client connects, '
      'then it can send and receive MCP messages',
      () async {
        server.connect(onApplyMigration: () async {});

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
    'Given a project name that pushes the socket path past the platform limit',
    skip: !hasUnixSocketSupport(),
    () {
      test(
        'when starting an McpSocketServer, '
        'then start throws a SocketException with an actionable message',
        () async {
          // Build a project name long enough that the resulting socket path
          // exceeds the platform's sun_path limit even after shortening.
          final budget = maxUnixSocketPathBytes();
          final templatePath = serverpodMcpSocketPath(pid: pid, project: 'x');
          final overhead = p.basename(templatePath).length - 1;
          final projectLen = budget - overhead + 16;
          final project = 'p' * projectLen;

          final server = McpSocketServer(project: project);
          await expectLater(
            server.start,
            throwsA(
              isA<SocketException>().having(
                (e) => e.message,
                'message',
                startsWith('Unix socket path is too long for this platform'),
              ),
            ),
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
          final server = McpSocketServer(project: 'unsupported');
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

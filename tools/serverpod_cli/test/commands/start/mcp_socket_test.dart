import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/util/platform_check.dart';
import 'package:test/test.dart';

void main() {
  group('Given an McpSocketServer', skip: !hasUnixSocketSupport(), () {
    late Directory tmpDir;
    late McpSocketServer server;

    setUp(() async {
      tmpDir = await Directory.systemTemp.createTemp('mcp_socket_test_');
      final socketPath = p.join(tmpDir.path, 'mcp.sock');
      server = McpSocketServer(socketPath: socketPath);
      await server.start();
    });

    tearDown(() async {
      await server.close();
      if (tmpDir.existsSync()) {
        tmpDir.deleteSync(recursive: true);
      }
    });

    test(
      'when started, '
      'then the socket file exists',
      () {
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
    'Given Windows with Dart < 3.11',
    skip: hasUnixSocketSupport(),
    () {
      test(
        'when starting an McpSocketServer, '
        'then it throws a SocketException',
        () async {
          final server = McpSocketServer(socketPath: 'mcp.sock');
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

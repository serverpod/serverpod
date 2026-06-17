import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given an McpSocketServer', skip: !hasUnixSocketSupport(), () {
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

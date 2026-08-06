import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:test/test.dart';

void main() {
  group('Given serverpodMcpSocketPath', () {
    test(
      'when called with a server directory, '
      'then it returns .dart_tool/serverpod/mcp.sock under that directory',
      () {
        final path = serverpodMcpSocketPath('/tmp/myapp_server');
        expect(
          path,
          equals(
            p.join('/tmp/myapp_server', '.dart_tool', 'serverpod', 'mcp.sock'),
          ),
        );
      },
    );

    test(
      'when called with a relative server directory, '
      'then the returned path is relative too',
      () {
        final path = serverpodMcpSocketPath('myapp_server');
        expect(
          path,
          equals(p.join('myapp_server', '.dart_tool', 'serverpod', 'mcp.sock')),
        );
      },
    );
  });
}

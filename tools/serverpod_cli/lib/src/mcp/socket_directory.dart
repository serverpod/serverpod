import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:stream_channel/stream_channel.dart';

/// Canonical path of the MCP socket exposed by `serverpod start --watch`
/// for the server project rooted at [serverDir].
///
/// One socket per server project, kept inside the project's `.dart_tool/`
/// so it is scoped, easy to discover, and ignored by VCS. There can be at
/// most one `serverpod start --watch` process per project; a stale socket
/// file left behind by a crashed runner is unlinked before the next bind.
String serverpodMcpSocketPath(String serverDir) =>
    p.join(serverpodToolDirPath(serverDir), serverpodMcpSocketName);

/// Wraps [socket] in a [StreamChannel<String>] using line-delimited messages.
///
/// Matches the framing used by `dart_mcp`'s stdio transport so the same
/// `MCPServer`/`MCPClient` plumbing works over a Unix socket.
///
/// [input] replaces the socket's stream for a caller already listening to it.
StreamChannel<String> socketChannel(
  Socket socket, {
  Stream<List<int>>? input,
}) {
  final inStream = (input ?? socket.cast<List<int>>())
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      // Drops socket errors, which a client exit raises and nothing awaits.
      // A decode error passes, since no `done` follows it to end the peer.
      .handleError((_) {}, test: (error) => error is SocketException);

  final outController = StreamController<String>();
  outController.stream.listen(
    (line) {
      try {
        socket.write('$line\n');
      } on SocketException {
        // Peer may have already disconnected
      }
    },
    onDone: () async {
      try {
        await socket.close();
      } catch (_) {
        socket.destroy();
      }
    },
  );

  unawaited(socket.done.catchError((_) {}));

  return StreamChannel<String>(inStream, outController.sink);
}

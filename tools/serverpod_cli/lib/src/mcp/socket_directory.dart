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
    p.join(serverpodToolDirPath(serverDir), 'mcp.sock');

/// Wraps [socket] in a [StreamChannel<String>] using line-delimited messages.
///
/// Matches the framing used by `dart_mcp`'s stdio transport so the same
/// `MCPServer`/`MCPClient` plumbing works over a Unix socket.
///
/// [input] stands in for the socket's own stream when a caller has already
/// subscribed to that, to look at the first bytes before deciding what the
/// connection is.
StreamChannel<String> socketChannel(
  Socket socket, {
  Stream<List<int>>? input,
}) {
  final inStream = (input ?? socket.cast<List<int>>())
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      // dart:io closes the stream right after a socket error, so the peer ends
      // either way. Handed on, json_rpc_2 completes `listen()` with the error
      // and nothing awaits that. Linux resets a Unix socket whose peer closed
      // with bytes unread, so a plain client exit raises one. A decoding error
      // keeps flowing. It carries no `done`, and the peer needs it to end.
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

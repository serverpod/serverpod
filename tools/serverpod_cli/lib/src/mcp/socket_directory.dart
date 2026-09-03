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
StreamChannel<String> socketChannel(Socket socket) {
  final inStream = socket
      .cast<List<int>>()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      // A socket error is a disconnect, and dart:io sends `done` right behind
      // it, so dropping it costs the peer nothing: it ends either way. Passing
      // it on can instead reach a subscription whose error handler
      // `StreamChannel`'s close guarantee detached when the sink closed, and
      // dart:async hands that to the zone as an uncaught error. Linux resets a
      // connection whose peer closed with bytes still unread, so an ordinary
      // detach raises one. Only a socket error is dropped, since a decoding
      // error carries no `done` and has to reach the peer to end it.
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

import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// This class is used by the [Server] to handle incoming websocket requests
/// to a method. It is not intended to be used directly by the user.
@internal
class MethodWebsocketRequestHandler {
  /// Handles incoming websocket requests.
  /// Returns a [Future] that completes when the websocket is closed.
  Future<void> handleWebsocket(
    Server server,
    WebSocket webSocket,
    HttpRequest request,
    void Function() onClosed,
  ) async {
    try {
      server.serverpod.logVerbose('Method websocket connection established.');
      await for (String jsonData in webSocket) {
        var message = WebSocketMessage.fromJsonString(jsonData);

        switch (message) {
          case PingCommand():
            webSocket.add(PongCommand.buildMessage());
            break;
          case PongCommand():
            break;
          case UnknownMessage():
            server.serverpod.logVerbose(
                'Unknown message received on websocket connection: ${message.jsonString}');
        }
      }
    } catch (e, stackTrace) {
      var session = await server.serverpod.createSession();
      await session.close(error: e, stackTrace: stackTrace);
    } finally {
      onClosed();
    }
  }
}

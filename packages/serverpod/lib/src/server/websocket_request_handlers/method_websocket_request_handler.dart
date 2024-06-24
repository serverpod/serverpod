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
        WebSocketMessage message;
        try {
          message = WebSocketMessage.fromJsonString(jsonData);
        } on UnknownMessageException catch (_) {
          webSocket.add(BadRequestMessage.buildMessage(jsonData));
          throw Exception(
            'Unknown message received on websocket connection: $jsonData',
          );
        }

        switch (message) {
          case OpenMethodStreamCommand():
            webSocket.add(
              await _handleOpenMethodStreamCommand(server, webSocket, message),
            );
            break;
          case OpenMethodStreamResponse():
            break;
          case PingCommand():
            webSocket.add(PongCommand.buildMessage());
            break;
          case PongCommand():
            break;
          case BadRequestMessage():
            server.serverpod.logVerbose(
              'Bad request message: ${message.request}, closing connection.',
            );
            return;
        }
      }
    } catch (e, stackTrace) {
      var session = await server.serverpod.createSession();
      await session.close(error: e, stackTrace: stackTrace);
    } finally {
      // Send a close message to the client.
      await webSocket.close();
      onClosed();
    }
  }

  Future<String> _handleOpenMethodStreamCommand(
    Server server,
    WebSocket webSocket,
    OpenMethodStreamCommand message,
  ) async {
    // Validate targeted endpoint method
    var endpointConnector =
        server.endpoints.getConnectorByName(message.endpoint);
    if (endpointConnector == null) {
      server.serverpod.logVerbose(
        'Endpoint not found for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        uuid: message.uuid,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    }

    var methodConnector = endpointConnector.methodConnectors[message.method];
    if (methodConnector == null) {
      server.serverpod.logVerbose(
        'Endpoint method not found for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        uuid: message.uuid,
        responseType: OpenMethodStreamResponseType.methodNotFound,
      );
    }

    // Parse arguments
    Map<String, dynamic> args;
    try {
      args = EndpointDispatch.parseParameters(
        message.args,
        methodConnector.params,
        server.serializationManager,
      );
    } catch (e) {
      server.serverpod.logVerbose(
        'Failed to parse parameters for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        uuid: message.uuid,
        responseType: OpenMethodStreamResponseType.invalidArguments,
      );
    }

    // Create session
    var session = StreamingMethodCallSession(
      server: server,
      enableLogging: endpointConnector.endpoint.logSessions,
      authenticationKey: message.auth,
      endpointName: endpointConnector.name,
      methodName: methodConnector.name,
      uuid: message.uuid,
    );

    // Check authentication
    var authFailed = await EndpointDispatch.canUserAccessEndpoint(
      () => session.authenticated,
      endpointConnector.endpoint.requireLogin,
      endpointConnector.endpoint.requiredScopes,
    );

    if (authFailed != null) {
      server.serverpod.logVerbose(
        'Authentication failed for open stream request: $message',
      );
      await session.close();
      return switch (authFailed.reason) {
        AuthenticationFailureReason.insufficientAccess =>
          OpenMethodStreamResponse.buildMessage(
            uuid: message.uuid,
            responseType: OpenMethodStreamResponseType.insufficientScopes,
          ),
        AuthenticationFailureReason.unauthenticated =>
          OpenMethodStreamResponse.buildMessage(
            uuid: message.uuid,
            responseType: OpenMethodStreamResponseType.authenticationFailed,
          ),
      };
    }

    return OpenMethodStreamResponse.buildMessage(
      uuid: message.uuid,
      responseType: OpenMethodStreamResponseType.success,
    );
  }
}

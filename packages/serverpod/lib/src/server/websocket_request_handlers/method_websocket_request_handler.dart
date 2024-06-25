import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// This class is used by the [Server] to handle incoming websocket requests
/// to a method. It is not intended to be used directly by the user.
@internal
class MethodWebsocketRequestHandler {
  final _MethodStreamManager _methodStreamManager = _MethodStreamManager();

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
          case MethodStreamMessage():
            break;
          case CloseMethodStreamCommand():
            await _methodStreamManager.closeStream(
              endpoint: message.endpoint,
              method: message.method,
              uuid: message.uuid,
            );
          case MethodStreamSerializableException():
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
      await _methodStreamManager.closeAllStreams();
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

    _methodStreamManager.createStream(
      methodConnector: methodConnector,
      session: session,
      args: args,
      message: message,
      server: server,
      webSocket: webSocket,
    );

    return OpenMethodStreamResponse.buildMessage(
      uuid: message.uuid,
      responseType: OpenMethodStreamResponseType.success,
    );
  }
}

class _MethodStreamManager {
  final Map<String, StreamController<String>> _streamControllers = {};

  Future<void> closeAllStreams() async {
    var controllers = _streamControllers.values.toList();
    _streamControllers.clear();

    List<Future<void>> futures = [];
    for (var controller in controllers) {
      futures.add(controller.close());
    }

    await Future.wait(futures);
  }

  Future<void> closeStream({
    required String endpoint,
    required String method,
    required String uuid,
  }) async {
    var controller = _streamControllers.remove(_buildStreamKey(
      endpoint: endpoint,
      method: method,
      uuid: uuid,
    ));
    if (controller == null) return;

    return controller.close();
  }

  void createStream({
    required MethodConnector methodConnector,
    required Session session,
    required Map<String, dynamic> args,
    required OpenMethodStreamCommand message,
    required Server server,
    required WebSocket webSocket,
  }) {
    var controller = StreamController<String>();
    _handleStream(methodConnector, session, args, message, server);

    controller.stream.listen((event) {
      webSocket.add(event);
    }, onDone: () async {
      if (_streamControllers.isEmpty) {
        await webSocket.close();
      }
    });

    _streamControllers[_buildStreamKey(
      endpoint: message.endpoint,
      method: message.method,
      uuid: message.uuid,
    )] = controller;
  }

  String _buildStreamKey({
    required String endpoint,
    required String method,
    required String uuid,
  }) =>
      '$uuid:$endpoint:$method';

  Future<void> _handleStream(
    MethodConnector methodConnector,
    Session session,
    Map<String, dynamic> args,
    OpenMethodStreamCommand message,
    Server server,
  ) async {
    dynamic result;
    try {
      result = await methodConnector.call(session, args);
    } catch (e, stackTrace) {
      if (e is SerializableException) {
        _postMessage(
          endpoint: message.endpoint,
          method: message.method,
          uuid: message.uuid,
          message: MethodStreamSerializableException.buildMessage(
            endpoint: message.endpoint,
            method: message.method,
            uuid: message.uuid,
            object: server.serializationManager.encodeWithType(e),
          ),
        );
      }

      _postMessage(
        endpoint: message.endpoint,
        method: message.method,
        uuid: message.uuid,
        message: CloseMethodStreamCommand.buildMessage(
          endpoint: message.endpoint,
          uuid: message.uuid,
          method: message.method,
          reason: CloseReason.error,
        ),
      );

      await session.close(error: e, stackTrace: stackTrace);
      await closeStream(
        endpoint: message.endpoint,
        method: message.method,
        uuid: message.uuid,
      );
      return;
    }

    if (result != null) {
      _postMessage(
        endpoint: message.endpoint,
        method: message.method,
        uuid: message.uuid,
        message: MethodStreamMessage.buildMessage(
          endpoint: message.endpoint,
          method: message.method,
          uuid: message.uuid,
          object: server.serializationManager.encodeWithType(result),
        ),
      );
    }

    _postMessage(
      endpoint: message.endpoint,
      method: message.method,
      uuid: message.uuid,
      message: CloseMethodStreamCommand.buildMessage(
        endpoint: message.endpoint,
        uuid: message.uuid,
        method: message.method,
        reason: CloseReason.done,
      ),
    );
    await session.close();
    await closeStream(
      endpoint: message.endpoint,
      method: message.method,
      uuid: message.uuid,
    );
  }

  void _postMessage({
    required String endpoint,
    required String method,
    required String uuid,
    required String message,
  }) {
    var controller = _streamControllers[_buildStreamKey(
      endpoint: endpoint,
      method: method,
      uuid: uuid,
    )];
    if (controller == null) return;

    controller.add(message);
  }
}

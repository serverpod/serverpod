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
              connectionId: message.connectionId,
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
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    }

    var endpointMethodConnector =
        endpointConnector.methodConnectors[message.method];
    if (endpointMethodConnector == null) {
      server.serverpod.logVerbose(
        'Endpoint method not found for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    }

    if (endpointMethodConnector is MethodStreamConnector &&
        endpointMethodConnector.returnType !=
            MethodStreamReturnType.streamType) {
      server.serverpod.logVerbose(
        'Endpoint method does not have supported return type: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    }

    // Parse arguments
    Map<String, dynamic> args;
    try {
      args = EndpointDispatch.parseParameters(
        message.args,
        endpointMethodConnector.params,
        server.serializationManager,
      );
    } catch (e) {
      server.serverpod.logVerbose(
        'Failed to parse parameters for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.invalidArguments,
      );
    }

    // Create session
    var session = MethodStreamSession(
      server: server,
      enableLogging: endpointConnector.endpoint.logSessions,
      authenticationKey: message.authentication,
      endpointName: endpointConnector.name,
      methodName: endpointMethodConnector.name,
      connectionId: message.connectionId,
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
            connectionId: message.connectionId,
            responseType: OpenMethodStreamResponseType.authorizationDeclined,
          ),
        AuthenticationFailureReason.unauthenticated =>
          OpenMethodStreamResponse.buildMessage(
            connectionId: message.connectionId,
            responseType: OpenMethodStreamResponseType.authenticationFailed,
          ),
      };
    }

    _methodStreamManager.createStream(
      endpointMethodConnector: endpointMethodConnector,
      session: session,
      args: args,
      message: message,
      server: server,
      webSocket: webSocket,
    );

    return OpenMethodStreamResponse.buildMessage(
      connectionId: message.connectionId,
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
    required UuidValue connectionId,
  }) async {
    var controller = _streamControllers.remove(_buildStreamKey(
      endpoint: endpoint,
      method: method,
      connectionId: connectionId,
    ));
    if (controller == null) return;

    return controller.close();
  }

  void createStream({
    required EndpointMethodConnector endpointMethodConnector,
    required Session session,
    required Map<String, dynamic> args,
    required OpenMethodStreamCommand message,
    required Server server,
    required WebSocket webSocket,
  }) {
    var controller = StreamController<String>();
    if (endpointMethodConnector is MethodStreamConnector) {
      _handleMethodStreamEndpoint(
        endpointMethodConnector,
        session,
        args,
        message,
        server,
      );
    } else if (endpointMethodConnector is MethodConnector) {
      _handleMethodCallEndpoint(
        endpointMethodConnector,
        session,
        args,
        message,
        server,
      );
    }

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
      connectionId: message.connectionId,
    )] = controller;
  }

  String _buildStreamKey({
    required String endpoint,
    required String method,
    required UuidValue connectionId,
  }) =>
      '$connectionId:$endpoint:$method';

  Future<void> _handleMethodCallEndpoint(
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
          connectionId: message.connectionId,
          message: MethodStreamSerializableException.buildMessage(
            endpoint: message.endpoint,
            method: message.method,
            connectionId: message.connectionId,
            object: server.serializationManager.encodeWithType(e),
          ),
        );
      }

      _postMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        message: CloseMethodStreamCommand.buildMessage(
          endpoint: message.endpoint,
          connectionId: message.connectionId,
          method: message.method,
          reason: CloseReason.error,
        ),
      );

      await session.close(error: e, stackTrace: stackTrace);
      await closeStream(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
      );
      return;
    }

    // TODO: Support nullable return types.
    // Becuase encodeWithType doens't support nullable we can't encode null
    // values.
    if (methodConnector.returnsVoid == false && result != null) {
      _postMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        message: MethodStreamMessage.buildMessage(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId,
          object: server.serializationManager.encodeWithType(result),
        ),
      );
    }

    _postMessage(
      endpoint: message.endpoint,
      method: message.method,
      connectionId: message.connectionId,
      message: CloseMethodStreamCommand.buildMessage(
        endpoint: message.endpoint,
        connectionId: message.connectionId,
        method: message.method,
        reason: CloseReason.done,
      ),
    );
    await session.close();
    await closeStream(
      endpoint: message.endpoint,
      method: message.method,
      connectionId: message.connectionId,
    );
  }

  void _handleMethodStreamEndpoint(
    MethodStreamConnector methodConnector,
    Session session,
    Map<String, dynamic> args,
    OpenMethodStreamCommand message,
    Server server,
  ) {
    methodConnector.call(session, args, {}).listen(
      (value) {
        _postMessage(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId,
          message: MethodStreamMessage.buildMessage(
            endpoint: message.endpoint,
            method: message.method,
            connectionId: message.connectionId,
            object: server.serializationManager.encodeWithType(value),
          ),
        );
      },
      onDone: () async {
        _postMessage(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId,
          message: CloseMethodStreamCommand.buildMessage(
            endpoint: message.endpoint,
            connectionId: message.connectionId,
            method: message.method,
            reason: CloseReason.done,
          ),
        );
        await session.close();
        await closeStream(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId,
        );
      },
      onError: (e, stackTrace) async {
        if (e is SerializableException) {
          _postMessage(
            endpoint: message.endpoint,
            method: message.method,
            connectionId: message.connectionId,
            message: MethodStreamSerializableException.buildMessage(
              endpoint: message.endpoint,
              method: message.method,
              connectionId: message.connectionId,
              object: server.serializationManager.encodeWithType(e),
            ),
          );
        }

        _postMessage(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId,
          message: CloseMethodStreamCommand.buildMessage(
            endpoint: message.endpoint,
            connectionId: message.connectionId,
            method: message.method,
            reason: CloseReason.error,
          ),
        );

        await session.close(error: e, stackTrace: stackTrace);
        await closeStream(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId,
        );
      },
      // Cancel on error prevents the stream from continuing after an exception
      // has been thrown. This is important since we want to close the stream
      // when an exception is thrown and handle the complete shutdown in the
      // onError callback.
      cancelOnError: true,
    );
  }

  void _postMessage({
    required String endpoint,
    required String method,
    required UuidValue connectionId,
    required String message,
  }) {
    var controller = _streamControllers[_buildStreamKey(
      endpoint: endpoint,
      method: method,
      connectionId: connectionId,
    )];

    controller?.add(message);
  }
}

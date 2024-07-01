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
            var success = _methodStreamManager.dispatchMessage(message, server);
            if (success) break;

            server.serverpod.logVerbose(
              'Failed to dispatch message: $message',
            );
            webSocket.add(CloseMethodStreamCommand.buildMessage(
              endpoint: message.endpoint,
              method: message.method,
              parameter: message.parameter,
              connectionId: message.connectionId,
              reason: CloseReason.error,
            ));
            break;
          case CloseMethodStreamCommand():
            await _methodStreamManager.closeStream(
              endpoint: message.endpoint,
              method: message.method,
              parameter: message.parameter,
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

    if (endpointMethodConnector is! MethodStreamConnector) {
      server.serverpod.logVerbose(
        'Endpoint method is not a valid stream method: $message',
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
      methodConnector: endpointMethodConnector,
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
  final Map<String, StreamController<dynamic>> _streamControllers = {};

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
    String? parameter,
    required UuidValue connectionId,
  }) async {
    var controller = _streamControllers.remove(_buildStreamKey(
      endpoint: endpoint,
      method: method,
      parameter: parameter,
      connectionId: connectionId,
    ));

    return controller?.close();
  }

  void createStream({
    required MethodStreamConnector methodConnector,
    required Session session,
    required Map<String, dynamic> args,
    required OpenMethodStreamCommand message,
    required Server server,
    required WebSocket webSocket,
  }) {
    _registerOutputStream(webSocket, message);
    var inputStreams = _createInputStreams(
      methodConnector,
      webSocket,
      message,
    );
    var streamParams = inputStreams.map(
      (key, value) => MapEntry(key, value.stream),
    );

    switch (methodConnector.returnType) {
      case MethodStreamReturnType.streamType:
        _handleMethodWithStreamReturn(
          methodConnector: methodConnector,
          session: session,
          args: args,
          streamParams: streamParams,
          message: message,
          server: server,
        );
        break;
      case MethodStreamReturnType.singleType:
      case MethodStreamReturnType.voidType:
        _handleMethodWithFutureReturn(
          methodConnector: methodConnector,
          session: session,
          args: args,
          streamParams: streamParams,
          message: message,
          server: server,
        );
        break;
    }
  }

  /// Dispatches a message to the correct stream controller.
  bool dispatchMessage(
    MethodStreamMessage message,
    Server server,
  ) {
    var controller = _streamControllers[_buildStreamKey(
      endpoint: message.endpoint,
      method: message.method,
      parameter: message.parameter,
      connectionId: message.connectionId,
    )];

    if (controller == null) {
      return false;
    }

    controller.add(server.serializationManager.decodeWithType(message.object));
    return true;
  }

  String _buildStreamKey({
    required String endpoint,
    required String method,
    String? parameter,
    required UuidValue connectionId,
  }) =>
      '$connectionId:$endpoint:$method${parameter != null ? ':$parameter' : ''}';

  Future<void> _closeMethodStream({
    required String endpoint,
    required String method,
    required UuidValue connectionId,
    required CloseReason reason,
  }) async {
    var message = CloseMethodStreamCommand.buildMessage(
      endpoint: endpoint,
      connectionId: connectionId,
      method: method,
      reason: reason,
    );

    var controller = _streamControllers.remove(_buildStreamKey(
      endpoint: endpoint,
      method: method,
      connectionId: connectionId,
    ));

    controller?.add(message);
    return controller?.close();
  }

  Future<void> _closeParameterStream({
    required String endpoint,
    required String method,
    required String parameter,
    required UuidValue connectionId,
    required CloseReason reason,
    required WebSocket webSocket,
  }) async {
    var controller = _streamControllers.remove(_buildStreamKey(
      endpoint: endpoint,
      method: method,
      parameter: parameter,
      connectionId: connectionId,
    ));

    await controller?.close();
    if (webSocket.closeCode != null) return;

    var message = CloseMethodStreamCommand.buildMessage(
      endpoint: endpoint,
      method: method,
      parameter: parameter,
      connectionId: connectionId,
      reason: reason,
    );
    webSocket.add(message);
  }

  Map<String, StreamController> _createInputStreams(
    MethodStreamConnector methodStreamConnector,
    WebSocket webSocket,
    OpenMethodStreamCommand message,
  ) {
    var streamParamDescriptions = methodStreamConnector.streamParams.values;
    var inputStreams = <String, StreamController>{};

    for (var streamParam in streamParamDescriptions) {
      var parameterName = streamParam.name;
      var controller = StreamController(onCancel: () async {
        if (webSocket.closeCode != null) return;

        await _closeParameterStream(
          endpoint: message.endpoint,
          method: message.method,
          parameter: parameterName,
          connectionId: message.connectionId,
          reason: CloseReason.done,
          webSocket: webSocket,
        );

        if (_streamControllers.isEmpty) {
          await webSocket.close();
        }
      });

      inputStreams[parameterName] = controller;
      _streamControllers[_buildStreamKey(
        endpoint: message.endpoint,
        method: message.method,
        parameter: parameterName,
        connectionId: message.connectionId,
      )] = controller;
    }

    return inputStreams;
  }

  Future<void> _handleMethodWithFutureReturn({
    required MethodStreamConnector methodConnector,
    required Session session,
    required Map<String, dynamic> args,
    required Map<String, Stream<dynamic>> streamParams,
    required OpenMethodStreamCommand message,
    required Server server,
  }) async {
    dynamic result;
    try {
      result = await methodConnector.call(session, args, streamParams);
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

      await session.close(error: e, stackTrace: stackTrace);
      await _closeMethodStream(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        reason: CloseReason.error,
      );
      return;
    }

    // TODO: Support nullable return types.
    // Because encodeWithType does not support nullable we can't encode null
    // values.
    if (methodConnector.returnType != MethodStreamReturnType.voidType &&
        result != null) {
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

    await session.close();
    await _closeMethodStream(
      endpoint: message.endpoint,
      method: message.method,
      connectionId: message.connectionId,
      reason: CloseReason.done,
    );
  }

  void _handleMethodWithStreamReturn({
    required MethodStreamConnector methodConnector,
    required Session session,
    required Map<String, dynamic> args,
    required Map<String, Stream<dynamic>> streamParams,
    required OpenMethodStreamCommand message,
    required Server server,
  }) {
    methodConnector.call(session, args, streamParams).listen(
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
        await session.close();
        await _closeMethodStream(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId,
          reason: CloseReason.done,
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

        await session.close(error: e, stackTrace: stackTrace);
        await _closeMethodStream(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId,
          reason: CloseReason.error,
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
    String? parameter,
    required UuidValue connectionId,
    required String message,
  }) {
    var controller = _streamControllers[_buildStreamKey(
      endpoint: endpoint,
      method: method,
      parameter: parameter,
      connectionId: connectionId,
    )];

    controller?.add(message);
  }

  void _registerOutputStream(
    WebSocket webSocket,
    OpenMethodStreamCommand message,
  ) {
    var controller = StreamController<String>();
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
}

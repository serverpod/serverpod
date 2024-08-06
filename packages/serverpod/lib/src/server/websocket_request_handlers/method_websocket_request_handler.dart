import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

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
          message = WebSocketMessage.fromJsonString(
            jsonData,
            server.serializationManager,
          );
        } on UnknownMessageException catch (_) {
          webSocket.tryAdd(BadRequestMessage.buildMessage(jsonData));
          rethrow;
        }

        switch (message) {
          case OpenMethodStreamCommand():
            webSocket.tryAdd(
              await _handleOpenMethodStreamCommand(server, webSocket, message),
            );
            break;
          case OpenMethodStreamResponse():
            break;
          case MethodStreamMessage():
            _dispatchMethodStreamMessage(message, webSocket, server);
            break;
          case CloseMethodStreamCommand():
            await _methodStreamManager.closeStream(
              endpoint: message.endpoint,
              method: message.method,
              parameter: message.parameter,
              connectionId: message.connectionId,
              reason: message.reason,
            );
            break;
          case MethodStreamSerializableException():
            _methodStreamManager.dispatchSerializableException(
              message,
              server,
            );
            break;
          case PingCommand():
            webSocket.tryAdd(PongCommand.buildMessage());
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
      if (server.serverpod.runtimeSettings.logMalformedCalls) {
        stderr.writeln(
            '${DateTime.now().toUtc()} Method stream websocket error.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
      }
    } finally {
      await _methodStreamManager.closeAllStreams();
      // Send a close message to the client.
      await webSocket.close();
      onClosed();
    }
  }

  void _dispatchMethodStreamMessage(
    MethodStreamMessage message,
    WebSocket webSocket,
    Server server,
  ) {
    if (message.parameter == null) {
      // Assume message is intended for method streams return stream.
      webSocket.tryAdd(BadRequestMessage.buildMessage(
          'Server does not accept messages targeting the return stream.'));
      throw Exception(
        'Message targeting return stream received: $message',
      );
    }

    var success = _methodStreamManager.dispatchMessage(message, server);
    if (success) return;

    server.serverpod.logVerbose(
      'Failed to dispatch message: $message',
    );

    webSocket.tryAdd(CloseMethodStreamCommand.buildMessage(
      endpoint: message.endpoint,
      method: message.method,
      parameter: message.parameter,
      connectionId: message.connectionId,
      reason: CloseReason.error,
    ));
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
        endpoint: message.endpoint,
        method: message.method,
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
        endpoint: message.endpoint,
        method: message.method,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    }

    if (endpointMethodConnector is! MethodStreamConnector) {
      server.serverpod.logVerbose(
        'Endpoint method is not a valid stream method: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
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
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.invalidArguments,
      );
    }

    List<StreamParameterDescription> requestedInputStreams;
    try {
      requestedInputStreams = EndpointDispatch.parseRequestedInputStreams(
        descriptions: endpointMethodConnector.streamParams,
        requestedInputStreams: message.inputStreams,
      );
    } catch (e) {
      server.serverpod.logVerbose(
        'Failed to parse input streams for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
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
            endpoint: message.endpoint,
            method: message.method,
            connectionId: message.connectionId,
            responseType: OpenMethodStreamResponseType.authorizationDeclined,
          ),
        AuthenticationFailureReason.unauthenticated =>
          OpenMethodStreamResponse.buildMessage(
            endpoint: message.endpoint,
            method: message.method,
            connectionId: message.connectionId,
            responseType: OpenMethodStreamResponseType.authenticationFailed,
          ),
      };
    }

    _methodStreamManager.createStream(
      methodConnector: endpointMethodConnector,
      requestedInputStreams: requestedInputStreams,
      session: session,
      args: args,
      message: message,
      serializationManager: server.serializationManager,
      webSocket: webSocket,
    );

    return OpenMethodStreamResponse.buildMessage(
      endpoint: message.endpoint,
      method: message.method,
      connectionId: message.connectionId,
      responseType: OpenMethodStreamResponseType.success,
    );
  }
}

class _InputStreamContext implements _StreamContext {
  @override
  final StreamController controller;

  _InputStreamContext(this.controller);
}

class _MethodStreamManager {
  final Map<String, _InputStreamContext> _inputStreamContexts = {};
  final Map<String, _OutputStreamContext> _outputStreamContexts = {};

  Future<void> closeAllStreams() async {
    var inputControllers =
        _inputStreamContexts.values.map((c) => c.controller).toList();
    inputControllers.clear();
    var outputControllers =
        _outputStreamContexts.values.map((c) => c.controller).toList();
    outputControllers.clear();

    await _closeControllers([...inputControllers, ...outputControllers]);
  }

  Future<void> closeStream({
    required String endpoint,
    required String method,
    String? parameter,
    required UuidValue connectionId,
    required CloseReason reason,
  }) async {
    _StreamContext? context;
    if (parameter == null) {
      context = _outputStreamContexts.remove(_buildStreamKey(
        endpoint: endpoint,
        method: method,
        connectionId: connectionId,
      ));
    } else {
      context = _inputStreamContexts.remove(_buildStreamKey(
        endpoint: endpoint,
        method: method,
        parameter: parameter,
        connectionId: connectionId,
      ));
    }

    if (context == null) {
      return;
    }

    if (reason == CloseReason.error) {
      context.controller.addError(
        const StreamClosedWithErrorException(),
      );
    }

    return _closeControllers([context.controller]);
  }

  void createStream({
    required MethodStreamConnector methodConnector,
    required List<StreamParameterDescription> requestedInputStreams,
    required Session session,
    required Map<String, dynamic> args,
    required OpenMethodStreamCommand message,
    required SerializationManager serializationManager,
    required WebSocket webSocket,
  }) {
    var outputController = _createOutputController(
      message,
      methodConnector,
      webSocket,
      session,
      serializationManager,
    );

    var inputStreams = _createInputStreams(
      requestedInputStreams,
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
          outputController: outputController,
        );
        break;
      case MethodStreamReturnType.futureType:
      case MethodStreamReturnType.voidType:
        _handleMethodWithFutureReturn(
          methodConnector: methodConnector,
          session: session,
          args: args,
          streamParams: streamParams,
          outputController: outputController,
        );
        break;
    }
  }

  StreamController<dynamic> _createOutputController(
    OpenMethodStreamCommand message,
    MethodStreamConnector methodConnector,
    WebSocket webSocket,
    Session session,
    SerializationManager serializationManager,
  ) {
    var outputController = StreamController();
    _outputStreamContexts[_buildStreamKey(
      endpoint: message.endpoint,
      method: message.method,
      connectionId: message.connectionId,
    )] = _OutputStreamContext(
      outputController,
      methodConnector.streamParams.values,
    );

    outputController.stream.listen(
      (value) {
        webSocket.tryAdd(MethodStreamMessage.buildMessage(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId,
          object: value,
          serializationManager: serializationManager,
        ));
      },
      onDone: () async {
        await _closeOutboundStream(webSocket, message, CloseReason.done);
        await session.close();
        await tryCloseWebsocket(webSocket);
      },
      onError: (e, s) async {
        if (e is SerializableException) {
          webSocket.tryAdd(
            MethodStreamSerializableException.buildMessage(
              endpoint: message.endpoint,
              method: message.method,
              connectionId: message.connectionId,
              object: e,
              serializationManager: serializationManager,
            ),
          );
        }

        await _closeOutboundStream(webSocket, message, CloseReason.error);
        await session.close(error: e, stackTrace: s);
        await tryCloseWebsocket(webSocket);
      },
      // Cancel on error prevents the stream from continuing after an exception
      // has been thrown. This is important since we want to close the stream
      // when an exception is thrown and handle the complete shutdown in the
      // onError callback.
      cancelOnError: true,
    );

    return outputController;
  }

  /// Dispatches a message to the correct stream controller.
  bool dispatchMessage(
    MethodStreamMessage message,
    Server server,
  ) {
    var streamContext = _inputStreamContexts[_buildStreamKey(
      endpoint: message.endpoint,
      method: message.method,
      parameter: message.parameter,
      connectionId: message.connectionId,
    )];

    if (streamContext == null) {
      return false;
    }

    streamContext.controller.add(message.object);
    return true;
  }

  void dispatchSerializableException(
    MethodStreamSerializableException message,
    Server server,
  ) {
    var streamContext = _inputStreamContexts[_buildStreamKey(
      endpoint: message.endpoint,
      method: message.method,
      parameter: message.parameter,
      connectionId: message.connectionId,
    )];

    if (streamContext == null) {
      return;
    }

    var serializableException = message.exception;

    streamContext.controller.addError(serializableException);
  }

  String _buildStreamKey({
    required String endpoint,
    required String method,
    String? parameter,
    required UuidValue connectionId,
  }) =>
      '$connectionId:$endpoint:$method${parameter != null ? ':$parameter' : ''}';

  Future<void> _closeControllers(Iterable<StreamController> controllers) async {
    List<Future<void>> futures = [];
    // Close all controllers that have listeners.
    // If close is called on a controller that has no listeners, it will
    // return a future that never completes.
    var controllersToClose =
        controllers.where((c) => c.hasListener && !c.isClosed);

    for (var controller in controllersToClose) {
      // Paused streams will never process the close event and
      // will never complete. Therefore we need add a timeout to complete the
      // future.
      futures.add(controller.close().timeout(
            const Duration(seconds: 6),
            onTimeout: () async => await controller.onCancel?.call(),
          ));
    }

    await Future.wait(futures);
  }

  Map<String, StreamController> _createInputStreams(
    List<StreamParameterDescription> streamParamDescriptions,
    WebSocket webSocket,
    OpenMethodStreamCommand message,
  ) {
    var inputStreams = <String, StreamController>{};

    for (var streamParam in streamParamDescriptions) {
      var parameterName = streamParam.name;
      var controller = StreamController(onCancel: () async {
        var context = _inputStreamContexts.remove(_buildStreamKey(
          endpoint: message.endpoint,
          method: message.method,
          parameter: parameterName,
          connectionId: message.connectionId,
        ));

        if (context != null) {
          webSocket.tryAdd(CloseMethodStreamCommand.buildMessage(
            endpoint: message.endpoint,
            method: message.method,
            parameter: parameterName,
            connectionId: message.connectionId,
            reason: CloseReason.done,
          ));
        }

        await tryCloseWebsocket(webSocket);
      });

      inputStreams[parameterName] = controller;
      _inputStreamContexts[_buildStreamKey(
        endpoint: message.endpoint,
        method: message.method,
        parameter: parameterName,
        connectionId: message.connectionId,
      )] = _InputStreamContext(controller);
    }

    return inputStreams;
  }

  Future<void> _handleMethodWithFutureReturn({
    required MethodStreamConnector methodConnector,
    required Session session,
    required Map<String, dynamic> args,
    required Map<String, Stream<dynamic>> streamParams,
    required StreamController outputController,
  }) async {
    dynamic result;
    try {
      result = await methodConnector.call(session, args, streamParams);
    } catch (e, stackTrace) {
      outputController.addError(e, stackTrace);
      await outputController.close();
      return;
    }

    if (methodConnector.returnType != MethodStreamReturnType.voidType) {
      outputController.add(result);
    }

    await outputController.close();
  }

  Future<void> _closeOutboundStream(
    WebSocket webSocket,
    OpenMethodStreamCommand message,
    CloseReason reason,
  ) async {
    _outputStreamContexts.remove(
      _buildStreamKey(
          endpoint: message.endpoint,
          method: message.method,
          connectionId: message.connectionId),
    );
    webSocket.tryAdd(
      CloseMethodStreamCommand.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        reason: reason,
      ),
    );

    var inputStreamControllers = <StreamController>[];
    for (var streamParam in message.inputStreams) {
      var paramStreamContext = _inputStreamContexts.remove(_buildStreamKey(
        endpoint: message.endpoint,
        method: message.method,
        parameter: streamParam,
        connectionId: message.connectionId,
      ));

      if (paramStreamContext == null) {
        continue;
      }

      webSocket.tryAdd(
        CloseMethodStreamCommand.buildMessage(
          endpoint: message.endpoint,
          method: message.method,
          parameter: streamParam,
          connectionId: message.connectionId,
          reason: reason,
        ),
      );

      inputStreamControllers.add(paramStreamContext.controller);
    }

    return _closeControllers(inputStreamControllers);
  }

  void _handleMethodWithStreamReturn({
    required MethodStreamConnector methodConnector,
    required Session session,
    required Map<String, dynamic> args,
    required Map<String, Stream<dynamic>> streamParams,
    required StreamController outputController,
  }) {
    outputController
        .addStream(
          methodConnector.call(session, args, streamParams),
        )
        .whenComplete(
          () async => await outputController.close(),
        );
  }

  Future<void> tryCloseWebsocket(webSocket) async {
    if (_inputStreamContexts.isEmpty && _outputStreamContexts.isEmpty) {
      await webSocket.close();
    }
  }
}

extension on WebSocket {
  void tryAdd(dynamic data) {
    try {
      add(data);
    } catch (e) {
      stderr.writeln(
          'Error "$e", when trying to send data over websocket: $data');
    }
  }
}

class _OutputStreamContext implements _StreamContext {
  @override
  final StreamController controller;

  final Iterable<StreamParameterDescription> streamParams;

  _OutputStreamContext(this.controller, this.streamParams);
}

abstract interface class _StreamContext {
  StreamController get controller;
}

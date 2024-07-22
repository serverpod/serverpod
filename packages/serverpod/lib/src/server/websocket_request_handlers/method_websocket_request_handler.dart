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
          throw Exception(
            'Unknown message received on websocket connection: $jsonData',
          );
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
            if (message.parameter == null) {
              // Assume message is intended for method streams return stream.
              webSocket.tryAdd(BadRequestMessage.buildMessage(
                  'Server does not accept messages targeting the return stream.'));
              throw Exception(
                'Message targeting return stream received: $message',
              );
            }

            var success = _methodStreamManager.dispatchMessage(message, server);
            if (success) break;

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
            break;
          case CloseMethodStreamCommand():
            await _methodStreamManager.closeStream(
              endpoint: message.endpoint,
              method: message.method,
              parameter: message.parameter,
              connectionId: message.connectionId,
              reason: message.reason,
            );
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
    if (parameter == null) {
      return await _closeMethodStream(
        endpoint: endpoint,
        method: method,
        connectionId: connectionId,
        reason: reason,
      );
    }

    var paramStreamContext = _inputStreamContexts.remove(_buildStreamKey(
      endpoint: endpoint,
      method: method,
      parameter: parameter,
      connectionId: connectionId,
    ));

    if (paramStreamContext == null) {
      return;
    }

    if (reason == CloseReason.error) {
      paramStreamContext.controller.addError(
        const StreamClosedWithErrorException(),
      );
    }

    return _closeControllers([paramStreamContext.controller]);
  }

  void createStream({
    required MethodStreamConnector methodConnector,
    required Session session,
    required Map<String, dynamic> args,
    required OpenMethodStreamCommand message,
    required Server server,
    required WebSocket webSocket,
  }) {
    _registerOutputStream(webSocket, message, methodConnector);
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
      case MethodStreamReturnType.futureType:
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

  Future<void> _closeMethodStream({
    required String endpoint,
    required String method,
    required UuidValue connectionId,
    required CloseReason reason,
  }) async {
    var methodStreamContext = _outputStreamContexts.remove(_buildStreamKey(
      endpoint: endpoint,
      method: method,
      connectionId: connectionId,
    ));

    if (methodStreamContext == null) {
      return;
    }

    methodStreamContext.controller.add(
      CloseMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        connectionId: connectionId,
        method: method,
        reason: reason,
      ),
    );

    var controllers = <StreamController>[];
    controllers.add(methodStreamContext.controller);

    for (var streamParam in methodStreamContext.streamParams) {
      var paramStreamContext = _inputStreamContexts.remove(_buildStreamKey(
        endpoint: endpoint,
        method: method,
        parameter: streamParam.name,
        connectionId: connectionId,
      ));

      if (paramStreamContext == null) {
        continue;
      }

      methodStreamContext.controller.add(
        CloseMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          parameter: streamParam.name,
          connectionId: connectionId,
          reason: reason,
        ),
      );

      controllers.add(paramStreamContext.controller);
    }

    return _closeControllers(controllers);
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
        _inputStreamContexts.remove(_buildStreamKey(
          endpoint: message.endpoint,
          method: message.method,
          parameter: parameterName,
          connectionId: message.connectionId,
        ));

        webSocket.tryAdd(CloseMethodStreamCommand.buildMessage(
          endpoint: message.endpoint,
          method: message.method,
          parameter: parameterName,
          connectionId: message.connectionId,
          reason: CloseReason.done,
        ));

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
            object: e,
            serializationManager: server.serializationManager,
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
          object: result,
          serializationManager: server.serializationManager,
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
            object: value,
            serializationManager: server.serializationManager,
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
              object: e,
              serializationManager: server.serializationManager,
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
    var methodStreamController = _outputStreamContexts[_buildStreamKey(
      endpoint: endpoint,
      method: method,
      parameter: parameter,
      connectionId: connectionId,
    )];

    methodStreamController?.controller.add(message);
  }

  void _registerOutputStream(
    WebSocket webSocket,
    OpenMethodStreamCommand message,
    MethodStreamConnector methodStreamConnector,
  ) {
    var controller = StreamController<String>();
    controller.stream.listen((event) {
      webSocket.tryAdd(event);
    }, onDone: () async {
      await tryCloseWebsocket(webSocket);
    });

    _outputStreamContexts[_buildStreamKey(
      endpoint: message.endpoint,
      method: message.method,
      connectionId: message.connectionId,
    )] = _OutputStreamContext(
      controller,
      methodStreamConnector.streamParams.values,
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

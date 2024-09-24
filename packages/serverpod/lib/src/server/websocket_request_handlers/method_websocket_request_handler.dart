import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// This class is used by the [Server] to handle incoming websocket requests
/// to a method. It is not intended to be used directly by the user.
@internal
class MethodWebsocketRequestHandler {
  late final MethodStreamManager _methodStreamManager;

  /// Handles incoming websocket requests.
  /// Returns a [Future] that completes when the websocket is closed.
  Future<void> handleWebsocket(
    Server server,
    WebSocket webSocket,
    HttpRequest request,
    void Function() onClosed,
  ) async {
    _methodStreamManager = _createMethodStreamManager(webSocket, server);

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
              namespace: message.connectionId,
              parameter: message.parameter,
              reason: message.reason,
            );
            break;
          case MethodStreamSerializableException():
            _methodStreamManager.dispatchError(
              endpoint: message.endpoint,
              error: message.exception,
              method: message.method,
              namespace: message.connectionId,
              parameter: message.parameter,
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

  MethodStreamManager _createMethodStreamManager(
    WebSocket webSocket,
    Server server,
  ) {
    return MethodStreamManager(
      onInputStreamClosed: (
        UuidValue namespace,
        String parameterName,
        CloseReason? closeReason,
        MethodStreamCallContext callContext,
      ) {
        webSocket.tryAdd(
          CloseMethodStreamCommand.buildMessage(
            endpoint: callContext.endpoint.name,
            method: callContext.method.name,
            parameter: parameterName,
            connectionId: namespace,
            reason: closeReason ?? CloseReason.done,
          ),
        );
      },
      onOutputStreamClosed: (
        UuidValue namespace,
        CloseReason? closeReason,
        MethodStreamCallContext callContext,
      ) {
        webSocket.tryAdd(
          CloseMethodStreamCommand.buildMessage(
            endpoint: callContext.endpoint.name,
            method: callContext.method.name,
            connectionId: namespace,
            reason: closeReason ?? CloseReason.done,
          ),
        );
      },
      onOutputStreamError: (
        UuidValue namespace,
        Object error,
        StackTrace _,
        MethodStreamCallContext callContext,
      ) {
        if (error is SerializableException) {
          webSocket.tryAdd(
            MethodStreamSerializableException.buildMessage(
              endpoint: callContext.endpoint.name,
              method: callContext.method.name,
              connectionId: namespace,
              object: error,
              serializationManager: server.serializationManager,
            ),
          );
        }
      },
      onOutputStreamValue: (UuidValue namespace, Object? value,
          MethodStreamCallContext callContext) {
        webSocket.tryAdd(MethodStreamMessage.buildMessage(
          endpoint: callContext.endpoint.name,
          method: callContext.method.name,
          connectionId: namespace,
          object: value,
          serializationManager: server.serializationManager,
        ));
      },
      onAllStreamsClosed: () {
        webSocket.close();
      },
    );
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

    var success = _methodStreamManager.dispatchData(
      endpoint: message.endpoint,
      method: message.method,
      namespace: message.connectionId,
      value: message.object,
      parameter: message.parameter,
    );
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
    Map<String, dynamic> arguments;
    try {
      arguments = jsonDecode(message.encodedArgs);
    } catch (e) {
      server.serverpod.logVerbose(
        'Failed to parse arguments for open stream request: $message ($e)',
      );
      return OpenMethodStreamResponse.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.invalidArguments,
      );
    }

    MethodStreamSession? maybeSession;
    MethodStreamCallContext methodStreamCallContext;
    bool keepSessionOpen = false;
    try {
      methodStreamCallContext =
          await server.endpoints.getMethodStreamCallContext(
        createSessionCallback: (connector) {
          maybeSession = MethodStreamSession(
            server: server,
            authenticationKey: unwrapAuthHeaderValue(message.authentication),
            endpoint: message.endpoint,
            method: message.method,
            connectionId: message.connectionId,
            enableLogging: connector.endpoint.logSessions,
          );
          return maybeSession!;
        },
        endpointPath: message.endpoint,
        methodName: message.method,
        arguments: arguments,
        serializationManager: server.serializationManager,
        requestedInputStreams: message.inputStreams,
      );
      keepSessionOpen = true;
    } on MethodNotFoundException {
      server.serverpod.logVerbose(
        'Endpoint method not found for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        connectionId: message.connectionId,
        endpoint: message.endpoint,
        method: message.method,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    } on EndpointNotFoundException {
      server.serverpod.logVerbose(
        'Endpoint not found for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        connectionId: message.connectionId,
        endpoint: message.endpoint,
        method: message.method,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    } on InvalidEndpointMethodTypeException {
      server.serverpod.logVerbose(
        'Endpoint method is not a valid stream method: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    } on InvalidParametersException catch (e) {
      server.serverpod.logVerbose(
        'Failed to parse parameters or input streams for open stream request: $message (${e.message})',
      );
      return OpenMethodStreamResponse.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.invalidArguments,
      );
    } on NotAuthorizedException catch (e) {
      server.serverpod.logVerbose(
        'Authentication failed for open stream request: $message',
      );
      return switch (e.authenticationFailedResult.reason) {
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
    } catch (e) {
      server.serverpod.logVerbose(
        'Unexpected error when opening stream: $e',
      );
      throw StateError('Unexpected error when opening stream: $e');
    } finally {
      if (!keepSessionOpen) await maybeSession?.close();
    }

    MethodStreamSession? session = maybeSession;
    if (session == null) {
      throw StateError('MethodStreamSession was not created.');
    }

    _methodStreamManager.createStream(
      session: session,
      methodStreamCallContext: methodStreamCallContext,
      namespace: message.connectionId,
    );

    return OpenMethodStreamResponse.buildMessage(
      endpoint: message.endpoint,
      method: message.method,
      connectionId: message.connectionId,
      responseType: OpenMethodStreamResponseType.success,
    );
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

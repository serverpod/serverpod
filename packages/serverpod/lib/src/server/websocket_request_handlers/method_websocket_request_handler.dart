import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/service/console_logger.dart';
import 'package:serverpod/src/service/service_manager.dart';

import 'helpers/method_stream_manager.dart';

/// This class is used by the [Server] to handle incoming websocket requests
/// to a method. It is not intended to be used directly by the user.
@internal
class MethodWebsocketRequestHandler {
  /// Handles incoming websocket requests.
  /// Returns a [Future] that completes when the websocket is closed.
  static Future<void> handleWebsocket(
    Server server,
    WebSocket webSocket,
    HttpRequest request,
    void Function() onClosed,
  ) async {
    ConsoleLogger? logger = ServiceManager.request(ServiceManager.defaultId).locate<ConsoleLogger>();

    var methodStreamManager = _createMethodStreamManager(webSocket, server);

    try {
      logger?.logVerbose('Method websocket connection established.');
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
          case OpenMethodStreamCommand(
              endpoint: var endpoint,
              method: var method,
              connectionId: var connectionId,
            ):
            logger?.logVerbose('Open method stream command for $endpoint.$method, id $connectionId');
            webSocket.tryAdd(
              await _handleOpenMethodStreamCommand(
                server,
                webSocket,
                message,
                methodStreamManager,
              ),
            );
            break;
          case OpenMethodStreamResponse(
              endpoint: var endpoint,
              method: var method,
              connectionId: var connectionId,
            ):
            logger?.logVerbose('Open method stream response for $endpoint.$method, id $connectionId');
            break;
          case MethodStreamMessage():
            _dispatchMethodStreamMessage(
              message,
              webSocket,
              server,
              methodStreamManager,
            );
            break;
          case CloseMethodStreamCommand(
              endpoint: var endpoint,
              method: var method,
              connectionId: var connectionId,
            ):
            logger?.logVerbose('Close method stream command for $endpoint.$method, id $connectionId');
            await methodStreamManager.closeStream(
              endpoint: message.endpoint,
              method: message.method,
              methodStreamId: message.connectionId,
              parameter: message.parameter,
              reason: message.reason,
            );
            break;
          case MethodStreamSerializableException():
            methodStreamManager.dispatchError(
              endpoint: message.endpoint,
              error: message.exception,
              method: message.method,
              methodStreamId: message.connectionId,
              parameter: message.parameter,
            );
            break;
          case PingCommand():
            webSocket.tryAdd(PongCommand.buildMessage());
            break;
          case PongCommand():
            break;
          case BadRequestMessage():
            logger?.logVerbose(
              'Bad request message: ${message.request}, closing connection.',
            );
            return;
        }
      }
    } catch (e, stackTrace) {
      if (e is! UnknownMessageException || server.serverpod.runtimeSettings.logMalformedCalls) {
        stderr.writeln('${DateTime.now().toUtc()} Method stream websocket error: $e');
        stderr.writeln('$stackTrace');
      }
    } finally {
      logger?.logVerbose(
        'Closing method stream websocket while '
        '${methodStreamManager.openOutputStreamCount} out-streams and '
        '${methodStreamManager.openInputStreamCount} in-streams still open.',
      );
      await methodStreamManager.closeAllStreams();
      // Send a close message to the client.
      await webSocket.close();
      onClosed();
    }
  }

  static MethodStreamManager _createMethodStreamManager(
    WebSocket webSocket,
    Server server,
  ) {
    return MethodStreamManager(
      onInputStreamClosed: (
        UuidValue methodStreamId,
        String parameterName,
        CloseReason? closeReason,
        MethodStreamCallContext callContext,
      ) {
        webSocket.tryAdd(
          CloseMethodStreamCommand.buildMessage(
            endpoint: callContext.fullEndpointPath,
            method: callContext.method.name,
            parameter: parameterName,
            connectionId: methodStreamId,
            reason: closeReason ?? CloseReason.done,
          ),
        );
      },
      onOutputStreamClosed: (
        UuidValue methodStreamId,
        CloseReason? closeReason,
        MethodStreamCallContext callContext,
      ) {
        webSocket.tryAdd(
          CloseMethodStreamCommand.buildMessage(
            endpoint: callContext.fullEndpointPath,
            method: callContext.method.name,
            connectionId: methodStreamId,
            reason: closeReason ?? CloseReason.done,
          ),
        );
      },
      onOutputStreamError: (
        UuidValue methodStreamId,
        Object error,
        StackTrace _,
        MethodStreamCallContext callContext,
      ) {
        if (error is SerializableException) {
          webSocket.tryAdd(
            MethodStreamSerializableException.buildMessage(
              endpoint: callContext.fullEndpointPath,
              method: callContext.method.name,
              connectionId: methodStreamId,
              object: error,
              serializationManager: server.serializationManager,
            ),
          );
        }
      },
      onOutputStreamValue: (
        UuidValue methodStreamId,
        Object? value,
        MethodStreamCallContext callContext,
      ) {
        webSocket.tryAdd(MethodStreamMessage.buildMessage(
          endpoint: callContext.fullEndpointPath,
          method: callContext.method.name,
          connectionId: methodStreamId,
          object: value,
          serializationManager: server.serializationManager,
        ));
      },
    );
  }

  static void _dispatchMethodStreamMessage(
    MethodStreamMessage message,
    WebSocket webSocket,
    Server server,
    MethodStreamManager methodStreamManager,
  ) {
    if (message.parameter == null) {
      // Assume message is intended for method streams return stream.
      webSocket.tryAdd(BadRequestMessage.buildMessage('Server does not accept messages targeting the return stream.'));
      throw Exception(
        'Message targeting return stream received: $message',
      );
    }

    var success = methodStreamManager.dispatchData(
      endpoint: message.endpoint,
      method: message.method,
      methodStreamId: message.connectionId,
      value: message.object,
      parameter: message.parameter,
    );
    if (success) return;

    ServiceManager.request(ServiceManager.defaultId).locate<ConsoleLogger>()?.logVerbose(
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

  static Future<String> _handleOpenMethodStreamCommand(
    Server server,
    WebSocket webSocket,
    OpenMethodStreamCommand message,
    MethodStreamManager methodStreamManager,
  ) async {
    ConsoleLogger? logger = ServiceManager.request(ServiceManager.defaultId).locate<ConsoleLogger>();
    Map<String, dynamic> arguments;
    try {
      arguments = jsonDecode(message.encodedArgs);
    } catch (e) {
      logger?.logVerbose(
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
      methodStreamCallContext = await server.endpoints.getMethodStreamCallContext(
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
      logger?.logVerbose(
        'Endpoint method not found for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        connectionId: message.connectionId,
        endpoint: message.endpoint,
        method: message.method,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    } on EndpointNotFoundException {
      logger?.logVerbose(
        'Endpoint not found for open stream request: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        connectionId: message.connectionId,
        endpoint: message.endpoint,
        method: message.method,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    } on InvalidEndpointMethodTypeException {
      logger?.logVerbose(
        'Endpoint method is not a valid stream method: $message',
      );
      return OpenMethodStreamResponse.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    } on InvalidParametersException catch (e) {
      logger?.logVerbose(
        'Failed to parse parameters or input streams for open stream request: $message (${e.message})',
      );
      return OpenMethodStreamResponse.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.invalidArguments,
      );
    } on NotAuthorizedException catch (e) {
      logger?.logVerbose(
        'Authentication failed for open stream request: $message',
      );
      return switch (e.authenticationFailedResult.reason) {
        AuthenticationFailureReason.insufficientAccess => OpenMethodStreamResponse.buildMessage(
            endpoint: message.endpoint,
            method: message.method,
            connectionId: message.connectionId,
            responseType: OpenMethodStreamResponseType.authorizationDeclined,
          ),
        AuthenticationFailureReason.unauthenticated => OpenMethodStreamResponse.buildMessage(
            endpoint: message.endpoint,
            method: message.method,
            connectionId: message.connectionId,
            responseType: OpenMethodStreamResponseType.authenticationFailed,
          ),
      };
    } catch (e) {
      logger?.logVerbose(
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

    methodStreamManager.createStream(
      session: session,
      methodStreamCallContext: methodStreamCallContext,
      methodStreamId: message.connectionId,
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
      stderr.writeln('Error "$e", when trying to send data over websocket: $data');
    }
  }
}

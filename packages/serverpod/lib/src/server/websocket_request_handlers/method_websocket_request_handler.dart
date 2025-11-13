import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod/src/server/session.dart';
import 'package:web_socket/web_socket.dart';

import 'helpers/method_stream_manager.dart';

/// This class is used by the [Server] to handle incoming websocket requests
/// to a method. It is not intended to be used directly by the user.
@internal
class MethodWebsocketRequestHandler {
  /// Handles incoming websocket requests.
  /// Returns a [Future] that completes when the websocket is closed.
  static Future<void> handleWebsocket(
    Server server,
    RelicWebSocket webSocket,
    Request request,
    void Function() onClosed,
  ) async {
    var webSocketIntermediary = _WebSocketIntermediary(
      server: server,
      webSocket: webSocket,
      request: request,
    );

    var methodStreamManager = _createMethodStreamManager(
      webSocketIntermediary,
      server,
    );

    try {
      server.serverpod.logVerbose('Method websocket connection established.');
      await for (final event in webSocket.events) {
        final jsonData = switch (event) {
          TextDataReceived() => event.text,
          BinaryDataReceived() => utf8.decode(event.data),
          CloseReceived() => null,
        };
        if (jsonData == null) continue;
        WebSocketMessage message;
        try {
          message = WebSocketMessage.fromJsonString(
            jsonData,
            server.serializationManager,
          );
        } on UnknownMessageException catch (_) {
          webSocketIntermediary.tryAdd(
            BadRequestMessage.buildMessage(jsonData),
          );
          rethrow;
        }

        switch (message) {
          case OpenMethodStreamCommand(
            endpoint: var endpoint,
            method: var method,
            connectionId: var connectionId,
          ):
            server.serverpod.logVerbose(
              'Open method stream command for $endpoint.$method, id $connectionId',
            );
            webSocketIntermediary.tryAdd(
              await _handleOpenMethodStreamCommand(
                server,
                webSocketIntermediary,
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
            server.serverpod.logVerbose(
              'Open method stream response for $endpoint.$method, id $connectionId',
            );
            break;
          case MethodStreamMessage():
            _dispatchMethodStreamMessage(
              message,
              webSocketIntermediary,
              server,
              methodStreamManager,
            );
            break;
          case CloseMethodStreamCommand(
            endpoint: var endpoint,
            method: var method,
            connectionId: var connectionId,
          ):
            server.serverpod.logVerbose(
              'Close method stream command for $endpoint.$method, id $connectionId',
            );
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
            webSocketIntermediary.tryAdd(PongCommand.buildMessage());
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
      server.serverpod.internalSubmitEvent(
        ExceptionEvent(e, stackTrace, message: 'Method stream websocket error'),
        space: OriginSpace.framework,
        context: contextFromRequest(server, request, OperationType.stream),
      );
      if (e is! UnknownMessageException ||
          server.serverpod.runtimeSettings.logMalformedCalls) {
        stderr.writeln(
          '${DateTime.now().toUtc()} Method stream websocket error: $e',
        );
        stderr.writeln('$stackTrace');
      }
    } finally {
      server.serverpod.logVerbose(
        'Closing method stream websocket while '
        '${methodStreamManager.openOutputStreamCount} out-streams and '
        '${methodStreamManager.openInputStreamCount} in-streams still open.',
      );
      await methodStreamManager.closeAllStreams();
      await webSocket.tryClose();
      onClosed();
    }
  }

  static MethodStreamManager _createMethodStreamManager(
    _WebSocketIntermediary webSocket,
    Server server,
  ) {
    return MethodStreamManager(
      request: webSocket.request,
      onInputStreamClosed:
          (
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
      onOutputStreamClosed:
          (
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
      onOutputStreamError:
          (
            UuidValue methodStreamId,
            Object error,
            StackTrace stackTrace,
            MethodStreamCallContext callContext,
          ) {
            server.serverpod.internalSubmitEvent(
              ExceptionEvent(error, stackTrace),
              space: OriginSpace.application,
              context: _makeEventContext(
                server,
                request: webSocket.request,
                endpoint: callContext.endpoint.name,
                method: callContext.method.name,
                streamConnectionId: methodStreamId,
              ),
            );

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
      onOutputStreamValue:
          (
            UuidValue methodStreamId,
            Object? value,
            MethodStreamCallContext callContext,
          ) {
            webSocket.tryAdd(
              MethodStreamMessage.buildMessage(
                endpoint: callContext.fullEndpointPath,
                method: callContext.method.name,
                connectionId: methodStreamId,
                object: value,
                serializationManager: server.serializationManager,
              ),
            );
          },
    );
  }

  static void _dispatchMethodStreamMessage(
    MethodStreamMessage message,
    _WebSocketIntermediary webSocket,
    Server server,
    MethodStreamManager methodStreamManager,
  ) {
    if (message.parameter == null) {
      // Assume message is intended for method streams return stream.
      webSocket.tryAdd(
        BadRequestMessage.buildMessage(
          'Server does not accept messages targeting the return stream.',
        ),
      );
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

    server.serverpod.logVerbose(
      'Failed to dispatch message: $message',
    );

    webSocket.tryAdd(
      CloseMethodStreamCommand.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
        parameter: message.parameter,
        connectionId: message.connectionId,
        reason: CloseReason.error,
      ),
    );
  }

  static Future<String> _handleOpenMethodStreamCommand(
    Server server,
    _WebSocketIntermediary webSocket,
    OpenMethodStreamCommand message,
    MethodStreamManager methodStreamManager,
  ) async {
    Map<String, dynamic> arguments;
    try {
      arguments = jsonDecode(message.encodedArgs);
    } catch (e, stackTrace) {
      _reportFrameworkException(
        server,
        e,
        stackTrace,
        message: 'Failed to parse arguments for open stream request: $message',
        streamCommandMessage: message,
        webSocketIntermediary: webSocket,
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
      methodStreamCallContext = await server.endpoints
          .getMethodStreamCallContext(
            createSessionCallback: (connector) async {
              maybeSession =
                  await SessionInternalMethods.createMethodStreamSession(
                    server: server,
                    authenticationKey: unwrapAuthHeaderValue(
                      message.authentication,
                    ),
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
    } on MethodNotFoundException catch (e, stackTrace) {
      _reportFrameworkException(
        server,
        e,
        stackTrace,
        message: 'Endpoint method not found for open stream request: $message',
        streamCommandMessage: message,
        webSocketIntermediary: webSocket,
        session: maybeSession,
      );
      return OpenMethodStreamResponse.buildMessage(
        connectionId: message.connectionId,
        endpoint: message.endpoint,
        method: message.method,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    } on EndpointNotFoundException catch (e, stackTrace) {
      _reportFrameworkException(
        server,
        e,
        stackTrace,
        message: 'Endpoint not found for open stream request: $message',
        streamCommandMessage: message,
        webSocketIntermediary: webSocket,
        session: maybeSession,
      );
      return OpenMethodStreamResponse.buildMessage(
        connectionId: message.connectionId,
        endpoint: message.endpoint,
        method: message.method,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    } on InvalidEndpointMethodTypeException catch (e, stackTrace) {
      _reportFrameworkException(
        server,
        e,
        stackTrace,
        message: 'Endpoint method is not a valid stream method: $message',
        streamCommandMessage: message,
        webSocketIntermediary: webSocket,
        session: maybeSession,
      );
      return OpenMethodStreamResponse.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.endpointNotFound,
      );
    } on InvalidParametersException catch (e, stackTrace) {
      _reportFrameworkException(
        server,
        e,
        stackTrace,
        message:
            'Failed to parse parameters or input streams for open stream request: $message (${e.message})',
        streamCommandMessage: message,
        webSocketIntermediary: webSocket,
        session: maybeSession,
      );
      return OpenMethodStreamResponse.buildMessage(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        responseType: OpenMethodStreamResponseType.invalidArguments,
      );
    } on NotAuthorizedException catch (e, stackTrace) {
      _reportFrameworkException(
        server,
        e,
        stackTrace,
        message: 'Authentication failed for open stream request: $message',
        streamCommandMessage: message,
        webSocketIntermediary: webSocket,
        session: maybeSession,
      );
      return switch (e.reason) {
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

  static void _reportFrameworkException(
    Server server,
    Object e,
    StackTrace stackTrace, {
    required _WebSocketIntermediary webSocketIntermediary,
    WebSocketMessageInfo? streamCommandMessage,
    MethodStreamSession? session,
    String? message,
  }) {
    if (message != null) {
      server.serverpod.logVerbose(message);
    }

    server.serverpod.internalSubmitEvent(
      ExceptionEvent(e, stackTrace, message: message),
      space: OriginSpace.framework,
      context: streamCommandMessage != null
          ? _makeEventContext(
              server,
              request: webSocketIntermediary.request,
              endpoint: streamCommandMessage.endpoint,
              method: streamCommandMessage.method,
              streamConnectionId: streamCommandMessage.connectionId,
              session: session,
            )
          : contextFromServer(server),
    );
  }
}

StreamOpContext _makeEventContext(
  Server server, {
  required Request request,
  required String endpoint,
  required String method,
  required UuidValue streamConnectionId,
  MethodStreamSession? session,
}) {
  return StreamOpContext(
    serverName: server.name,
    serverId: server.serverId,
    serverRunMode: server.runMode,
    sessionId: session?.sessionId,
    userAuthInfo: session?.authInfoOrNull,
    remoteInfo: session?.remoteInfo,
    uri: request.requestedUri,
    endpoint: endpoint,
    methodName: method,
    streamConnectionId: streamConnectionId,
  );
}

class _WebSocketIntermediary {
  final Server server;
  final RelicWebSocket _webSocket;
  final Request request;

  _WebSocketIntermediary({
    required this.server,
    required RelicWebSocket webSocket,
    required this.request,
  }) : _webSocket = webSocket;

  void tryAdd(dynamic data) {
    try {
      return switch (data) {
        String s => _webSocket.sendText(s),
        Uint8List b => _webSocket.sendBytes(b),
        _ => throw ArgumentError.notNull('data'),
      };
    } catch (e, stackTrace) {
      stderr.writeln(
        'Error "$e", when trying to send data over websocket: $data',
      );

      MethodWebsocketRequestHandler._reportFrameworkException(
        server,
        e,
        stackTrace,
        message: 'Error when trying to send data over websocket: $data',
        webSocketIntermediary: this,
      );
    }
  }
}

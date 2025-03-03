import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod/src/server/session.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';

/// This class is used by the [Server] to handle incoming websocket requests
/// to an endpoint. It is not intended to be used directly by the user.
abstract class EndpointWebsocketRequestHandler {
  /// Creates a new [StreamingSession] and handles incoming websocket requests.
  /// Returns a [Future] that completes when the websocket is closed.
  ///
  /// This method dispatches incoming messages to the correct endpoint and
  /// handles control messages such as 'ping' and 'auth'.
  static Future<void> handleWebsocket(
    Server server,
    WebSocket webSocket,
    HttpRequest request,
    void Function() onClosed,
  ) async {
    try {
      var session = StreamingSession(
        server: server,
        uri: request.uri,
        httpRequest: request,
        webSocket: webSocket,
      );

      var endpointDispatch = server.endpoints;
      for (var endpointConnector in endpointDispatch.connectors.values) {
        await _callStreamOpened(
            session, endpointConnector.endpoint.name, endpointDispatch);
      }
      for (var module in endpointDispatch.modules.values) {
        for (var endpointConnector in module.connectors.values) {
          await _callStreamOpened(
              session, endpointConnector.endpoint.name, module);
        }
      }

      dynamic error;
      StackTrace? stackTrace;

      try {
        await for (String jsonData in webSocket) {
          var data = jsonDecode(jsonData) as Map;

          // Handle control commands.
          var command = data['command'] as String?;
          if (command != null) {
            var args = data['args'] as Map;

            if (command == 'ping') {
              webSocket.add(
                SerializationManager.encodeForProtocol(
                  {'command': 'pong'},
                ),
              );
            } else if (command == 'auth') {
              var authKey = args['key'] as String?;
              session.updateAuthenticationKey(unwrapAuthHeaderValue(authKey));
            }
            continue;
          }

          // Handle messages passed to endpoints.
          var endpointName = data['endpoint'] as String;
          var serialization = data['object'] as Map<String, dynamic>;

          EndpointConnector endpointConnector;
          try {
            endpointConnector = await server.endpoints.getEndpointConnector(
                session: session, endpointPath: endpointName);
          } on NotAuthorizedException catch (e, s) {
            _reportException(server, e, s, session: session);
            continue;
          } on EndpointNotFoundException {
            throw Exception('Endpoint not found: $endpointName');
          }

          // Process the message.
          var startTime = DateTime.now();
          dynamic messageError;
          StackTrace? messageStackTrace;

          SerializableModel? message;
          try {
            session.endpoint = endpointName;

            message = server.serializationManager
                .deserializeByClassName(serialization);

            if (message == null) throw Exception('Streamed message was null');

            await endpointConnector.endpoint
                .handleStreamMessage(session, message);
          } catch (e, s) {
            messageError = e;
            messageStackTrace = s;

            _reportException(server, e, s,
                message:
                    'Internal server error. Uncaught exception in handleStreamMessage.',
                session: session);
          }

          var duration = DateTime.now().difference(startTime);
          unawaited(session.logManager?.logMessage(
            messageId: session.nextMessageId(),
            endpointName: endpointName,
            messageName: serialization['className'],
            duration: duration,
            error: messageError?.toString(),
            stackTrace: messageStackTrace,
          ));
        }
      } catch (e, s) {
        error = e;
        stackTrace = s;

        _reportException(server, e, s, session: session);
      }

      // TODO: Possibly keep a list of open streams instead
      for (var endpointConnector in server.endpoints.connectors.values) {
        await _callStreamClosed(
            session, endpointConnector.endpoint.name, endpointDispatch);
      }
      for (var module in server.endpoints.modules.values) {
        for (var endpointConnector in module.connectors.values) {
          await _callStreamClosed(
              session, endpointConnector.endpoint.name, module);
        }
      }
      await session.close(error: error, stackTrace: stackTrace);
    } catch (e, s) {
      _reportException(server, e, s, httpRequest: request);
      return;
    } finally {
      onClosed();
    }
  }

  static Future<void> _callStreamOpened(
    StreamingSession session,
    String endpointName,
    EndpointDispatch endpointDispatch,
  ) async {
    try {
      session.endpoint = endpointName;
      var connector = await endpointDispatch.getEndpointConnector(
        session: session,
        endpointPath: endpointName,
      );
      await connector.endpoint.streamOpened(session);
    } on NotAuthorizedException catch (e, s) {
      _reportException(session.server, e, s, session: session);
      return;
    } catch (e, s) {
      _reportException(session.server, e, s, session: session);
      return;
    }
  }

  static Future<void> _callStreamClosed(
    StreamingSession session,
    String endpointName,
    EndpointDispatch endpointDispatch,
  ) async {
    try {
      session.endpoint = endpointName;
      var connector = await endpointDispatch.getEndpointConnector(
        session: session,
        endpointPath: endpointName,
      );
      await connector.endpoint.streamClosed(session);
    } on NotAuthorizedException catch (e, s) {
      _reportException(session.server, e, s, session: session);
      return;
    } catch (e, s) {
      _reportException(session.server, e, s, session: session);
      return;
    }
  }

  static void _reportException(
    Server server,
    Object e,
    StackTrace stackTrace, {
    OriginSpace space = OriginSpace.framework,
    String? message,
    HttpRequest? httpRequest,
    StreamingSession? session,
  }) {
    var now = DateTime.now().toUtc();
    if (message != null) {
      stderr.writeln('$now ERROR: $message');
    }
    stderr.writeln('$now ERROR: $e');
    stderr.writeln('$stackTrace');

    var context = session != null
        ? contextFromSession(session, httpRequest: httpRequest)
        : httpRequest != null
            ? contextFromHttpRequest(server, httpRequest, OperationType.stream)
            : contextFromServer(server);

    server.serverpod.internalSubmitEvent(
      ExceptionEvent(e, stackTrace, message: message),
      space: space,
      context: context,
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/session.dart';

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

      await _callStreamOpened(session, server.endpoints);
      for (var module in server.endpoints.modules.values) {
        await _callStreamOpened(session, module);
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
              session.updateAuthenticationKey(authKey);
            }
            continue;
          }

          // Handle messages passed to endpoints.
          var endpointName = data['endpoint'] as String;
          var serialization = data['object'] as Map<String, dynamic>;

          EndpointConnector endpointConnector;
          try {
            endpointConnector = await server.endpoints.getAuthorizedEndpoint(
                session: session, endpointPath: endpointName);
          } on NotAuthorizedException {
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
            stderr.writeln('${DateTime.now().toUtc()} Internal server error. '
                'Uncaught exception in handleStreamMessage.');
            stderr.writeln('$e');
            stderr.writeln('$s');
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
      }

      // TODO: Possibly keep a list of open streams instead
      await _callStreamClosed(session, server.endpoints);
      for (var module in server.endpoints.modules.values) {
        await _callStreamClosed(session, module);
      }
      await session.close(error: error, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
      return;
    } finally {
      onClosed();
    }
  }

  static Future<void> _callStreamOpened(
    StreamingSession session,
    EndpointDispatch endpointDispatch,
  ) async {
    for (var endpointConnector in endpointDispatch.connectors.values) {
      EndpointConnector connector;
      try {
        session.endpoint = endpointConnector.name;
        connector = await endpointDispatch.getAuthorizedEndpoint(
            session: session, endpointPath: endpointConnector.name);
        await connector.endpoint.streamOpened(session);
      } on NotAuthorizedException {
        continue;
      } catch (e) {
        return;
      }
    }
  }

  static Future<void> _callStreamClosed(
    StreamingSession session,
    EndpointDispatch endpointDispatch,
  ) async {
    for (var endpointConnector in endpointDispatch.connectors.values) {
      EndpointConnector connector;
      try {
        session.endpoint = endpointConnector.name;
        connector = await endpointDispatch.getAuthorizedEndpoint(
            session: session, endpointPath: endpointConnector.name);
        await connector.endpoint.streamClosed(session);
      } on NotAuthorizedException {
        continue;
      } catch (e) {
        return;
      }
    }
  }
}

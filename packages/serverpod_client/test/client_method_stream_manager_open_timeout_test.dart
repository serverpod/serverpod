@OnPlatform({
  'browser': Skip('WebSocket tests are not supported in browser'),
})
library;

import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:test/test.dart';

import 'integration/websocket_extensions.dart';
import 'test_utils/method_stream_connection_details_builder.dart';
import 'test_utils/test_web_socket_server.dart';

class TestSerializationManager extends SerializationManager {}

void main() {
  group(
    'Given a websocket server that never answers the stream open command,',
    () {
      var connectionsAccepted = 0;
      Completer<Uri> callbackUrlFuture;
      late Uri webSocketHost;
      late Future<void> Function() closeServer;

      setUp(() async {
        connectionsAccepted = 0;
        callbackUrlFuture = Completer<Uri>();
        closeServer = await TestWebSocketServer.startServer(
          webSocketHandler: (webSocket) {
            connectionsAccepted++;
            webSocket.textEvents.listen((event) {
              // Answer only the handshake ping, never the open command.
              webSocket.sendText(PongCommand.buildMessage());
            });
          },
          onConnected: (host) {
            callbackUrlFuture.complete(host);
          },
        );

        webSocketHost = await callbackUrlFuture.future;
      });

      tearDown(() async => await closeServer());

      test(
        'when opening a method stream on the held half-open socket '
        'then ConnectionAttemptTimedOutException is thrown without waiting for the idle timeout.',
        () async {
          var streamManager = ClientMethodStreamManager(
            connectionTimeout: const Duration(milliseconds: 100),
            webSocketHost: webSocketHost,
            serializationManager: TestSerializationManager(),
          );

          await expectLater(
            streamManager.openMethodStream(
              MethodStreamConnectionDetailsBuilder().build(),
            ),
            throwsA(isA<ConnectionAttemptTimedOutException>()),
          );
        },
      );

      test(
        'when a stream open times out and another stream is opened afterwards '
        'then a new websocket connection is established.',
        () async {
          var streamManager = ClientMethodStreamManager(
            connectionTimeout: const Duration(milliseconds: 100),
            webSocketHost: webSocketHost,
            serializationManager: TestSerializationManager(),
          );

          await expectLater(
            streamManager.openMethodStream(
              MethodStreamConnectionDetailsBuilder().build(),
            ),
            throwsA(isA<ConnectionAttemptTimedOutException>()),
          );

          // Allow the connection teardown triggered by the timeout to complete.
          await Future<void>.delayed(const Duration(milliseconds: 200));

          await expectLater(
            streamManager.openMethodStream(
              MethodStreamConnectionDetailsBuilder().build(),
            ),
            throwsA(isA<ConnectionAttemptTimedOutException>()),
          );

          expect(connectionsAccepted, 2);
        },
      );

      test(
        'when the connection is closed while a stream open is pending '
        'then the pending open completes with an error.',
        () async {
          var streamManager = ClientMethodStreamManager(
            connectionTimeout: const Duration(seconds: 10),
            webSocketHost: webSocketHost,
            serializationManager: TestSerializationManager(),
          );

          var openFuture = streamManager.openMethodStream(
            MethodStreamConnectionDetailsBuilder().build(),
          );

          // Let the open command be sent before closing the connection.
          await Future<void>.delayed(const Duration(milliseconds: 100));

          // Attach the expectation before closing, so the error has a listener.
          var expectation = expectLater(
            openFuture,
            throwsA(isA<WebSocketClosedException>()),
          );

          await streamManager.closeAllConnections();

          await expectation;
        },
      );
    },
  );
}

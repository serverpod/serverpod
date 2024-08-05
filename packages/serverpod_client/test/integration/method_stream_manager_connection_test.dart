import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:serverpod_client/src/method_stream/method_stream_manager_exceptions.dart';
import 'package:test/test.dart';

import '../test_utils/method_stream_connection_details_builder.dart';
import '../test_utils/test_web_socket_server.dart';

class TestSerializationManager extends SerializationManager {}

void main() async {
  test(
      'Given no websocket server when attempting to connect then WebSocketConnectException is thrown.',
      () {
    var streamManager = ClientMethodStreamManager(
      connectionTimeout: const Duration(milliseconds: 100),
      webSocketHost: Uri.parse('ws://localhost:12345'),
      serializationManager: TestSerializationManager(),
    );

    expect(
      () => streamManager.openMethodStream(
        MethodStreamConnectionDetailsBuilder().build(),
      ),
      throwsA(isA<WebSocketConnectException>()),
    );
  });

  group('Given non responsive websocket server', () {
    Completer<Uri> callbackUrlFuture;
    late Uri webSocketHost;
    late Future<void> Function() closeServer;
    late int pingCommandsReceived;
    setUp(() async {
      pingCommandsReceived = 0;
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          webSocket.listen((event) {
            pingCommandsReceived++;
            // Do nothing
          });
        },
        onConnected: (host) {
          callbackUrlFuture.complete(host);
        },
      );

      webSocketHost = await callbackUrlFuture.future;
    });

    tearDown(() => closeServer());

    test(
        'when trying to open method stream then ConnectionAttemptTimedOutException is thrown.',
        () async {
      var streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 100),
        webSocketHost: webSocketHost,
        serializationManager: TestSerializationManager(),
      );

      expect(
        () => streamManager.openMethodStream(
          MethodStreamConnectionDetailsBuilder().build(),
        ),
        throwsA(isA<ConnectionAttemptTimedOutException>()),
      );
    });

    test(
        'when trying to open multiple method streams then a connection attempt is made for each method stream.',
        () async {
      var streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 100),
        webSocketHost: webSocketHost,
        serializationManager: TestSerializationManager(),
      );

      Future<void> openMethodStream() async => streamManager.openMethodStream(
            MethodStreamConnectionDetailsBuilder().build(),
          );

      await Future.wait([
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
      ]).onError<ConnectionAttemptTimedOutException>(
        (error, stackTrace) => Future.value([]),
      );

      expect(pingCommandsReceived, 5);
    });
  });

  group('Given websocket server that completes initialization sequence', () {
    Completer<Uri> callbackUrlFuture;
    late Uri webSocketHost;
    late Future<void> Function() closeServer;
    late int pingCommandsReceived;
    setUp(() async {
      pingCommandsReceived = 0;
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          webSocket.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              TestSerializationManager(),
            );
            if (message is PingCommand) {
              pingCommandsReceived++;
              webSocket.add(PongCommand.buildMessage());
            } else if (message is OpenMethodStreamCommand) {
              webSocket.add(OpenMethodStreamResponse.buildMessage(
                connectionId: message.connectionId,
                endpoint: message.endpoint,
                method: message.method,
                responseType: OpenMethodStreamResponseType.success,
              ));
            }
          });
        },
        onConnected: (host) {
          callbackUrlFuture.complete(host);
        },
      );

      webSocketHost = await callbackUrlFuture.future;
    });

    tearDown(() => closeServer());
    test(
        'when trying to open multiple method streams at once then single connection is validated using ping commands.',
        () async {
      var streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 100),
        webSocketHost: webSocketHost,
        serializationManager: TestSerializationManager(),
      );

      Future<void> openMethodStream() async => streamManager.openMethodStream(
            MethodStreamConnectionDetailsBuilder().build(),
          );

      await Future.wait([
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
      ]);
      expect(pingCommandsReceived, 1);
    });
  });
}

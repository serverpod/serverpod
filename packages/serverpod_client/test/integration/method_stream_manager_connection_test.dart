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
    setUp(() async {
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          webSocket.listen((event) {
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
  });
}

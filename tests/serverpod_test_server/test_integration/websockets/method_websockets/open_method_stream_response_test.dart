import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import '../websocket_extensions.dart';

void main() {
  group('Given method websocket connection', () {
    late Serverpod server;
    late WebSocket webSocket;

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = await WebSocket.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      await webSocket.tryClose();
    });

    test(
      'when an OpenMethodStreamResponse message and a ping message is sent to the server then OpenMethodStreamResponse is ignored and the server only responds with a pong message.',
      () {
        var pongReceived = Completer<void>();
        var otherMessageReceived = Completer<void>();
        webSocket.textEvents.listen((event) {
          var message = WebSocketMessage.fromJsonString(
            event,
            server.serializationManager,
          );
          ;
          if (message is PongCommand) {
            pongReceived.complete();
          } else {
            otherMessageReceived.complete();
          }
        });

        webSocket.sendText(
          OpenMethodStreamResponse.buildMessage(
            endpoint: 'endpoint',
            method: 'method',
            responseType: OpenMethodStreamResponseType.success,
            connectionId: const Uuid().v4obj(),
          ),
        );
        webSocket.sendText(PingCommand.buildMessage());

        expect(
          otherMessageReceived.future,
          doesNotComplete,
          reason: 'OpenMethodStreamResponse not generate any messages.',
        );
        expect(
          pongReceived.future.timeout(Duration(seconds: 5)),
          completes,
          reason: 'Failed to receive pong message from server.',
        );
      },
    );
  });
}

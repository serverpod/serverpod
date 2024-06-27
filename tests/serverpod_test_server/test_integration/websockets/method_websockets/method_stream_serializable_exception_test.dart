import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group('Given method websocket connection', () {
    late Serverpod server;
    late WebSocketChannel webSocket;

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      await webSocket.ready;
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      await webSocket.sink.close();
    });

    test(
        'when an MethodStreamSerializableException message and a ping message is sent to the server then MethodStreamSerializableException is ignored and the server only responds with a pong message.',
        () {
      var pongReceived = Completer<void>();
      var otherMessageReceived = Completer<void>();
      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(event);
        if (message is PongCommand) {
          pongReceived.complete();
        } else {
          otherMessageReceived.complete();
        }
      });

      webSocket.sink.add(MethodStreamSerializableException.buildMessage(
        connectionId: const Uuid().v4obj(),
        endpoint: 'endpoint',
        method: 'method',
        object: server.serializationManager.encodeWithType(ExceptionWithData(
          message: 'message',
          creationDate: DateTime.now(),
          errorFields: ['field'],
        )),
      ));
      webSocket.sink.add(PingCommand.buildMessage());

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
    });
  });
}

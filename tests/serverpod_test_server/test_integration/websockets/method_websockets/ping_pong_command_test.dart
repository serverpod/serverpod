import 'dart:async';

import 'package:serverpod/serverpod.dart';
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

    test('when ping command is sent then pong response is received.', () async {
      webSocket.sink.add(PingCommand.buildMessage());

      var response = await webSocket.stream.first as String;
      var message = WebSocketMessage.fromJsonString(
        response,
        server.serializationManager,
      );

      expect(message, isA<PongCommand>());
    });

    test('when pong command is sent then no response is received.', () async {
      webSocket.sink.add(PongCommand.buildMessage());

      expectLater(
        webSocket.stream.first.timeout(Duration(seconds: 1)),
        throwsA(isA<TimeoutException>()),
      );
    });
  });
}

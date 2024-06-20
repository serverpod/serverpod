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

    test('when invalid command is sent no response is received.', () async {
      webSocket.sink.add('{"command":"this is not a valid command"}');

      expectLater(
        webSocket.stream.first.timeout(Duration(seconds: 1)),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('when invalid json string is sent then no response is received.',
        () async {
      webSocket.sink.add('this is not valid json');

      expectLater(
        webSocket.stream.first.timeout(Duration(seconds: 1)),
        throwsA(isA<TimeoutException>()),
      );
    });
  });
}

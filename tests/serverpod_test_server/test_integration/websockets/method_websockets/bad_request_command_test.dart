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

    test('when bad request is sent then connection is closed.', () async {
      var webSocketCompleter = Completer<void>();
      webSocket.stream.listen((event) {}, onDone: () {
        webSocketCompleter.complete();
      });

      webSocket.sink.add(BadRequestMessage.buildMessage('request'));

      expectLater(
        webSocketCompleter.future.timeout(Duration(seconds: 5)),
        completes,
      );
    });
  });
}

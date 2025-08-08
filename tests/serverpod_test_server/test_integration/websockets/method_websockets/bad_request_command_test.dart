import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';

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
      await webSocket.close();
    });

    test('when bad request is sent then connection is closed.', () async {
      var webSocketCompleter = Completer<void>();
      webSocket.textEvents.listen((event) {}, onDone: () {
        webSocketCompleter.complete();
      });

      webSocket.sendText(BadRequestMessage.buildMessage('request'));

      expectLater(
        webSocketCompleter.future.timeout(Duration(seconds: 5)),
        completes,
      );
    });
  });
}

extension on WebSocket {
  Stream<String> get textEvents => events
      .where((e) => e is TextDataReceived)
      .cast<TextDataReceived>()
      .map((e) => e.text);
}

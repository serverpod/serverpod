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
    var unrecognizedCommandMessage =
        '{"command":"this is not a valid command"}';

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
      'when an unrecognized message is sent then connection is closed.',
      () async {
        var webSocketCompleter = Completer<void>();
        webSocket.textEvents.listen(
          (event) {},
          onDone: () {
            webSocketCompleter.complete();
          },
        );

        webSocket.sendText(unrecognizedCommandMessage);

        expectLater(
          webSocketCompleter.future.timeout(Duration(seconds: 10)),
          completes,
        );
      },
    );

    test(
      'when an unrecognized message is sent then BadRequestMessage response is received.',
      () async {
        var response = webSocket.textEvents.first.timeout(
          Duration(seconds: 10),
        );
        webSocket.sendText(unrecognizedCommandMessage);

        expect(
          await response,
          BadRequestMessage.buildMessage(unrecognizedCommandMessage),
        );
      },
    );
  });
}

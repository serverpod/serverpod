@OnPlatform({
  'browser': Skip('WebSocket tests are not supported in browser'),
})
library;

import 'dart:async';

import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import 'websocket_extensions.dart';

import '../test_utils/test_web_socket_server.dart';

void main() async {
  group('Given echo websocket test server', () {
    Completer<Uri> callbackUrlFuture;
    late Uri webSocketHost;
    late Future<void> Function() closeServer;
    setUp(() async {
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          webSocket.events.listen((message) {
            switch (message) {
              case TextDataReceived():
                webSocket.sendText(message.text);
                break;
              case BinaryDataReceived():
                webSocket.sendBytes(message.data);
                break;
              case CloseReceived():
                break;
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

    test('when sending a message then expect same response', () async {
      var webSocket = await WebSocket.connect(webSocketHost);
      var message = 'Hello';
      webSocket.sendText(message);
      var response = await webSocket.textEvents.first;
      expect(response, message);
    });
  });

  group('Given sequence websocket test server with a single response', () {
    Completer<Uri> callbackUrlFuture;
    late Uri webSocketHost;
    late Future<void> Function() closeServer;
    List<String> sequence = ['World'];
    setUp(() async {
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          var messageIndex = 0;
          webSocket.events.listen((message) {
            if (messageIndex < sequence.length) {
              webSocket.sendText(sequence[messageIndex++]);
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
      'when sending single message then configured response is returned.',
      () async {
        var webSocket = await WebSocket.connect(webSocketHost);
        webSocket.sendText('Hello');
        var response = await webSocket.textEvents.first;
        expect(response, sequence.first);
      },
    );

    test(
      'when sending multiple messages then a single response is returned.',
      () async {
        var webSocket = await WebSocket.connect(webSocketHost);

        List<String> responses = [];
        webSocket.textEvents.listen((event) {
          responses.add(event);
        });

        webSocket.sendText('First Message');
        webSocket.sendText('Second Message');

        await Future.delayed(const Duration(milliseconds: 100));

        expect(responses, hasLength(1));
        expect(responses.first, sequence.first);
      },
    );
  });
}

@OnPlatform({
  'browser': Skip('WebSocket tests are not supported in browser'),
})
library;

import 'dart:async';

import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
          webSocket.listen((message) {
            webSocket.add(message);
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
      var webSocket = WebSocketChannel.connect(webSocketHost);
      await webSocket.ready;
      var message = 'Hello';
      webSocket.sink.add(message);
      var response = await webSocket.stream.first;
      expect(response, message);
    });
  });

  group('Given sequence websocket test server with single response', () {
    Completer<Uri> callbackUrlFuture;
    late Uri webSocketHost;
    late Future<void> Function() closeServer;
    List<String> sequence = ['World'];
    setUp(() async {
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          var messageIndex = 0;
          webSocket.listen((message) {
            if (messageIndex < sequence.length) {
              webSocket.add(sequence[messageIndex++]);
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

    test('when sending single message then configured response is returned.',
        () async {
      var webSocket = WebSocketChannel.connect(webSocketHost);
      await webSocket.ready;
      webSocket.sink.add('Hello');
      var response = await webSocket.stream.first;
      expect(response, sequence.first);
    });

    test('when sending multiple messages then single response is returned.',
        () async {
      var webSocket = WebSocketChannel.connect(webSocketHost);
      await webSocket.ready;

      List<String> responses = [];
      webSocket.stream.listen((event) {
        responses.add(event);
      });

      webSocket.sink.add('First Message');
      webSocket.sink.add('Second Message');

      await Future.delayed(const Duration(milliseconds: 100));

      expect(responses, hasLength(1));
      expect(responses.first, sequence.first);
    });
  });
}

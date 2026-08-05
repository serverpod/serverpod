@OnPlatform({
  'browser': Skip('WebSocket tests are not supported in browser'),
})
library;

import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import 'websocket_extensions.dart';
import '../test_utils/test_serverpod_client.dart';
import '../test_utils/test_web_socket_server.dart';

class TestSerializationManager extends SerializationManager {}

void main() {
  late TestServerpodClient client;
  late Future<void> Function() closeServer;
  late List<OpenMethodStreamCommand> receivedOpenCommands;
  late Completer<void> openCommandReceived;

  setUp(() async {
    receivedOpenCommands = [];
    openCommandReceived = Completer<void>();

    late Uri webSocketHost;
    closeServer = await TestWebSocketServer.startServer(
      webSocketHandler: (webSocket) {
        webSocket.textEvents.listen((event) {
          var message = WebSocketMessage.fromJsonString(
            event,
            TestSerializationManager(),
          );
          if (message is PingCommand) {
            webSocket.sendText(PongCommand.buildMessage());
          } else if (message is OpenMethodStreamCommand) {
            receivedOpenCommands.add(message);
            webSocket.sendText(
              OpenMethodStreamResponse.buildMessage(
                connectionId: message.connectionId,
                endpoint: message.endpoint,
                method: message.method,
                responseType: OpenMethodStreamResponseType.success,
              ),
            );
            openCommandReceived.complete();
          }
        });
      },
      onConnected: (host) => webSocketHost = host,
    );

    client = TestServerpodClient(
      host: webSocketHost.replace(scheme: 'http'),
      requestDelegate: _CookieCapableRequestDelegate(),
    );
  });

  tearDown(() async {
    client.close();
    await closeServer();
  });

  group('Given a cookie-auth client', () {
    setUp(() => client.cookieAuth = true);

    test(
      'when an authenticated streaming call is made '
      'then the open command declares the cookie auth mode.',
      () async {
        client.callStreamingServerEndpoint<Stream<String>, String>(
          'test',
          'method',
          {},
          {},
        );
        await openCommandReceived.future;

        expect(receivedOpenCommands.single.authMode, webAuthModeCookie);
      },
    );

    test(
      'when an unauthenticated streaming call is made '
      'then the open command declares no auth mode.',
      () async {
        client.callStreamingServerEndpoint<Stream<String>, String>(
          'test',
          'method',
          {},
          {},
          authenticated: false,
        );
        await openCommandReceived.future;

        expect(receivedOpenCommands.single.authMode, isNull);
      },
    );
  });

  test(
    'Given a client without cookie auth '
    'when an authenticated streaming call is made '
    'then the open command declares no auth mode.',
    () async {
      client.callStreamingServerEndpoint<Stream<String>, String>(
        'test',
        'method',
        {},
        {},
      );
      await openCommandReceived.future;

      expect(receivedOpenCommands.single.authMode, isNull);
    },
  );
}

class _CookieCapableRequestDelegate extends ServerpodClientRequestDelegate {
  @override
  bool get supportsCookieAuth => true;

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
    bool authenticated = true,
  }) {
    throw UnimplementedError();
  }

  @override
  void close() {}
}

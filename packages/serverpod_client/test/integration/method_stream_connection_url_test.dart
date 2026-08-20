@OnPlatform({
  'browser': Skip('WebSocket tests are not supported in browser'),
})
library;

import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import 'websocket_extensions.dart';
import '../test_utils/test_auth_key_providers.dart';
import '../test_utils/test_serverpod_client.dart';
import '../test_utils/test_web_socket_server.dart';

class TestSerializationManager extends SerializationManager {}

void main() {
  group('Given a client with an authenticated auth key provider', () {
    late TestServerpodClient client;
    late Future<void> Function() closeServer;
    late List<Uri> requestUrls;
    late List<OpenMethodStreamCommand> receivedOpenCommands;
    late Completer<void> openCommandReceived;

    setUp(() async {
      requestUrls = [];
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
        onRequest: requestUrls.add,
      );

      client = TestServerpodClient(
        host: webSocketHost.replace(scheme: 'http'),
        authKeyProvider: TestNonRefresherAuthKeyProvider(
          wrapAsBearerAuthHeaderValue('secret-token'),
        ),
      );
    });

    tearDown(() async {
      client.close();
      await closeServer();
    });

    group('when opening a method stream', () {
      setUp(() async {
        client.callStreamingServerEndpoint<Stream<String>, String>(
          'test',
          'method',
          {},
          {},
        );
        await openCommandReceived.future;
      });

      test('then the connection URL carries no credentials.', () {
        expect(requestUrls.single.queryParameters, isEmpty);
        expect(requestUrls.single.toString(), isNot(contains('secret-token')));
      });

      test(
        'then the authentication is carried in-band in the open command.',
        () {
          expect(
            receivedOpenCommands.single.authentication,
            wrapAsBearerAuthHeaderValue('secret-token'),
          );
        },
      );
    });
  });
}

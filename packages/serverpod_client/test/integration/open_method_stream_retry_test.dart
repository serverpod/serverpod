@OnPlatform({
  'browser': Skip('WebSocket tests are not supported in browser'),
})
library;

import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:test/test.dart';

import 'websocket_extensions.dart';
import '../test_utils/method_stream_connection_details_builder.dart';
import '../test_utils/test_auth_key_providers.dart';
import '../test_utils/test_web_socket_server.dart';

class TestSerializationManager extends SerializationManager {}

void main() {
  group(
    'Given a ClientMethodStreamManager with an authKeyProvider that does not support refresh',
    () {
      late ClientMethodStreamManager streamManager;
      late TestNonRefresherAuthKeyProvider authKeyProvider;
      late Uri webSocketHost;
      late Future<void> Function() closeServer;
      late List<String> receivedCmds;

      setUp(() async {
        receivedCmds = [];
        authKeyProvider = TestNonRefresherAuthKeyProvider('initial-token');

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
                receivedCmds.add(event);
                var response = OpenMethodStreamResponse.buildMessage(
                  connectionId: message.connectionId,
                  endpoint: message.endpoint,
                  method: message.method,
                  responseType:
                      OpenMethodStreamResponseType.authenticationFailed,
                );
                webSocket.sendText(response);
              }
            });
          },
          onConnected: (host) => webSocketHost = host,
        );

        streamManager = ClientMethodStreamManager(
          connectionTimeout: const Duration(seconds: 5),
          webSocketHost: webSocketHost,
          serializationManager: TestSerializationManager(),
        );
      });

      tearDown(() async => await closeServer());

      test(
        'when first open method stream connection fails with authenticationFailed '
        'then no retry is attempted.',
        () async {
          var connectionDetails = MethodStreamConnectionDetailsBuilder()
              .withAuthKeyProvider(authKeyProvider)
              .build();

          await expectLater(
            streamManager.openMethodStream(connectionDetails),
            throwsA(
              isA<OpenMethodStreamException>().having(
                (e) => e.responseType,
                'responseType',
                OpenMethodStreamResponseType.authenticationFailed,
              ),
            ),
          );

          expect(receivedCmds.length, 1);
          expect(authKeyProvider.authHeaderValueCallCount, 1);
        },
      );
    },
  );

  late TestRefresherAuthKeyProvider authKeyProvider;

  group(
    'Given a ClientMethodStreamManager with an authKeyProvider that supports refresh',
    () {
      late ClientMethodStreamManager streamManager;
      late Uri webSocketHost;
      late Future<void> Function() closeServer;
      late List<String> receivedCmds;
      late List<OpenMethodStreamResponseType> serverResponses;

      setUp(() async {
        receivedCmds = [];
        authKeyProvider = TestRefresherAuthKeyProvider();
        authKeyProvider.setAuthKey('initial-token');

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
                receivedCmds.add(event);

                if (receivedCmds.length > serverResponses.length) {
                  throw Exception('No more responses configured');
                }
                final responseType = serverResponses[receivedCmds.length - 1];

                var response = OpenMethodStreamResponse.buildMessage(
                  connectionId: message.connectionId,
                  endpoint: message.endpoint,
                  method: message.method,
                  responseType: responseType,
                );
                webSocket.sendText(response);
              }
            });
          },
          onConnected: (host) => webSocketHost = host,
        );

        streamManager = ClientMethodStreamManager(
          connectionTimeout: const Duration(seconds: 5),
          webSocketHost: webSocketHost,
          serializationManager: TestSerializationManager(),
        );
      });

      tearDown(() async => await closeServer());

      test('when first open method stream connection succeeds '
          'then no retry is attempted.', () async {
        serverResponses = [
          OpenMethodStreamResponseType.success,
        ];

        var connectionDetails = MethodStreamConnectionDetailsBuilder()
            .withAuthKeyProvider(authKeyProvider)
            .build();

        await streamManager.openMethodStream(connectionDetails);

        expect(receivedCmds.length, 1);
        expect(authKeyProvider.refreshCallCount, 0);
      });

      test(
        'when first open method stream connection fails with authenticationFailed and refresh succeeds '
        'then request is retried.',
        () async {
          serverResponses = [
            OpenMethodStreamResponseType.authenticationFailed,
            OpenMethodStreamResponseType.success,
          ];

          authKeyProvider.setRefresh(() {
            authKeyProvider.setAuthKey('refreshed-token');
            return RefreshAuthKeyResult.success;
          });

          var connectionDetails = MethodStreamConnectionDetailsBuilder()
              .withAuthKeyProvider(authKeyProvider)
              .build();

          await streamManager.openMethodStream(connectionDetails);

          expect(receivedCmds.length, 2);
          expect(authKeyProvider.refreshCallCount, 1);
          expect(receivedCmds[0], contains('initial-token'));
          expect(receivedCmds[1], contains('refreshed-token'));
        },
      );

      test(
        'when first open method stream connection fails with authenticationFailed but refresh fails '
        'then original exception is rethrown.',
        () async {
          serverResponses = [
            OpenMethodStreamResponseType.authenticationFailed,
          ];

          authKeyProvider.setRefresh(() => RefreshAuthKeyResult.failedOther);

          var connectionDetails = MethodStreamConnectionDetailsBuilder()
              .withAuthKeyProvider(authKeyProvider)
              .build();

          await expectLater(
            streamManager.openMethodStream(connectionDetails),
            throwsA(
              isA<OpenMethodStreamException>().having(
                (e) => e.responseType,
                'responseType',
                OpenMethodStreamResponseType.authenticationFailed,
              ),
            ),
          );

          expect(receivedCmds.length, 1);
          expect(authKeyProvider.refreshCallCount, 1);
        },
      );

      test(
        'when first open method stream connection fails with authenticationFailed, refresh succeeds and second open method stream connection also fails with authenticationFailed '
        'then no second retry is attempted and original exception is rethrown.',
        () async {
          serverResponses = [
            OpenMethodStreamResponseType.authenticationFailed,
            OpenMethodStreamResponseType.authenticationFailed,
          ];

          authKeyProvider.setRefresh(() {
            authKeyProvider.setAuthKey('refreshed-token');
            return RefreshAuthKeyResult.success;
          });

          var connectionDetails = MethodStreamConnectionDetailsBuilder()
              .withAuthKeyProvider(authKeyProvider)
              .build();

          await expectLater(
            streamManager.openMethodStream(connectionDetails),
            throwsA(
              isA<OpenMethodStreamException>().having(
                (e) => e.responseType,
                'responseType',
                OpenMethodStreamResponseType.authenticationFailed,
              ),
            ),
          );

          expect(receivedCmds.length, 2);
          expect(authKeyProvider.refreshCallCount, 1);
          expect(receivedCmds[0], contains('initial-token'));
          expect(receivedCmds[1], contains('refreshed-token'));
        },
      );

      test(
        'when first open method stream connection fails with non-authenticationFailed error '
        'then no retry is attempted.',
        () async {
          serverResponses = [
            OpenMethodStreamResponseType.endpointNotFound,
          ];

          var connectionDetails = MethodStreamConnectionDetailsBuilder()
              .withAuthKeyProvider(authKeyProvider)
              .build();

          await expectLater(
            streamManager.openMethodStream(connectionDetails),
            throwsA(
              isA<OpenMethodStreamException>().having(
                (e) => e.responseType,
                'responseType',
                OpenMethodStreamResponseType.endpointNotFound,
              ),
            ),
          );

          expect(receivedCmds.length, 1);
          expect(authKeyProvider.refreshCallCount, 0);
        },
      );
    },
  );
}

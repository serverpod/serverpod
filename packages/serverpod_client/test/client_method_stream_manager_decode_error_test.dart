@OnPlatform({
  'browser': Skip('WebSocket tests are not supported in browser'),
})
library;

import 'dart:async';

import 'package:relic/relic.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:test/test.dart';

import 'integration/websocket_extensions.dart';
import 'test_utils/method_stream_connection_details_builder.dart';
import 'test_utils/test_web_socket_server.dart';

class TestSerializationManager extends SerializationManager {}

void main() {
  group(
    'Given two open method streams on one connection and a message whose payload cannot be decoded,',
    () {
      late Completer<Uri> callbackUrlFuture;
      late Uri webSocketHost;
      late Future<void> Function() closeServer;
      RelicWebSocket? serverWebSocket;
      var pingCommandsReceived = 0;
      final connectionIds = <String, UuidValue>{};
      late StreamController<String> streamAOutput;
      late StreamController<String> streamBOutput;

      setUp(() async {
        serverWebSocket = null;
        pingCommandsReceived = 0;
        connectionIds.clear();
        streamAOutput = StreamController<String>();
        streamBOutput = StreamController<String>();
        callbackUrlFuture = Completer<Uri>();
        closeServer = await TestWebSocketServer.startServer(
          webSocketHandler: (webSocket) {
            serverWebSocket = webSocket;
            webSocket.textEvents.listen((event) {
              var message = WebSocketMessage.fromJsonString(
                event,
                TestSerializationManager(),
              );
              switch (message) {
                case PingCommand():
                  pingCommandsReceived++;
                  webSocket.sendText(PongCommand.buildMessage());
                case OpenMethodStreamCommand():
                  connectionIds[message.endpoint] = message.connectionId;
                  webSocket.sendText(
                    OpenMethodStreamResponse.buildMessage(
                      endpoint: message.endpoint,
                      method: message.method,
                      connectionId: message.connectionId,
                      responseType: OpenMethodStreamResponseType.success,
                    ),
                  );
                default:
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

      tearDown(() async {
        await closeServer();
        await streamAOutput.close();
        await streamBOutput.close();
      });

      test(
        'when the undecodable message targets stream A '
        'then only stream A errors while the connection stays alive.',
        () async {
          var streamManager = ClientMethodStreamManager(
            connectionTimeout: const Duration(seconds: 5),
            pingInterval: const Duration(milliseconds: 100),
            webSocketHost: webSocketHost,
            serializationManager: TestSerializationManager(),
          );

          var errorsA = <Object>[];
          streamAOutput.stream.listen((_) {}, onError: errorsA.add);
          var errorsB = <Object>[];
          streamBOutput.stream.listen((_) {}, onError: errorsB.add);

          await streamManager.openMethodStream(
            MethodStreamConnectionDetailsBuilder()
                .withEndpoint('EndpointA')
                .withMethod('methodA')
                .withOutputController(streamAOutput)
                .build(),
          );
          await streamManager.openMethodStream(
            MethodStreamConnectionDetailsBuilder()
                .withEndpoint('EndpointB')
                .withMethod('methodB')
                .withOutputController(streamBOutput)
                .build(),
          );

          var pingsBeforeDecodeError = pingCommandsReceived;
          expect(pingsBeforeDecodeError, greaterThan(0));

          // Send a message with an unknown class to stream A. The envelope is
          // valid, but the payload cannot be decoded by the client.
          var encodedMessage = MethodStreamMessage.buildMessage(
            endpoint: 'EndpointA',
            method: 'methodA',
            connectionId: connectionIds['EndpointA']!,
            object: 'payload',
            serializationManager: TestSerializationManager(),
          );
          serverWebSocket!.sendText(
            encodedMessage.replaceAll('"String"', '"_UnknownClass"'),
          );

          await Future<void>.delayed(const Duration(milliseconds: 300));

          expect(errorsA, hasLength(1));
          expect(errorsA.first, isA<MethodStreamMessageDecodingException>());
          expect(errorsB, isEmpty);

          // The keep-alive pings still arrive on the same socket, proving the
          // connection was not torn down by the decode error.
          expect(pingCommandsReceived, greaterThan(pingsBeforeDecodeError));
        },
      );
    },
  );
}

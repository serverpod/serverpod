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

    group('with a connected method stream has a delayed response', () {
      late Completer<void> webSocketCompleter;
      late Completer<void> delayedResponseClosed;

      var endpoint = 'methodStreaming';
      var method = 'delayedStreamResponse';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        var delayedResponseOpen = Completer<void>();
        delayedResponseClosed = Completer<void>();
        webSocketCompleter = Completer<void>();

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            if (message.connectionId == connectionId)
              delayedResponseOpen.complete();
          } else if (message is CloseMethodStreamCommand) {
            if (message.connectionId == connectionId)
              delayedResponseClosed.complete();
          }
        }, onDone: () {
          webSocketCompleter.complete();
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {'delay': 10},
          connectionId: connectionId,
        ));

        await delayedResponseOpen.future.timeout(
          Duration(seconds: 5),
          onTimeout: () => throw AssertionError(
            'Failed to open method stream with server.',
          ),
        );
      });

      tearDown(() async {
        var tempSession = await server.createSession();

        /// Close any open delayed response streams.
        await (server.endpoints
                    .getConnectorByName(endpoint)
                    ?.methodConnectors['completeAllDelayedResponses']
                as MethodConnector?)
            ?.call(tempSession, {});

        await tempSession.close();
      });

      test(
          'when stream is closed by a CloseMethodStreamCommand then websocket connection is closed.',
          () async {
        webSocket.sink.add(CloseMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          connectionId: connectionId,
          reason: CloseReason.done,
        ));

        await expectLater(
          webSocketCompleter.future.timeout(Duration(seconds: 5)),
          completes,
          reason:
              'Websocket connection was not closed when only stream was closed.',
        );
      });
    });
  });
}

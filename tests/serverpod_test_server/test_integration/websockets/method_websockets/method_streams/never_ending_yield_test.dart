import 'dart:async';

import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group(
      'Given a method stream connection to an endpoint that continuously yields values with a small delay',
      () {
    var endpoint = 'methodStreaming';
    var method = 'neverEndingStreamWithDelay';

    late Serverpod server;
    late WebSocketChannel webSocket;
    late Completer webSocketClosed;
    TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

    var connectionId = const Uuid().v4obj();

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      await webSocket.ready;
      webSocketClosed = Completer();
      var streamOpened = Completer<void>();

      testCompleterTimeout.start({
        'streamOpened': streamOpened,
        'webSocketClosed': webSocketClosed,
      });

      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(
          event,
          server.serializationManager,
        );
        ;
        if (message is OpenMethodStreamResponse) {
          streamOpened.complete();
        }
      }, onDone: () {
        webSocketClosed.complete();
      });

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        args: {'millisecondsDelay': 100},
        connectionId: connectionId,
        inputStreams: [],
      ));

      await streamOpened.future;
      assert(streamOpened.isCompleted == true,
          'Failed to open method stream with server');
    });

    tearDown(() async {
      testCompleterTimeout.cancel();
      await server.shutdown(exitProcess: false);
      await webSocket.sink.close();
    });

    test('when method stream is closed then websocket connection is closed.',
        () async {
      webSocket.sink.add(CloseMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        connectionId: connectionId,
        reason: CloseReason.done,
      ));

      webSocketClosed.future.catchError((error) {
        fail('Failed to close websocket connection.');
      });

      await expectLater(webSocketClosed.future, completes);
    });
  });
}

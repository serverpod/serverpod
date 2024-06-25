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

    group('when a stream is opened to an endpoint that has void return value',
        () {
      late Completer<MethodStreamMessage> endpointResponse;
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;

      var endpoint = 'methodStreaming';
      var method = 'simpleEndpoint';
      var uuid = Uuid().v4();

      setUp(() {
        endpointResponse = Completer<MethodStreamMessage>();
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        var streamOpened = Completer<void>();
        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            closeMethodStreamCommand.complete(message);
          } else if (message is MethodStreamMessage) {
            endpointResponse.complete(message);
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
          uuid: uuid,
        ));

        expect(
          streamOpened.future.timeout(Duration(seconds: 5)),
          completes,
          reason: 'Failed to open method stream with server.',
        );
      });

      test(
          'then no message is received other than a CloseMethodStreamCommand with done reason.',
          () async {
        var message =
            closeMethodStreamCommand.future.timeout(Duration(seconds: 5));
        expect(
          message,
          completes,
          reason: 'Failed to receive CloseMethodStreamCommand from server.',
        );

        var closeMethodStreamCommandMessage = await message;
        expect(closeMethodStreamCommandMessage.endpoint, endpoint);
        expect(closeMethodStreamCommandMessage.method, method);
        expect(closeMethodStreamCommandMessage.uuid, uuid);
        expect(closeMethodStreamCommandMessage.reason, CloseReason.done);
        expect(endpointResponse.future, doesNotComplete);
      });
    });
  });
}

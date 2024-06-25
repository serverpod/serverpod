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

    test(
        'when a MethodStreamMessage and a ping message is sent to the server then MethodStreamMessage is ignored and the server only responds with a pong message.',
        () {
      var pongReceived = Completer<void>();
      var otherMessageReceived = Completer<void>();
      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(event);
        if (message is PongCommand) {
          pongReceived.complete();
        } else {
          otherMessageReceived.complete();
        }
      });

      webSocket.sink.add(MethodStreamMessage.buildMessage(
        endpoint: 'methodStreaming',
        method: 'doubleInputValue',
        uuid: 'uuid',
        object: server.serializationManager.encodeWithType(1),
      ));
      webSocket.sink.add(PingCommand.buildMessage());

      expect(
        otherMessageReceived.future,
        doesNotComplete,
        reason: 'OpenMethodStreamResponse not generate any messages.',
      );
      expect(
        pongReceived.future.timeout(Duration(seconds: 5)),
        completes,
        reason: 'Failed to receive pong message from server.',
      );
    });

    group(
        'when a stream is opened to an endpoint that returns a value based on the input ',
        () {
      late Completer<int> endpointResponse;
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      var inputValue = 2;

      var endpoint = 'methodStreaming';
      var method = 'doubleInputValue';
      var uuid = Uuid().v4();

      setUp(() {
        endpointResponse = Completer<int>();
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        var streamOpened = Completer<void>();
        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            closeMethodStreamCommand.complete(message);
          } else if (message is MethodStreamMessage) {
            endpointResponse.complete(server.serializationManager
                .decodeWithType(message.object) as int);
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {'value': inputValue},
          uuid: uuid,
        ));

        expect(
          streamOpened.future.timeout(Duration(seconds: 5)),
          completes,
          reason: 'Failed to open method stream with server.',
        );
      });

      test('then MethodStreamMessage with modified input is received.', () {
        expect(
          endpointResponse.future.timeout(Duration(seconds: 5)),
          completion(inputValue * 2),
          reason: 'Return value from endpoint.',
        );
      });

      test('then CloseMethodStreamCommand matching the endpoint is received.',
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
      });
    });
  });
}

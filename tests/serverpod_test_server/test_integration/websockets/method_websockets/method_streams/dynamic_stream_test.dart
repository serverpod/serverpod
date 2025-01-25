import 'dart:async';

import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group(
      'Given a method stream connection to an endpoint that echoes a dynamic input stream',
      () {
    var endpoint = 'methodStreaming';
    var method = 'dynamicEchoStream';

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

    group('when a stream of values are passed in', () {
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();
      var inputValues = [1, 'hello'];
      late List<dynamic> endpointResponses;

      var inputParameter = 'stream';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        endpointResponses = [];
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        var streamOpened = Completer<void>();

        testCompleterTimeout.start({
          'closeMethodStreamCommand': closeMethodStreamCommand,
          'streamOpened': streamOpened,
        });

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(
            event,
            server.serviceLocator.locate<SerializationManager>()!,
          );
          ;
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            closeMethodStreamCommand.complete(message);
          } else if (message is MethodStreamMessage) {
            if (endpointResponses.isEmpty) {
              endpointResponses.add(message.object as int);
            } else {
              endpointResponses.add(message.object as String);
            }
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
          connectionId: connectionId,
          inputStreams: [inputParameter],
        ));

        await streamOpened.future;
        assert(streamOpened.isCompleted == true,
            'Failed to open method stream with server');

        for (var inputValue in inputValues)
          webSocket.sink.add(MethodStreamMessage.buildMessage(
            endpoint: endpoint,
            method: method,
            parameter: inputParameter,
            connectionId: connectionId,
            object: inputValue,
            serializationManager:
                server.serviceLocator.locate<SerializationManager>()!,
          ));

        webSocket.sink.add(CloseMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          parameter: inputParameter,
          connectionId: connectionId,
          reason: CloseReason.done,
        ));
      });

      tearDown(() => testCompleterTimeout.cancel());

      test('then received values matches stream of input.', () async {
        closeMethodStreamCommand.future.catchError((error) {
          fail('Server failed to close the output stream.');
        });

        await expectLater(closeMethodStreamCommand.future, completes);

        expect(
          endpointResponses,
          inputValues,
        );
      });

      test('then CloseMethodStreamCommand matching the endpoint is received.',
          () async {
        closeMethodStreamCommand.future.catchError((error) {
          fail('Failed to receive CloseMethodStreamCommand from server.');
        }).then((message) {
          expect(message.endpoint, endpoint);
          expect(message.method, method);
          expect(message.connectionId, connectionId);
          expect(message.reason, CloseReason.done);
        });

        await expectLater(closeMethodStreamCommand.future, completes);
      });
    });
  });
}

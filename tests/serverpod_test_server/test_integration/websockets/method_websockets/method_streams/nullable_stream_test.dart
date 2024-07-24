import 'dart:async';

import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group(
      'Given a method stream connection to an endpoint that echoes a input stream with nullable generic',
      () {
    var endpoint = 'methodStreaming';
    var method = 'nullableIntEchoStream';

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
      late Completer<CloseMethodStreamCommand>
          closeMethodStreamParameterCommand;
      TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();
      var inputValues = [1, null, 3];
      late List<int?> endpointResponses;

      var inputParameter = 'stream';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        endpointResponses = [];
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        closeMethodStreamParameterCommand =
            Completer<CloseMethodStreamCommand>();
        var streamOpened = Completer<void>();

        testCompleterTimeout.start({
          'closeMethodStreamCommand': closeMethodStreamCommand,
          'closeMethodStreamParameterCommand':
              closeMethodStreamParameterCommand,
          'streamOpened': streamOpened,
        });

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(
            event,
            server.serializationManager,
          );
          ;
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            if (message.parameter == inputParameter) {
              closeMethodStreamParameterCommand.complete(message);
            } else {
              closeMethodStreamCommand.complete(message);
            }
          } else if (message is MethodStreamMessage) {
            endpointResponses.add(message.object as int?);
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
            serializationManager: server.serializationManager,
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

      test(
          'then CloseMethodStreamCommand matching the stream parameter is received.',
          () async {
        closeMethodStreamParameterCommand.future.catchError((error) {
          fail(
              'Failed to receive CloseMethodStreamCommand from server for input parameter.');
        }).then((message) {
          expect(message.endpoint, endpoint);
          expect(message.method, method);
          expect(message.parameter, inputParameter);
          expect(message.connectionId, connectionId);
          expect(message.reason, CloseReason.done);
        });

        await expectLater(
          closeMethodStreamParameterCommand.future,
          completes,
        );
      });
    });
  });
}

import 'dart:async';

import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group(
      'Given a method stream connection to an endpoint that echoes multiple input streams',
      () {
    var endpoint = 'methodStreaming';
    var method = 'multipleIntEchoStreams';

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

    group('when values are passed to both streams', () {
      late Completer<void> allResponsesReceived;
      late List<int> endpointResponses;
      TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();
      var inputValuesStream1 = [1, 2, 3, 4];
      var inputValuesStream2 = [1, 2, 3, 4];

      var inputStreamParameter1 = 'stream1';
      var inputStreamParameter2 = 'stream2';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        allResponsesReceived = Completer<void>();
        endpointResponses = [];
        var streamOpened = Completer<void>();

        testCompleterTimeout.start({
          'endpointResponse': allResponsesReceived,
          'streamOpened': streamOpened,
        });

        var responsesReceived = 0;
        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is MethodStreamMessage) {
            endpointResponses.add(server.serializationManager
                .decodeWithType(message.object) as int);

            if (++responsesReceived ==
                inputValuesStream1.length + inputValuesStream2.length) {
              allResponsesReceived.complete();
            }
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
          connectionId: connectionId,
        ));

        await streamOpened.future;
        assert(streamOpened.isCompleted == true,
            'Failed to open method stream with server');

        for (var value in inputValuesStream1) {
          webSocket.sink.add(MethodStreamMessage.buildMessage(
            endpoint: endpoint,
            method: method,
            parameter: inputStreamParameter1,
            connectionId: connectionId,
            object: server.serializationManager.encodeWithType(value),
          ));
        }

        for (var value in inputValuesStream2) {
          webSocket.sink.add(MethodStreamMessage.buildMessage(
            endpoint: endpoint,
            method: method,
            parameter: inputStreamParameter2,
            connectionId: connectionId,
            object: server.serializationManager.encodeWithType(value),
          ));
        }
      });

      tearDown(() => testCompleterTimeout.cancel());

      test('then received values are the combination of both streams.',
          () async {
        allResponsesReceived.future.catchError((error) {
          fail('Failed to all expected responses from the server.');
        }).then((value) => {
              expect(
                endpointResponses,
                containsAll([
                  ...inputValuesStream1,
                  ...inputValuesStream2,
                ]),
              )
            });

        await expectLater(
          allResponsesReceived.future,
          completes,
          reason: 'Invalid return value from endpoint.',
        );
      });
    });

    group('when one stream parameter is closed', () {
      late Completer<int> endpointResponse;
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      late Completer<CloseMethodStreamCommand>
          closeMethodStreamParameterCommand;
      TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();
      var inputValue = 2;

      var closedStreamParameter = 'stream1';
      var openStreamParameter = 'stream2';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        endpointResponse = Completer<int>();
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        closeMethodStreamParameterCommand =
            Completer<CloseMethodStreamCommand>();
        var streamOpened = Completer<void>();

        testCompleterTimeout.start({
          'endpointResponse': endpointResponse,
          'closeMethodStreamCommand': closeMethodStreamCommand,
          'closeMethodStreamParameterCommand':
              closeMethodStreamParameterCommand,
          'streamOpened': streamOpened,
        });

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand &&
              message.parameter == closedStreamParameter) {
            closeMethodStreamParameterCommand.complete(message);
          } else if (message is MethodStreamMessage) {
            endpointResponse.complete(server.serializationManager
                .decodeWithType(message.object) as int);
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
          connectionId: connectionId,
        ));

        await streamOpened.future;
        assert(streamOpened.isCompleted == true,
            'Failed to open method stream with server');

        webSocket.sink.add(CloseMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          parameter: closedStreamParameter,
          connectionId: connectionId,
          reason: CloseReason.done,
        ));
      });

      tearDown(() => testCompleterTimeout.cancel());

      test(
          'then CloseMethodStreamCommand matching the closed stream parameter is received.',
          () async {
        closeMethodStreamParameterCommand.future.catchError((error) {
          fail(
              'Failed to receive CloseMethodStreamCommand from server for input parameter.');
        }).then((message) {
          expect(message.endpoint, endpoint);
          expect(message.method, method);
          expect(message.parameter, closedStreamParameter);
          expect(message.connectionId, connectionId);
          expect(message.reason, CloseReason.done);
        });

        await expectLater(
          closeMethodStreamParameterCommand.future,
          completes,
        );
      });

      test('then values are still echoed on other parameter.', () async {
        endpointResponse.future.catchError((error) {
          fail('Failed to receive response from server.');
        });

        webSocket.sink.add(MethodStreamMessage.buildMessage(
          endpoint: endpoint,
          method: method,
          parameter: openStreamParameter,
          connectionId: connectionId,
          object: server.serializationManager.encodeWithType(inputValue),
        ));

        await expectLater(
          endpointResponse.future,
          completion(inputValue),
          reason: 'Invalid return value from endpoint.',
        );
      });
    });

    group('when both streams are closed', () {
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      late Completer<CloseMethodStreamCommand>
          closeMethodStreamParameter1Command;
      late Completer<CloseMethodStreamCommand>
          closeMethodStreamParameter2Command;
      TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

      var inputStreamParameter1 = 'stream1';
      var inputStreamParameter2 = 'stream2';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        closeMethodStreamParameter1Command =
            Completer<CloseMethodStreamCommand>();
        closeMethodStreamParameter2Command =
            Completer<CloseMethodStreamCommand>();
        var streamOpened = Completer<void>();

        testCompleterTimeout.start({
          'closeMethodStreamCommand': closeMethodStreamCommand,
          'closeMethodStreamParameter1Command':
              closeMethodStreamParameter1Command,
          'closeMethodStreamParameter2Command':
              closeMethodStreamParameter2Command,
          'streamOpened': streamOpened,
        });

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            if (message.parameter == null) {
              closeMethodStreamCommand.complete(message);
            } else if (message.parameter == inputStreamParameter1) {
              closeMethodStreamParameter1Command.complete(message);
            } else if (message.parameter == inputStreamParameter2) {
              closeMethodStreamParameter2Command.complete(message);
            }
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
          connectionId: connectionId,
        ));

        await streamOpened.future;
        assert(streamOpened.isCompleted == true,
            'Failed to open method stream with server');

        webSocket.sink.add(CloseMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          parameter: inputStreamParameter1,
          connectionId: connectionId,
          reason: CloseReason.done,
        ));

        webSocket.sink.add(CloseMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          parameter: inputStreamParameter2,
          connectionId: connectionId,
          reason: CloseReason.done,
        ));
      });

      tearDown(() => testCompleterTimeout.cancel());

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
          'then CloseMethodStreamCommand matching the first stream parameter is received.',
          () async {
        closeMethodStreamParameter1Command.future.catchError((error) {
          fail(
              'Failed to receive CloseMethodStreamCommand from server for first input parameter.');
        }).then((message) {
          expect(message.endpoint, endpoint);
          expect(message.method, method);
          expect(message.parameter, inputStreamParameter1);
          expect(message.connectionId, connectionId);
          expect(message.reason, CloseReason.done);
        });

        await expectLater(
          closeMethodStreamParameter1Command.future,
          completes,
        );
      });

      test(
          'then CloseMethodStreamCommand matching the second stream parameter is received.',
          () async {
        closeMethodStreamParameter2Command.future.catchError((error) {
          fail(
              'Failed to receive CloseMethodStreamCommand from server for second input parameter.');
        }).then((message) {
          expect(message.endpoint, endpoint);
          expect(message.method, method);
          expect(message.parameter, inputStreamParameter2);
          expect(message.connectionId, connectionId);
          expect(message.reason, CloseReason.done);
        });

        await expectLater(
          closeMethodStreamParameter2Command.future,
          completes,
        );
      });
    });
  });
}

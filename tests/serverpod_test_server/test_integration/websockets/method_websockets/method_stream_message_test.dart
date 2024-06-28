import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
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
        'when a MethodStreamMessage is sent to the server without an open stream then response is a CloseMethodStreamCommand with error reason.',
        () async {
      var closeMethodCommand = Completer<CloseMethodStreamCommand>();
      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(event);
        if (message is CloseMethodStreamCommand) {
          closeMethodCommand.complete(message);
        }
      });

      webSocket.sink.add(MethodStreamMessage.buildMessage(
        endpoint: 'methodStreaming',
        method: 'simpleStream',
        connectionId: const Uuid().v4obj(),
        object: server.serializationManager.encodeWithType(1),
      ));
      webSocket.sink.add(PingCommand.buildMessage());

      await expectLater(
        closeMethodCommand.future.timeout(Duration(seconds: 5)),
        completes,
        reason: 'Failed to receive close method command message from server.',
      );

      var closeMethodStreamCommand = await closeMethodCommand.future;
      expect(closeMethodStreamCommand.reason, CloseReason.error);
    });

    group(
        'when a stream is opened to an endpoint that returns a Future with a value based on the input ',
        () {
      late Completer<int> endpointResponse;
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      late Completer<void> webSocketCompleter;
      var inputValue = 2;

      var endpoint = 'methodStreaming';
      var method = 'doubleInputValue';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        endpointResponse = Completer<int>();
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        webSocketCompleter = Completer<void>();
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
        }, onDone: () {
          webSocketCompleter.complete();
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {'value': inputValue},
          connectionId: connectionId,
        ));

        await streamOpened.future.timeout(
          Duration(seconds: 5),
          onTimeout: () => throw AssertionError(
            'Failed to open method stream with server.',
          ),
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
        expect(closeMethodStreamCommandMessage.connectionId, connectionId);
        expect(closeMethodStreamCommandMessage.reason, CloseReason.done);
      });

      test('then the stream is closed.', () async {
        expect(
          webSocketCompleter.future.timeout(Duration(seconds: 5)),
          completes,
        );
      });
    });

    group(
        'when a stream is opened to an endpoint that returns a stream of numbers counting to the input value starting from 0',
        () {
      late List<int> endpointResponses;
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      late Completer<void> webSocketCompleter;
      var inputValue = 4;

      var endpoint = 'methodStreaming';
      var method = 'simpleStreamWithParameter';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        endpointResponses = [];
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        webSocketCompleter = Completer<void>();
        var streamOpened = Completer<void>();

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            closeMethodStreamCommand.complete(message);
          } else if (message is MethodStreamMessage) {
            endpointResponses.add(server.serializationManager
                .decodeWithType(message.object) as int);
          }
        }, onDone: () {
          webSocketCompleter.complete();
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {'value': inputValue},
          connectionId: connectionId,
        ));

        await streamOpened.future.timeout(
          Duration(seconds: 5),
          onTimeout: () => throw AssertionError(
            'Failed to open method stream with server.',
          ),
        );
      });

      test(
          'then once method stream is closed the received MethodStreamMessages matches input specification.',
          () async {
        await expectLater(
          closeMethodStreamCommand.future.timeout(Duration(seconds: 5)),
          completes,
          reason: 'Failed to receive CloseMethodStreamCommand from server.',
        );

        expect(
          endpointResponses,
          List.generate(inputValue, (index) => index),
          reason: 'Failed to receive all responses from endpoint.',
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
        expect(closeMethodStreamCommandMessage.connectionId, connectionId);
        expect(closeMethodStreamCommandMessage.reason, CloseReason.done);
      });

      test('then the stream is closed.', () async {
        expect(
          webSocketCompleter.future.timeout(Duration(seconds: 5)),
          completes,
        );
      });
    });

    group(
        'when a stream is opened to an endpoint that returns a stream of SimpleData objects with numbers counting to the input value starting from 0',
        () {
      late List<SimpleData> endpointResponses;
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      late Completer<void> webSocketCompleter;
      var inputValue = 4;

      var endpoint = 'methodStreaming';
      var method = 'simpleDataStream';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        endpointResponses = [];
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        webSocketCompleter = Completer<void>();
        var streamOpened = Completer<void>();

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            closeMethodStreamCommand.complete(message);
          } else if (message is MethodStreamMessage) {
            endpointResponses.add(server.serializationManager
                .decodeWithType(message.object) as SimpleData);
          }
        }, onDone: () {
          webSocketCompleter.complete();
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {'value': inputValue},
          connectionId: connectionId,
        ));

        await streamOpened.future.timeout(
          Duration(seconds: 5),
          onTimeout: () => throw AssertionError(
            'Failed to open method stream with server.',
          ),
        );
      });

      test(
          'then once method stream is closed the received MethodStreamMessages matches input specification.',
          () async {
        await expectLater(
          closeMethodStreamCommand.future.timeout(Duration(seconds: 5)),
          completes,
          reason: 'Failed to receive CloseMethodStreamCommand from server.',
        );

        expect(
          endpointResponses.map((simpleData) => simpleData.num).toList(),
          List.generate(inputValue, (index) => index),
          reason: 'Failed to receive all responses from endpoint.',
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
        expect(closeMethodStreamCommandMessage.connectionId, connectionId);
        expect(closeMethodStreamCommandMessage.reason, CloseReason.done);
      });

      test('then the stream is closed.', () async {
        expect(
          webSocketCompleter.future.timeout(Duration(seconds: 5)),
          completes,
        );
      });
    });

    group(
        'when a method stream is opened to an endpoint that has null return value then null MethodStreamMessage is received with null value',
        () {
      late Completer<int?> endpointResponse;

      setUp(() async {
        var connectionId = const Uuid().v4obj();
        endpointResponse = Completer<int?>();
        var streamOpened = Completer<void>();

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is MethodStreamMessage) {
            endpointResponse.complete(server.serializationManager
                .decodeWithType(message.object) as int?);
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: 'methodStreaming',
          method: 'nullableResponse',
          args: {'value': null},
          connectionId: connectionId,
        ));

        await streamOpened.future.timeout(
          Duration(seconds: 5),
          onTimeout: () => throw AssertionError(
            'Failed to open method stream with server.',
          ),
        );
      });

      test('then MethodStreamMessage with modified input is received.',
          () async {
        await expectLater(
          endpointResponse.future.timeout(Duration(seconds: 5)),
          completion(null),
          reason: 'Return value from endpoint.',
        );
      });
    },
        skip:
            'Enable this test once serialize and deserialize by class name supports null types.');

    group(
        'when multiple methods streams are open and one of them with Future response is closed',
        () {
      late Completer<void> returningStreamClosed;
      late Completer<void> webSocketCompleter;
      late Completer<void> delayedResponseClosed;
      var endpoint = 'methodStreaming';

      setUp(() async {
        var returningStreamOpen = Completer<void>();
        var delayedResponseOpen = Completer<void>();
        returningStreamClosed = Completer<void>();
        delayedResponseClosed = Completer<void>();
        webSocketCompleter = Completer<void>();
        var returningStreamConnectionId = const Uuid().v4obj();
        var delayedResponseConnectionId = const Uuid().v4obj();

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            if (message.connectionId == returningStreamConnectionId)
              returningStreamOpen.complete();
            else if (message.connectionId == delayedResponseConnectionId)
              delayedResponseOpen.complete();
          } else if (message is CloseMethodStreamCommand) {
            if (message.connectionId == returningStreamConnectionId)
              returningStreamClosed.complete();
            if (message.connectionId == delayedResponseConnectionId)
              delayedResponseClosed.complete();
          }
        }, onDone: () {
          webSocketCompleter.complete();
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: 'delayedStreamResponse',
          args: {'delay': 10},
          connectionId: delayedResponseConnectionId,
        ));

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: 'simpleEndpoint',
          args: {},
          connectionId: returningStreamConnectionId,
        ));

        await Future.wait([
          returningStreamOpen.future,
          delayedResponseOpen.future,
        ]).timeout(
          Duration(seconds: 5),
          onTimeout: () => throw AssertionError(
            'Failed to open all method stream with server.',
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

      test('then websocket connection stays open.', () async {
        await returningStreamClosed.future.timeout(Duration(seconds: 5));

        // Monitor websocket connection for 1 second to make sure it stays open.
        expectLater(
          webSocketCompleter.future.timeout(Duration(seconds: 1)),
          throwsA(isA<TimeoutException>()),
        );
      });
    });

    group(
        'when multiple methods streams are open and one of them with Stream response is closed',
        () {
      late Completer<void> returningStreamClosed;
      late Completer<void> webSocketCompleter;
      late Completer<void> delayedResponseClosed;
      var endpoint = 'methodStreaming';

      setUp(() async {
        var returningStreamOpen = Completer<void>();
        var delayedResponseOpen = Completer<void>();
        returningStreamClosed = Completer<void>();
        delayedResponseClosed = Completer<void>();
        webSocketCompleter = Completer<void>();
        var returningStreamConnectionId = const Uuid().v4obj();
        var delayedResponseConnectionId = const Uuid().v4obj();

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            if (message.connectionId == returningStreamConnectionId)
              returningStreamOpen.complete();
            else if (message.connectionId == delayedResponseConnectionId)
              delayedResponseOpen.complete();
          } else if (message is CloseMethodStreamCommand) {
            if (message.connectionId == returningStreamConnectionId)
              returningStreamClosed.complete();
            if (message.connectionId == delayedResponseConnectionId)
              delayedResponseClosed.complete();
          }
        }, onDone: () {
          webSocketCompleter.complete();
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: 'delayedStreamResponse',
          args: {'delay': 10},
          connectionId: delayedResponseConnectionId,
        ));

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: 'simpleStream',
          args: {},
          connectionId: returningStreamConnectionId,
        ));

        await Future.wait([
          returningStreamOpen.future,
          delayedResponseOpen.future,
        ]).timeout(
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

      test('then websocket connection stays open.', () async {
        await returningStreamClosed.future.timeout(Duration(seconds: 5));

        // Monitor websocket connection for 1 second to make sure it stays open.
        expectLater(
          webSocketCompleter.future.timeout(Duration(seconds: 1)),
          throwsA(isA<TimeoutException>()),
        );
      });
    });
  });
}

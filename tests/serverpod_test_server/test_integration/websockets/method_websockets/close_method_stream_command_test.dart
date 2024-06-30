import 'dart:async';

import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
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

    group(
        'when connecting to an endpoint that ignores reading input stream and returns',
        () {
      var endpoint = 'methodStreaming';
      var method = 'directVoidReturnWithStreamInput';

      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      late Completer<CloseMethodStreamCommand>
          closeMethodStreamParameterCommand;
      TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

      var inputStreamParameter = 'stream';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
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
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            if (message.parameter == null) {
              closeMethodStreamCommand.complete(message);
            } else if (message.parameter == inputStreamParameter) {
              closeMethodStreamParameterCommand.complete(message);
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
          'then CloseMethodStreamCommand matching the stream parameter is received.',
          () async {
        closeMethodStreamParameterCommand.future.catchError((error) {
          fail(
              'Failed to receive CloseMethodStreamCommand from server for stream parameter.');
        }).then((message) {
          expect(message.endpoint, endpoint);
          expect(message.method, method);
          expect(message.parameter, inputStreamParameter);
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

  group(
      'Given a single method stream connection to an endpoint that has delayed stream response',
      () {
    var server = IntegrationTestServer.create();
    late WebSocketChannel webSocket;
    var endpoint = 'methodStreaming';
    var method = 'delayedStreamResponse';
    var connectionId = const Uuid().v4obj();

    setUp(() async {
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      await webSocket.ready;

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        args: {'delay': 20},
        connectionId: connectionId,
      ));
    });

    tearDown(() async {
      await webSocket.sink.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'when a CloseMethodStreamCommand is sent then websocket connection is closed',
        () async {
      var websocketCompleter = Completer<void>();
      webSocket.stream.listen((event) {
        // Listen to the to keep it open.
      }, onDone: () {
        websocketCompleter.complete();
      });

      webSocket.sink.add(CloseMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        connectionId: connectionId,
        reason: CloseReason.done,
      ));

      await expectLater(
          websocketCompleter.future.timeout(Duration(seconds: 10)).catchError(
              (error) => fail('Websocket connection was never closed.')),
          completes);
      expect(webSocket.closeCode, isNotNull);
    });
  });

  group(
      'Given a single method stream connection to an endpoint that has an input stream that is never listened to',
      () {
    var server = IntegrationTestServer.create();
    late WebSocketChannel webSocket;
    var endpoint = 'methodStreaming';
    var method = 'delayedNeverListenedInputStream';
    var connectionId = const Uuid().v4obj();

    setUp(() async {
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      await webSocket.ready;

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        args: {'delay': 20},
        connectionId: connectionId,
      ));
    });

    tearDown(() async {
      await webSocket.sink.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'when a CloseMethodStreamCommand is sent then websocket connection is closed',
        () async {
      var websocketCompleter = Completer<void>();
      webSocket.stream.listen((event) {
        // Listen to the to keep it open.
      }, onDone: () {
        websocketCompleter.complete();
      });

      webSocket.sink.add(CloseMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        connectionId: connectionId,
        reason: CloseReason.done,
      ));

      await expectLater(
          websocketCompleter.future.timeout(Duration(seconds: 10)).catchError(
              (error) => fail('Websocket connection was never closed.')),
          completes);
      expect(webSocket.closeCode, isNotNull);
    });
  });

  group(
      'Given a single method stream connection to an endpoint that has an input stream that is paused',
      () {
    var server = IntegrationTestServer.create();
    late WebSocketChannel webSocket;
    var endpoint = 'methodStreaming';
    var method = 'delayedPausedInputStream';
    var connectionId = const Uuid().v4obj();

    setUp(() async {
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      await webSocket.ready;

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        args: {'delay': 20},
        connectionId: connectionId,
      ));
    });

    tearDown(() async {
      await webSocket.sink.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'when a CloseMethodStreamCommand is sent then websocket connection is closed',
        () async {
      var websocketCompleter = Completer<void>();
      webSocket.stream.listen((event) {
        print(event);
        // Listen to the to keep it open.
      }, onDone: () {
        websocketCompleter.complete();
      });

      webSocket.sink.add(CloseMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        connectionId: connectionId,
        reason: CloseReason.done,
      ));

      await expectLater(
          websocketCompleter.future.timeout(Duration(seconds: 10)).catchError(
              (error) => fail('Websocket connection was never closed.')),
          completes);
      expect(webSocket.closeCode, isNotNull);
    });
  });
}

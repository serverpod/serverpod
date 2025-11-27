import 'dart:async';

import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import '../websocket_extensions.dart';

void main() {
  group('Given multiple method stream connections when one returns', () {
    var endpoint = 'methodStreaming';
    var keepAliveMethod = 'intEchoStream';
    var closeMethod = 'intStreamFromValue';
    var keepAliveConnectionId = const Uuid().v4obj();

    late Serverpod server;
    late WebSocket webSocket;

    late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
    late Completer<void> webSocketCompleter;
    late Completer<void> keepAliveMessageReceived;
    TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

    late bool testInProgress;

    setUp(() async {
      testInProgress = true;
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = await WebSocket.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
      webSocketCompleter = Completer<void>();
      keepAliveMessageReceived = Completer<void>();
      var streamOpened = Completer<void>();

      testCompleterTimeout.start({
        'closeMethodStreamCommand': closeMethodStreamCommand,
        'streamOpened': streamOpened,
        'keepAliveMessageReceived': keepAliveMessageReceived,
      });

      webSocket.textEvents.listen(
        (event) {
          var message = WebSocketMessage.fromJsonString(
            event,
            server.serializationManager,
          );
          ;
          if (message is OpenMethodStreamResponse &&
              message.connectionId == keepAliveConnectionId) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand &&
              message.method == closeMethod) {
            closeMethodStreamCommand.complete(message);
          } else if (message is MethodStreamMessage &&
              message.method == keepAliveMethod) {
            keepAliveMessageReceived.complete();
          }
        },
        onDone: () {
          if (testInProgress) webSocketCompleter.complete();
        },
      );

      webSocket.sendText(
        OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: keepAliveMethod,
          args: {},
          connectionId: keepAliveConnectionId,
          inputStreams: ['stream'],
        ),
      );

      webSocket.sendText(
        OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: closeMethod,
          args: {'value': 4},
          connectionId: const Uuid().v4obj(),
          inputStreams: [],
        ),
      );

      await streamOpened.future;
      assert(
        streamOpened.isCompleted == true,
        'Failed to open method stream with server',
      );
      await closeMethodStreamCommand.future;
      assert(
        closeMethodStreamCommand.isCompleted == true,
        'Failed to receive close method stream from server',
      );
    });

    tearDown(() async {
      testInProgress = false;
      testCompleterTimeout.cancel();
      await server.shutdown(exitProcess: false);
      await webSocket.tryClose();
    });

    test('then websocket can still be used to send messages.', () async {
      expect(webSocketCompleter.future, doesNotComplete);

      webSocket.sendText(
        MethodStreamMessage.buildMessage(
          endpoint: endpoint,
          method: keepAliveMethod,
          parameter: 'stream',
          object: 4,
          serializationManager: server.serializationManager,
          connectionId: keepAliveConnectionId,
        ),
      );

      keepAliveMessageReceived.future.catchError((error) {
        fail('Failed to receive keep alive message.');
      });
      await expectLater(keepAliveMessageReceived.future, completes);
    });
  });

  group(
    'Given multiple method stream connections when one throws then webSocket connection is not closed.',
    () {
      var endpoint = 'methodStreaming';
      var keepAliveMethod = 'intEchoStream';
      var throwMethod = 'outStreamThrowsException';
      var keepAliveConnectionId = const Uuid().v4obj();

      late Serverpod server;
      late WebSocket webSocket;

      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      late Completer<void> webSocketCompleter;
      late Completer<void> keepAliveMessageReceived;
      TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

      late bool testInProgress;

      setUp(() async {
        testInProgress = true;
        server = IntegrationTestServer.create();
        await server.start();
        webSocket = await WebSocket.connect(
          Uri.parse(serverMethodWebsocketUrl),
        );

        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        webSocketCompleter = Completer<void>();
        keepAliveMessageReceived = Completer<void>();
        var streamOpened = Completer<void>();

        testCompleterTimeout.start({
          'closeMethodStreamCommand': closeMethodStreamCommand,
          'streamOpened': streamOpened,
          'keepAliveMessageReceived': keepAliveMessageReceived,
        });

        webSocket.textEvents.listen(
          (event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              server.serializationManager,
            );
            ;
            if (message is OpenMethodStreamResponse &&
                message.connectionId == keepAliveConnectionId) {
              streamOpened.complete();
            } else if (message is CloseMethodStreamCommand &&
                message.method == throwMethod) {
              closeMethodStreamCommand.complete(message);
            } else if (message is MethodStreamMessage &&
                message.method == keepAliveMethod) {
              keepAliveMessageReceived.complete();
            }
          },
          onDone: () {
            if (testInProgress) webSocketCompleter.complete();
          },
        );

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: keepAliveMethod,
            args: {},
            connectionId: keepAliveConnectionId,
            inputStreams: ['stream'],
          ),
        );

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: throwMethod,
            args: {},
            connectionId: const Uuid().v4obj(),
            inputStreams: [],
          ),
        );

        await streamOpened.future;
        assert(
          streamOpened.isCompleted == true,
          'Failed to open method stream with server',
        );
        await closeMethodStreamCommand.future;
        assert(
          closeMethodStreamCommand.isCompleted == true,
          'Failed to receive close method stream from server',
        );
      });

      tearDown(() async {
        testInProgress = false;
        testCompleterTimeout.cancel();
        await server.shutdown(exitProcess: false);
        await webSocket.tryClose();
      });

      test('then websocket can still be used to send messages.', () async {
        expect(webSocketCompleter.future, doesNotComplete);

        webSocket.sendText(
          MethodStreamMessage.buildMessage(
            endpoint: endpoint,
            method: keepAliveMethod,
            parameter: 'stream',
            object: 4,
            serializationManager: server.serializationManager,
            connectionId: keepAliveConnectionId,
          ),
        );

        keepAliveMessageReceived.future.catchError((error) {
          fail('Failed to receive keep alive message.');
        });
        await expectLater(keepAliveMessageReceived.future, completes);
      });
    },
  );

  group(
    'Given multiple method stream connections when one throws serializable exception then webSocket connection is not closed.',
    () {
      var endpoint = 'methodStreaming';
      var keepAliveMethod = 'intEchoStream';
      var throwMethod = 'outStreamThrowsSerializableException';
      var keepAliveConnectionId = const Uuid().v4obj();

      late Serverpod server;
      late WebSocket webSocket;

      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
      late Completer<void> webSocketCompleter;
      late Completer<void> keepAliveMessageReceived;
      TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

      late bool testInProgress;

      setUp(() async {
        testInProgress = true;
        server = IntegrationTestServer.create();
        await server.start();
        webSocket = await WebSocket.connect(
          Uri.parse(serverMethodWebsocketUrl),
        );

        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        webSocketCompleter = Completer<void>();
        keepAliveMessageReceived = Completer<void>();
        var streamOpened = Completer<void>();

        testCompleterTimeout.start({
          'closeMethodStreamCommand': closeMethodStreamCommand,
          'streamOpened': streamOpened,
          'keepAliveMessageReceived': keepAliveMessageReceived,
        });

        webSocket.textEvents.listen(
          (event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              server.serializationManager,
            );
            ;
            if (message is OpenMethodStreamResponse &&
                message.connectionId == keepAliveConnectionId) {
              streamOpened.complete();
            } else if (message is CloseMethodStreamCommand &&
                message.method == throwMethod) {
              closeMethodStreamCommand.complete(message);
            } else if (message is MethodStreamMessage &&
                message.method == keepAliveMethod) {
              keepAliveMessageReceived.complete();
            }
          },
          onDone: () {
            if (testInProgress) webSocketCompleter.complete();
          },
        );

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: keepAliveMethod,
            args: {},
            connectionId: keepAliveConnectionId,
            inputStreams: ['stream'],
          ),
        );

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: throwMethod,
            args: {},
            connectionId: const Uuid().v4obj(),
            inputStreams: [],
          ),
        );

        await streamOpened.future;
        assert(
          streamOpened.isCompleted == true,
          'Failed to open method stream with server',
        );
        await closeMethodStreamCommand.future;
        assert(
          closeMethodStreamCommand.isCompleted == true,
          'Failed to receive close method stream from server',
        );
      });

      tearDown(() async {
        testInProgress = false;
        testCompleterTimeout.cancel();
        await server.shutdown(exitProcess: false);
        await webSocket.tryClose();
      });

      test('then websocket can still be used to send messages.', () async {
        expect(webSocketCompleter.future, doesNotComplete);

        webSocket.sendText(
          MethodStreamMessage.buildMessage(
            endpoint: endpoint,
            method: keepAliveMethod,
            parameter: 'stream',
            object: 4,
            serializationManager: server.serializationManager,
            connectionId: keepAliveConnectionId,
          ),
        );

        keepAliveMessageReceived.future.catchError((error) {
          fail('Failed to receive keep alive message.');
        });
        await expectLater(keepAliveMessageReceived.future, completes);
      });
    },
  );
}

import 'dart:async';

import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group('Given a single method stream connection when the method returns ', () {
    var endpoint = 'methodStreaming';
    var method = 'intStreamFromValue';

    late Serverpod server;
    late WebSocketChannel webSocket;

    late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
    late Completer<void> webSocketCompleter;
    TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      await webSocket.ready;

      closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
      webSocketCompleter = Completer<void>();
      var streamOpened = Completer<void>();

      testCompleterTimeout.start({
        'closeMethodStreamCommand': closeMethodStreamCommand,
        'webSocketCompleter': webSocketCompleter,
        'streamOpened': streamOpened,
      });

      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(event);
        if (message is OpenMethodStreamResponse) {
          streamOpened.complete();
        } else if (message is CloseMethodStreamCommand) {
          closeMethodStreamCommand.complete(message);
        }
      }, onDone: () {
        webSocketCompleter.complete();
      });

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        args: {'value': 4},
        connectionId: const Uuid().v4obj(),
      ));

      await streamOpened.future;
      assert(streamOpened.isCompleted == true,
          'Failed to open method stream with server');
      await closeMethodStreamCommand.future;
      assert(closeMethodStreamCommand.isCompleted == true,
          'Failed to receive close method stream from server');
    });

    tearDown(() async {
      testCompleterTimeout.cancel();
      await server.shutdown(exitProcess: false);
      await webSocket.sink.close();
    });

    test('then websocket connection is closed.', () async {
      webSocketCompleter.future.catchError((error) {
        fail('Failed to close websocket.');
      });

      await expectLater(webSocketCompleter.future, completes);
    });
  });

  group('Given multiple method stream connections when one returns', () {
    var endpoint = 'methodStreaming';
    var keepAliveMethod = 'intEchoStream';
    var closeMethod = 'intStreamFromValue';
    var keepAliveConnectionId = const Uuid().v4obj();

    late Serverpod server;
    late WebSocketChannel webSocket;

    late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
    late Completer<void> webSocketCompleter;
    late Completer<void> keepAliveMessageReceived;
    TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

    late bool testInProgress;

    setUp(() async {
      testInProgress = true;
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      await webSocket.ready;

      closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
      webSocketCompleter = Completer<void>();
      keepAliveMessageReceived = Completer<void>();
      var streamOpened = Completer<void>();

      testCompleterTimeout.start({
        'closeMethodStreamCommand': closeMethodStreamCommand,
        'streamOpened': streamOpened,
        'keepAliveMessageReceived': keepAliveMessageReceived,
      });

      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(event);
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
      }, onDone: () {
        if (testInProgress) webSocketCompleter.complete();
      });

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: keepAliveMethod,
        args: {},
        connectionId: keepAliveConnectionId,
      ));

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: closeMethod,
        args: {'value': 4},
        connectionId: const Uuid().v4obj(),
      ));

      await streamOpened.future;
      assert(streamOpened.isCompleted == true,
          'Failed to open method stream with server');
      await closeMethodStreamCommand.future;
      assert(closeMethodStreamCommand.isCompleted == true,
          'Failed to receive close method stream from server');
    });

    tearDown(() async {
      testInProgress = false;
      testCompleterTimeout.cancel();
      await server.shutdown(exitProcess: false);
      await webSocket.sink.close();
    });

    test('then websocket can still be used to send messages.', () async {
      expect(webSocketCompleter.future, doesNotComplete);

      webSocket.sink.add(MethodStreamMessage.buildMessage(
        endpoint: endpoint,
        method: keepAliveMethod,
        parameter: 'stream',
        object: server.serializationManager.encodeWithType(4),
        connectionId: keepAliveConnectionId,
      ));

      keepAliveMessageReceived.future.catchError((error) {
        fail('Failed to receive keep alive message.');
      });
      await expectLater(keepAliveMessageReceived.future, completes);
    });
  });

  group('Given a single method stream connection when the method throws', () {
    var endpoint = 'methodStreaming';
    var method = 'outStreamThrowsException';

    late Serverpod server;
    late WebSocketChannel webSocket;

    late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
    late Completer<void> webSocketCompleter;
    TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      await webSocket.ready;

      closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
      webSocketCompleter = Completer<void>();
      var streamOpened = Completer<void>();

      testCompleterTimeout.start({
        'closeMethodStreamCommand': closeMethodStreamCommand,
        'webSocketCompleter': webSocketCompleter,
        'streamOpened': streamOpened,
      });

      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(event);
        if (message is OpenMethodStreamResponse) {
          streamOpened.complete();
        } else if (message is CloseMethodStreamCommand) {
          closeMethodStreamCommand.complete(message);
        }
      }, onDone: () {
        webSocketCompleter.complete();
      });

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        args: {},
        connectionId: const Uuid().v4obj(),
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

    test('then websocket connection is closed.', () async {
      webSocketCompleter.future.catchError((error) {
        fail('Failed to close websocket.');
      });

      await expectLater(webSocketCompleter.future, completes);
    });
  });

  group(
      'Given a single method stream connection when the method throws serializable exception then webSocket connection is closed.',
      () {
    var endpoint = 'methodStreaming';
    var method = 'outStreamThrowsSerializableException';

    late Serverpod server;
    late WebSocketChannel webSocket;

    late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
    late Completer<void> webSocketCompleter;
    TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      await webSocket.ready;

      closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
      webSocketCompleter = Completer<void>();
      var streamOpened = Completer<void>();

      testCompleterTimeout.start({
        'closeMethodStreamCommand': closeMethodStreamCommand,
        'webSocketCompleter': webSocketCompleter,
        'streamOpened': streamOpened,
      });

      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(event);
        if (message is OpenMethodStreamResponse) {
          streamOpened.complete();
        } else if (message is CloseMethodStreamCommand) {
          closeMethodStreamCommand.complete(message);
        }
      }, onDone: () {
        webSocketCompleter.complete();
      });

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: method,
        args: {},
        connectionId: const Uuid().v4obj(),
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

    test('then websocket connection is closed.', () async {
      webSocketCompleter.future.catchError((error) {
        fail('Failed to close websocket.');
      });

      await expectLater(webSocketCompleter.future, completes);
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
    late WebSocketChannel webSocket;

    late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
    late Completer<void> webSocketCompleter;
    late Completer<void> keepAliveMessageReceived;
    TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

    late bool testInProgress;

    setUp(() async {
      testInProgress = true;
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      await webSocket.ready;

      closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
      webSocketCompleter = Completer<void>();
      keepAliveMessageReceived = Completer<void>();
      var streamOpened = Completer<void>();

      testCompleterTimeout.start({
        'closeMethodStreamCommand': closeMethodStreamCommand,
        'streamOpened': streamOpened,
        'keepAliveMessageReceived': keepAliveMessageReceived,
      });

      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(event);
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
      }, onDone: () {
        if (testInProgress) webSocketCompleter.complete();
      });

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: keepAliveMethod,
        args: {},
        connectionId: keepAliveConnectionId,
      ));

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: throwMethod,
        args: {},
        connectionId: const Uuid().v4obj(),
      ));

      await streamOpened.future;
      assert(streamOpened.isCompleted == true,
          'Failed to open method stream with server');
      await closeMethodStreamCommand.future;
      assert(closeMethodStreamCommand.isCompleted == true,
          'Failed to receive close method stream from server');
    });

    tearDown(() async {
      testInProgress = false;
      testCompleterTimeout.cancel();
      await server.shutdown(exitProcess: false);
      await webSocket.sink.close();
    });

    test('then websocket can still be used to send messages.', () async {
      expect(webSocketCompleter.future, doesNotComplete);

      webSocket.sink.add(MethodStreamMessage.buildMessage(
        endpoint: endpoint,
        method: keepAliveMethod,
        parameter: 'stream',
        object: server.serializationManager.encodeWithType(4),
        connectionId: keepAliveConnectionId,
      ));

      keepAliveMessageReceived.future.catchError((error) {
        fail('Failed to receive keep alive message.');
      });
      await expectLater(keepAliveMessageReceived.future, completes);
    });
  });

  group(
      'Given multiple method stream connections when one throws serializable exception then webSocket connection is not closed.',
      () {
    var endpoint = 'methodStreaming';
    var keepAliveMethod = 'intEchoStream';
    var throwMethod = 'outStreamThrowsSerializableException';
    var keepAliveConnectionId = const Uuid().v4obj();

    late Serverpod server;
    late WebSocketChannel webSocket;

    late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
    late Completer<void> webSocketCompleter;
    late Completer<void> keepAliveMessageReceived;
    TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

    late bool testInProgress;

    setUp(() async {
      testInProgress = true;
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      await webSocket.ready;

      closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
      webSocketCompleter = Completer<void>();
      keepAliveMessageReceived = Completer<void>();
      var streamOpened = Completer<void>();

      testCompleterTimeout.start({
        'closeMethodStreamCommand': closeMethodStreamCommand,
        'streamOpened': streamOpened,
        'keepAliveMessageReceived': keepAliveMessageReceived,
      });

      webSocket.stream.listen((event) {
        var message = WebSocketMessage.fromJsonString(event);
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
      }, onDone: () {
        if (testInProgress) webSocketCompleter.complete();
      });

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: keepAliveMethod,
        args: {},
        connectionId: keepAliveConnectionId,
      ));

      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: throwMethod,
        args: {},
        connectionId: const Uuid().v4obj(),
      ));

      await streamOpened.future;
      assert(streamOpened.isCompleted == true,
          'Failed to open method stream with server');
      await closeMethodStreamCommand.future;
      assert(closeMethodStreamCommand.isCompleted == true,
          'Failed to receive close method stream from server');
    });

    tearDown(() async {
      testInProgress = false;
      testCompleterTimeout.cancel();
      await server.shutdown(exitProcess: false);
      await webSocket.sink.close();
    });

    test('then websocket can still be used to send messages.', () async {
      expect(webSocketCompleter.future, doesNotComplete);

      webSocket.sink.add(MethodStreamMessage.buildMessage(
        endpoint: endpoint,
        method: keepAliveMethod,
        parameter: 'stream',
        object: server.serializationManager.encodeWithType(4),
        connectionId: keepAliveConnectionId,
      ));

      keepAliveMessageReceived.future.catchError((error) {
        fail('Failed to receive keep alive message.');
      });
      await expectLater(keepAliveMessageReceived.future, completes);
    });
  });
}

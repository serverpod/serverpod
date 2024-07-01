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

    group(
        'when a stream is opened to an endpoint with a Future return that throws an exception',
        () {
      var streamOpened = Completer<void>();
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;

      var endpoint = 'methodStreaming';
      var method = 'inStreamThrowsException';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            closeMethodStreamCommand.complete(message);
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
          connectionId: connectionId,
        ));

        await streamOpened.future.timeout(
          Duration(seconds: 5),
          onTimeout: () => throw AssertionError(
            'Failed to open method stream with server.',
          ),
        );
      });

      test('then CloseMethodStreamCommand matching endpoint is received.',
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
        expect(closeMethodStreamCommandMessage.reason, CloseReason.error);
      });
    });

    group(
        'when a stream is opened to an endpoint with a Stream return that throws an exception then',
        () {
      var streamOpened = Completer<void>();
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;

      var endpoint = 'methodStreaming';
      var method = 'outStreamThrowsException';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is CloseMethodStreamCommand) {
            closeMethodStreamCommand.complete(message);
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
          connectionId: connectionId,
        ));

        await streamOpened.future.timeout(
          Duration(seconds: 5),
          onTimeout: () => throw AssertionError(
            'Failed to open method stream with server.',
          ),
        );
      });

      test('then CloseMethodStreamCommand matching endpoint is received.',
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
        expect(closeMethodStreamCommandMessage.reason, CloseReason.error);
      });
    });

    group(
        'when a stream is opened to an endpoint with a Future return that throws a serializable exception',
        () {
      late Completer<MethodStreamSerializableException>
          methodStreamSerializableException;
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;

      var endpoint = 'methodStreaming';
      var method = 'inStreamThrowsSerializableException';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        var streamOpened = Completer<void>();
        methodStreamSerializableException =
            Completer<MethodStreamSerializableException>();
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is MethodStreamSerializableException) {
            methodStreamSerializableException.complete(message);
          } else if (message is CloseMethodStreamCommand) {
            closeMethodStreamCommand.complete(message);
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
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
          'then MethodStreamSerializableException matching the endpoint is received.',
          () async {
        var message = methodStreamSerializableException.future
            .timeout(Duration(seconds: 5));
        expect(
          message,
          completes,
          reason:
              'Failed to receive MethodStreamSerializableException from server.',
        );

        var methodStreamSerializableExceptionMessage = await message;
        expect(methodStreamSerializableExceptionMessage.endpoint, endpoint);
        expect(methodStreamSerializableExceptionMessage.method, method);
        expect(methodStreamSerializableExceptionMessage.connectionId,
            connectionId);
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
        expect(closeMethodStreamCommandMessage.reason, CloseReason.error);
      });
    });

    group(
        'when a stream is opened to an endpoint with a Stream return that throws a serializable exception',
        () {
      late Completer<MethodStreamSerializableException>
          methodStreamSerializableException;
      late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;

      var endpoint = 'methodStreaming';
      var method = 'outStreamThrowsSerializableException';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        var streamOpened = Completer<void>();
        methodStreamSerializableException =
            Completer<MethodStreamSerializableException>();
        closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();

        webSocket.stream.listen((event) {
          var message = WebSocketMessage.fromJsonString(event);
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          } else if (message is MethodStreamSerializableException) {
            methodStreamSerializableException.complete(message);
          } else if (message is CloseMethodStreamCommand) {
            closeMethodStreamCommand.complete(message);
          }
        });

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
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
          'then MethodStreamSerializableException matching the endpoint is received.',
          () async {
        var message = methodStreamSerializableException.future
            .timeout(Duration(seconds: 5));
        expect(
          message,
          completes,
          reason:
              'Failed to receive MethodStreamSerializableException from server.',
        );

        var methodStreamSerializableExceptionMessage = await message;
        expect(methodStreamSerializableExceptionMessage.endpoint, endpoint);
        expect(methodStreamSerializableExceptionMessage.method, method);
        expect(methodStreamSerializableExceptionMessage.connectionId,
            connectionId);
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
        expect(closeMethodStreamCommandMessage.reason, CloseReason.error);
      });
    });
  });
}

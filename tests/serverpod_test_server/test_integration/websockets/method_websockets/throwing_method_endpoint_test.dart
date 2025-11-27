import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import '../websocket_extensions.dart';

void main() {
  group('Given method websocket connection', () {
    late Serverpod server;
    late WebSocket webSocket;

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = await WebSocket.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      await webSocket.tryClose();
    });

    group(
      'when a stream is opened to an endpoint with a Future return that throws an exception',
      () {
        late Completer<void> streamOpened;
        late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
        late Completer<CloseMethodStreamCommand>
        closeMethodStreamParameterCommand;

        var endpoint = 'methodStreaming';
        var method = 'inStreamThrowsException';
        var parameter = 'stream';
        var connectionId = const Uuid().v4obj();

        setUp(() async {
          streamOpened = Completer<void>();
          closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
          closeMethodStreamParameterCommand =
              Completer<CloseMethodStreamCommand>();
          webSocket.textEvents.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              server.serializationManager,
            );
            if (message is OpenMethodStreamResponse) {
              streamOpened.complete();
            } else if (message is CloseMethodStreamCommand &&
                message.parameter == null) {
              closeMethodStreamCommand.complete(message);
            } else if (message is CloseMethodStreamCommand &&
                message.parameter == parameter) {
              closeMethodStreamParameterCommand.complete(message);
            }
          });

          webSocket.sendText(
            OpenMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              args: {},
              connectionId: connectionId,
              inputStreams: [parameter],
            ),
          );

          await streamOpened.future.timeout(
            Duration(seconds: 5),
            onTimeout: () => throw AssertionError(
              'Failed to open method stream with server.',
            ),
          );
        });

        test(
          'then CloseMethodStreamCommand matching endpoint is received with error reason.',
          () async {
            var message = closeMethodStreamCommand.future.timeout(
              Duration(seconds: 5),
            );
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
          },
        );

        test(
          'then CloseMethodStreamCommand matching endpoint parameter is received with error reason.',
          () async {
            var message = closeMethodStreamParameterCommand.future.timeout(
              Duration(seconds: 5),
            );
            expect(
              message,
              completes,
              reason: 'Failed to receive CloseMethodStreamCommand from server.',
            );

            var closeMethodStreamCommandMessage = await message;
            expect(closeMethodStreamCommandMessage.endpoint, endpoint);
            expect(closeMethodStreamCommandMessage.method, method);
            expect(closeMethodStreamCommandMessage.parameter, parameter);
            expect(closeMethodStreamCommandMessage.connectionId, connectionId);
            expect(closeMethodStreamCommandMessage.reason, CloseReason.error);
          },
        );
      },
    );

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
          webSocket.textEvents.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              server.serializationManager,
            );
            if (message is OpenMethodStreamResponse) {
              streamOpened.complete();
            } else if (message is CloseMethodStreamCommand) {
              closeMethodStreamCommand.complete(message);
            }
          });

          webSocket.sendText(
            OpenMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              args: {},
              connectionId: connectionId,
              inputStreams: [],
            ),
          );

          await streamOpened.future.timeout(
            Duration(seconds: 5),
            onTimeout: () => throw AssertionError(
              'Failed to open method stream with server.',
            ),
          );
        });

        test(
          'then CloseMethodStreamCommand matching endpoint with error reason is received.',
          () async {
            var message = closeMethodStreamCommand.future.timeout(
              Duration(seconds: 5),
            );
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
          },
        );
      },
    );

    group(
      'when a stream is opened to an endpoint with a Future return that throws a serializable exception',
      () {
        late Completer<MethodStreamSerializableException>
        methodStreamSerializableException;
        late Completer<void> streamOpened;
        late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
        late Completer<CloseMethodStreamCommand>
        closeMethodStreamParameterCommand;

        var endpoint = 'methodStreaming';
        var method = 'inStreamThrowsSerializableException';
        var parameter = 'stream';
        var connectionId = const Uuid().v4obj();

        setUp(() async {
          streamOpened = Completer<void>();
          methodStreamSerializableException =
              Completer<MethodStreamSerializableException>();
          closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
          closeMethodStreamParameterCommand =
              Completer<CloseMethodStreamCommand>();

          webSocket.textEvents.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              server.serializationManager,
            );
            if (message is OpenMethodStreamResponse) {
              streamOpened.complete();
            } else if (message is MethodStreamSerializableException) {
              methodStreamSerializableException.complete(message);
            } else if (message is CloseMethodStreamCommand &&
                message.parameter == null) {
              closeMethodStreamCommand.complete(message);
            } else if (message is CloseMethodStreamCommand &&
                message.parameter == parameter) {
              closeMethodStreamParameterCommand.complete(message);
            }
          });

          webSocket.sendText(
            OpenMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              args: {},
              connectionId: connectionId,
              inputStreams: ['stream'],
            ),
          );

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
            var message = methodStreamSerializableException.future.timeout(
              Duration(seconds: 5),
            );
            expect(
              message,
              completes,
              reason:
                  'Failed to receive MethodStreamSerializableException from server.',
            );

            var methodStreamSerializableExceptionMessage = await message;
            expect(methodStreamSerializableExceptionMessage.endpoint, endpoint);
            expect(methodStreamSerializableExceptionMessage.method, method);
            expect(
              methodStreamSerializableExceptionMessage.connectionId,
              connectionId,
            );
          },
        );

        test(
          'then CloseMethodStreamCommand matching the endpoint with error reason is received.',
          () async {
            var message = closeMethodStreamCommand.future.timeout(
              Duration(seconds: 5),
            );
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
          },
        );

        test(
          'then CloseMethodStreamCommand matching endpoint parameter is received with error reason.',
          () async {
            var message = closeMethodStreamParameterCommand.future.timeout(
              Duration(seconds: 5),
            );
            expect(
              message,
              completes,
              reason: 'Failed to receive CloseMethodStreamCommand from server.',
            );

            var closeMethodStreamCommandMessage = await message;
            expect(closeMethodStreamCommandMessage.endpoint, endpoint);
            expect(closeMethodStreamCommandMessage.method, method);
            expect(closeMethodStreamCommandMessage.parameter, parameter);
            expect(closeMethodStreamCommandMessage.connectionId, connectionId);
            expect(closeMethodStreamCommandMessage.reason, CloseReason.error);
          },
        );
      },
    );

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

          webSocket.textEvents.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              server.serializationManager,
            );
            if (message is OpenMethodStreamResponse) {
              streamOpened.complete();
            } else if (message is MethodStreamSerializableException) {
              methodStreamSerializableException.complete(message);
            } else if (message is CloseMethodStreamCommand) {
              closeMethodStreamCommand.complete(message);
            }
          });

          webSocket.sendText(
            OpenMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              args: {},
              connectionId: connectionId,
              inputStreams: [],
            ),
          );

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
            var message = methodStreamSerializableException.future.timeout(
              Duration(seconds: 5),
            );
            expect(
              message,
              completes,
              reason:
                  'Failed to receive MethodStreamSerializableException from server.',
            );

            var methodStreamSerializableExceptionMessage = await message;
            expect(methodStreamSerializableExceptionMessage.endpoint, endpoint);
            expect(methodStreamSerializableExceptionMessage.method, method);
            expect(
              methodStreamSerializableExceptionMessage.connectionId,
              connectionId,
            );
          },
        );

        test(
          'then CloseMethodStreamCommand matching the endpoint with error reason is received.',
          () async {
            var message = closeMethodStreamCommand.future.timeout(
              Duration(seconds: 5),
            );
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
          },
        );
      },
    );
  });
}

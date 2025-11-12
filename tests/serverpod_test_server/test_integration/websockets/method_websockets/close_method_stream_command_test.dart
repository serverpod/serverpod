import 'dart:async';

import 'package:serverpod_test_server/src/endpoints/method_streaming.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
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

    group('with a connected method stream has a delayed response', () {
      late Completer<void> delayedStreamIsCanceled;
      late Completer<void> delayedResponseClosed;

      var endpoint = 'methodStreaming';
      var method = 'delayedStreamResponse';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        var delayedResponseOpen = Completer<void>();
        delayedResponseClosed = Completer<void>();
        delayedStreamIsCanceled = Completer<void>();

        var delayedStreamResponseCompleter = Completer<StreamController<int>>();
        MethodStreaming.delayedStreamResponseController =
            delayedStreamResponseCompleter;

        delayedStreamResponseCompleter.future.then(
          (StreamController controller) => controller.onCancel = () {
            delayedStreamIsCanceled.complete();
          },
        );

        webSocket.textEvents.listen((event) {
          var message = WebSocketMessage.fromJsonString(
            event,
            server.serializationManager,
          );
          ;
          if (message is OpenMethodStreamResponse) {
            if (message.connectionId == connectionId)
              delayedResponseOpen.complete();
          } else if (message is CloseMethodStreamCommand) {
            if (message.connectionId == connectionId)
              delayedResponseClosed.complete();
          }
        });

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: method,
            args: {'delay': 10},
            connectionId: connectionId,
            inputStreams: [],
          ),
        );

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
        'when stream is closed by a CloseMethodStreamCommand then delayed stream is canceled.',
        () async {
          webSocket.sendText(
            CloseMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              connectionId: connectionId,
              reason: CloseReason.done,
            ),
          );

          await expectLater(
            delayedStreamIsCanceled.future.timeout(Duration(seconds: 5)),
            completes,
            reason:
                'Websocket connection was not closed when only stream was closed.',
          );
        },
      );
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

          webSocket.textEvents.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              server.serializationManager,
            );
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

          webSocket.sendText(
            OpenMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              args: {},
              connectionId: connectionId,
              inputStreams: [inputStreamParameter],
            ),
          );

          await streamOpened.future;
          assert(
            streamOpened.isCompleted == true,
            'Failed to open method stream with server',
          );
        });

        tearDown(() => testCompleterTimeout.cancel());

        test(
          'then CloseMethodStreamCommand matching the endpoint is received.',
          () async {
            closeMethodStreamCommand.future
                .catchError((error) {
                  fail(
                    'Failed to receive CloseMethodStreamCommand from server.',
                  );
                })
                .then((message) {
                  expect(message.endpoint, endpoint);
                  expect(message.method, method);
                  expect(message.connectionId, connectionId);
                  expect(message.reason, CloseReason.done);
                });

            await expectLater(closeMethodStreamCommand.future, completes);
          },
        );

        test(
          'then CloseMethodStreamCommand matching the stream parameter is received.',
          () async {
            closeMethodStreamParameterCommand.future
                .catchError((error) {
                  fail(
                    'Failed to receive CloseMethodStreamCommand from server for stream parameter.',
                  );
                })
                .then((message) {
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
          },
        );
      },
    );
  });

  group(
    'Given a single method stream connection to an endpoint that has delayed stream response',
    () {
      late Completer<void> delayedStreamIsCanceled;
      var server = IntegrationTestServer.create();
      late WebSocket webSocket;
      var endpoint = 'methodStreaming';
      var method = 'delayedStreamResponse';
      var connectionId = const Uuid().v4obj();

      setUp(() async {
        delayedStreamIsCanceled = Completer<void>();

        var delayedStreamResponseCompleter = Completer<StreamController<int>>();
        MethodStreaming.delayedStreamResponseController =
            delayedStreamResponseCompleter;

        delayedStreamResponseCompleter.future.then(
          (StreamController controller) => controller.onCancel = () {
            delayedStreamIsCanceled.complete();
          },
        );

        await server.start();
        webSocket = await WebSocket.connect(
          Uri.parse(serverMethodWebsocketUrl),
        );

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: method,
            args: {'delay': 20},
            connectionId: connectionId,
            inputStreams: [],
          ),
        );
      });

      tearDown(() async {
        await webSocket.tryClose();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when a CloseMethodStreamCommand is sent then endpoint stream is canceled',
        () async {
          webSocket.textEvents.listen(
            (event) {
              // Listen to the to keep it open.
            },
          );

          webSocket.sendText(
            CloseMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              connectionId: connectionId,
              reason: CloseReason.done,
            ),
          );

          await expectLater(
            delayedStreamIsCanceled.future
                .timeout(Duration(seconds: 10))
                .catchError(
                  (error) => fail('Delayed stream was never cancelled.'),
                ),
            completes,
          );
        },
      );
    },
  );

  group(
    'Given a single method stream connection to an endpoint that has an input stream that is never listened to',
    () {
      var server = IntegrationTestServer.create();
      late WebSocket webSocket;
      var endpoint = 'methodStreaming';
      var method = 'delayedNeverListenedInputStream';
      var connectionId = const Uuid().v4obj();
      late Completer endpointSessionIsClosed;

      setUp(() async {
        var delayedNeverListenedInputStreamCompleter = Completer<Session>();
        MethodStreaming.delayedNeverListenedInputStreamCompleter =
            delayedNeverListenedInputStreamCompleter;

        endpointSessionIsClosed = Completer();
        delayedNeverListenedInputStreamCompleter.future.then(
          (Session session) => session.addWillCloseListener(
            (_) => endpointSessionIsClosed.complete(),
          ),
        );

        await server.start();
        webSocket = await WebSocket.connect(
          Uri.parse(serverMethodWebsocketUrl),
        );

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: method,
            args: {'delay': 20},
            connectionId: connectionId,
            inputStreams: ['stream'],
          ),
        );
      });

      tearDown(() async {
        await webSocket.tryClose();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when a CloseMethodStreamCommand is sent then endpoint session is closed',
        () async {
          webSocket.textEvents.listen((event) {
            // Listen to the to keep it open.
          });

          webSocket.sendText(
            CloseMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              connectionId: connectionId,
              reason: CloseReason.done,
            ),
          );

          await expectLater(
            endpointSessionIsClosed.future
                .timeout(Duration(seconds: 10))
                .catchError(
                  (error) => fail('Endpoint session was never closed.'),
                ),
            completes,
          );
        },
      );
    },
  );

  group(
    'Given a single method stream connection to an endpoint that has an input stream that is paused',
    () {
      var server = IntegrationTestServer.create();
      late WebSocket webSocket;
      var endpoint = 'methodStreaming';
      var method = 'delayedPausedInputStream';
      var connectionId = const Uuid().v4obj();
      late Completer endpointSessionIsClosed;

      setUp(() async {
        var delayedPausedInputStreamCompleter = Completer<Session>();
        MethodStreaming.delayedPausedInputStreamCompleter =
            delayedPausedInputStreamCompleter;

        endpointSessionIsClosed = Completer();
        delayedPausedInputStreamCompleter.future.then(
          (Session session) => session.addWillCloseListener(
            (_) => endpointSessionIsClosed.complete(),
          ),
        );

        await server.start();
        webSocket = await WebSocket.connect(
          Uri.parse(serverMethodWebsocketUrl),
        );

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: method,
            args: {'delay': 20},
            connectionId: connectionId,
            inputStreams: ['stream'],
          ),
        );
      });

      tearDown(() async {
        await webSocket.tryClose();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when a CloseMethodStreamCommand is sent then endpoint session is closed',
        () async {
          webSocket.textEvents.listen((event) {
            // Listen to the to keep it open.
          });

          webSocket.sendText(
            CloseMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              connectionId: connectionId,
              reason: CloseReason.done,
            ),
          );

          await expectLater(
            endpointSessionIsClosed.future
                .timeout(Duration(seconds: 10))
                .catchError(
                  (error) => fail('Endpoint session was never closed.'),
                ),
            completes,
          );
        },
      );
    },
  );

  group(
    'Given a method stream connection to an endpoint that returns true if input stream has error',
    () {
      var endpoint = 'methodStreaming';
      var method = 'didInputStreamHaveError';

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

      group('when input stream is closed with error close reason', () {
        late Completer<bool> endpointResponse;
        late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
        TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

        var inputParameter = 'stream';
        var connectionId = const Uuid().v4obj();

        setUp(() async {
          endpointResponse = Completer<bool>();
          closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
          var streamOpened = Completer<void>();

          testCompleterTimeout.start({
            'endpointResponse': endpointResponse,
            'closeMethodStreamCommand': closeMethodStreamCommand,
            'streamOpened': streamOpened,
          });

          webSocket.textEvents.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              server.serializationManager,
            );
            ;
            if (message is OpenMethodStreamResponse) {
              streamOpened.complete();
            } else if (message is CloseMethodStreamCommand &&
                message.parameter == null) {
              closeMethodStreamCommand.complete(message);
            } else if (message is MethodStreamMessage) {
              endpointResponse.complete(message.object as bool);
            }
          });

          webSocket.sendText(
            OpenMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              args: {},
              connectionId: connectionId,
              inputStreams: [inputParameter],
            ),
          );

          await streamOpened.future;
          assert(
            streamOpened.isCompleted == true,
            'Failed to open method stream with server',
          );

          webSocket.sendText(
            CloseMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              parameter: inputParameter,
              connectionId: connectionId,
              reason: CloseReason.error,
            ),
          );
        });

        tearDown(() => testCompleterTimeout.cancel());

        test('then method returns true.', () async {
          endpointResponse.future.catchError((error) {
            fail('Failed to receive method response from server.');
          });

          await expectLater(
            endpointResponse.future,
            completion(true),
            reason: 'Invalid return value from endpoint.',
          );
        });
      });
    },
  );
}

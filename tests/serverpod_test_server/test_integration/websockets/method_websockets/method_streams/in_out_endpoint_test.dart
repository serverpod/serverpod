import 'dart:async';

import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import '../../websocket_extensions.dart';

void main() {
  group(
    'Given a method stream connection to an endpoint that returns first stream value in',
    () {
      var endpoint = 'methodStreaming';
      var method = 'intReturnFromStream';

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

      group('when a value is passed in', () {
        late Completer<int> endpointResponse;
        late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
        late Completer<CloseMethodStreamCommand>
        closeMethodStreamParameterCommand;
        TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();
        var inputValue = 2;

        var inputParameter = 'stream';
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

          webSocket.textEvents.listen((event) {
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
              endpointResponse.complete(message.object as int);
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
            MethodStreamMessage.buildMessage(
              endpoint: endpoint,
              method: method,
              parameter: inputParameter,
              connectionId: connectionId,
              object: inputValue,
              serializationManager: server.serializationManager,
            ),
          );
        });

        tearDown(() => testCompleterTimeout.cancel());

        test('then received value matches input value.', () async {
          endpointResponse.future.catchError((error) {
            fail('Failed to receive response from server.');
          });

          await expectLater(
            endpointResponse.future,
            completion(inputValue),
            reason: 'Invalid return value from endpoint.',
          );
        });

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
                    'Failed to receive CloseMethodStreamCommand from server for input parameter.',
                  );
                })
                .then((message) {
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
          },
        );
      });
    },
  );

  group(
    'Given a method stream connection to an endpoint that streams list of ints based on input parameter',
    () {
      var endpoint = 'methodStreaming';
      var method = 'intStreamFromValue';

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

      group('when input value 4 is passed in', () {
        late List<int> endpointResponses;
        late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
        TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();
        var inputValue = 4;

        var connectionId = const Uuid().v4obj();

        setUp(() async {
          endpointResponses = [];
          closeMethodStreamCommand = Completer<CloseMethodStreamCommand>();
          var streamOpened = Completer<void>();

          testCompleterTimeout.start({
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
            } else if (message is CloseMethodStreamCommand) {
              closeMethodStreamCommand.complete(message);
            } else if (message is MethodStreamMessage) {
              endpointResponses.add(message.object as int);
            }
          });

          webSocket.sendText(
            OpenMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              args: {'value': inputValue},
              connectionId: connectionId,
              inputStreams: [],
            ),
          );

          await streamOpened.future;
          assert(
            streamOpened.isCompleted == true,
            'Failed to open method stream with server',
          );
        });

        tearDown(() => testCompleterTimeout.cancel());

        test('then received values match sent values.', () async {
          closeMethodStreamCommand.future.catchError((error) {
            fail('Server failed to close the output stream.');
          });
          await expectLater(closeMethodStreamCommand.future, completes);

          expect(
            endpointResponses,
            List.generate(inputValue, (index) => index),
          );
        });

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
      });
    },
  );

  group(
    'Given a method stream connection to an endpoint that echoes the input int stream',
    () {
      var endpoint = 'methodStreaming';
      var method = 'intEchoStream';

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

      group('when a stream of values are passed in', () {
        late Completer<CloseMethodStreamCommand> closeMethodStreamCommand;
        TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();
        var inputValues = List.generate(4, (index) => index);
        late List<int> endpointResponses;

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

          webSocket.textEvents.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              server.serializationManager,
            );
            ;
            if (message is OpenMethodStreamResponse) {
              streamOpened.complete();
            } else if (message is CloseMethodStreamCommand) {
              closeMethodStreamCommand.complete(message);
            } else if (message is MethodStreamMessage) {
              endpointResponses.add(message.object as int);
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

          for (var inputValue in inputValues)
            webSocket.sendText(
              MethodStreamMessage.buildMessage(
                endpoint: endpoint,
                method: method,
                parameter: inputParameter,
                connectionId: connectionId,
                object: inputValue,
                serializationManager: server.serializationManager,
              ),
            );

          webSocket.sendText(
            CloseMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              parameter: inputParameter,
              connectionId: connectionId,
              reason: CloseReason.done,
            ),
          );
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
      });
    },
  );
}

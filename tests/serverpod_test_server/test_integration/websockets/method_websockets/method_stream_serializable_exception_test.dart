import 'dart:async';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group(
      'Given a method stream connection to an endpoint that returns true if input stream has serializable exception error',
      () {
    var endpoint = 'methodStreaming';
    var method = 'didInputStreamHaveSerializableExceptionError';

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

    group('when serializable exception is passed to stream', () {
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

        webSocket.stream.listen((event) {
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

        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: method,
          args: {},
          connectionId: connectionId,
        ));

        await streamOpened.future;
        assert(streamOpened.isCompleted == true,
            'Failed to open method stream with server');

        var serializableException = ExceptionWithData(
          message: 'Throwing an exception',
          creationDate: DateTime.now(),
          errorFields: [
            'first line error',
            'second line error',
          ],
          someNullableField: 1,
        );
        webSocket.sink.add(MethodStreamSerializableException.buildMessage(
          endpoint: endpoint,
          method: method,
          parameter: inputParameter,
          connectionId: connectionId,
          object: serializableException,
          serializationManager: server.serializationManager,
        ));
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
  });
}

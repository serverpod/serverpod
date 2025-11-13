import 'dart:async';

import 'package:serverpod_test_server/src/endpoints/method_streaming.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_completer_timeout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import '../../websocket_extensions.dart';

void main() {
  group(
    'Given a method stream connection to an endpoint that continuously yields values with a small delay',
    () {
      var endpoint = 'methodStreaming';
      var method = 'neverEndingStreamWithDelay';

      late Serverpod server;
      late WebSocket webSocket;
      late Completer neverEndingStreamIsCanceled;
      TestCompleterTimeout testCompleterTimeout = TestCompleterTimeout();

      var connectionId = const Uuid().v4obj();

      setUp(() async {
        var neverEndingStreamControllerCompleter =
            Completer<StreamController<int>>();
        MethodStreaming.neverEndingStreamController =
            neverEndingStreamControllerCompleter;

        neverEndingStreamIsCanceled = Completer();
        neverEndingStreamControllerCompleter.future.then((
          StreamController controller,
        ) {
          controller.onCancel = () => neverEndingStreamIsCanceled.complete();
        });

        server = IntegrationTestServer.create();
        await server.start();
        webSocket = await WebSocket.connect(
          Uri.parse(serverMethodWebsocketUrl),
        );
        var streamOpened = Completer<void>();

        testCompleterTimeout.start({
          'streamOpened': streamOpened,
          'neverEndingStreamIsCanceled': neverEndingStreamIsCanceled,
        });

        webSocket.textEvents.listen((event) {
          var message = WebSocketMessage.fromJsonString(
            event,
            server.serializationManager,
          );
          ;
          if (message is OpenMethodStreamResponse) {
            streamOpened.complete();
          }
        });

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: method,
            args: {'millisecondsDelay': 100},
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

      tearDown(() async {
        testCompleterTimeout.cancel();
        await server.shutdown(exitProcess: false);
        await webSocket.tryClose();
      });

      test(
        'when method stream is closed then never ending stream is canceled.',
        () async {
          webSocket.sendText(
            CloseMethodStreamCommand.buildMessage(
              endpoint: endpoint,
              method: method,
              connectionId: connectionId,
              reason: CloseReason.done,
            ),
          );

          await expectLater(neverEndingStreamIsCanceled.future, completes);
        },
      );
    },
  );
}

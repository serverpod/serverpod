import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/test.dart';

class TestConnectivityMonitor extends ConnectivityMonitor {
  void notifyConnectionLost() {
    notifyListeners(false);
  }
}

void main() {
  group(
    'Given client that disconnects on lost internet connection with an open streaming method connection',
    () {
      var testConnectivityMonitor = TestConnectivityMonitor();
      var client = Client(
        serverUrl,
        authenticationKeyManager: TestAuthKeyManager(),
        disconnectStreamsOnLostInternetConnection: true,
      );

      client.connectivityMonitor = testConnectivityMonitor;
      test(
        'when connectivity monitor reports connection is lost then stream is closed with exception.',
        () async {
          var messageReceived = Completer();
          var streamErrorCompleter = Completer<Object>();
          var inputStream = StreamController<int>();
          var stream = client.methodStreaming.intEchoStream(inputStream.stream);

          stream.listen(
            (event) {
              messageReceived.complete();
            },
            onError: (e, s) {
              streamErrorCompleter.complete(e);
            },
          );
          inputStream.sink.add(42);
          await messageReceived.future;

          testConnectivityMonitor.notifyConnectionLost();

          await expectLater(streamErrorCompleter.future, completes);
          var error = await streamErrorCompleter.future;
          expect(error, isA<WebSocketClosedException>());
        },
      );
    },
  );

  group(
    'Given client that does not disconnects on lost internet connection with an open streaming method connection',
    () {
      var testConnectivityMonitor = TestConnectivityMonitor();
      var client = Client(
        serverUrl,
        authenticationKeyManager: TestAuthKeyManager(),
        disconnectStreamsOnLostInternetConnection: false,
      );
      client.connectivityMonitor = testConnectivityMonitor;

      tearDown(() => client.closeStreamingMethodConnections(exception: null));

      test(
        'when connectivity monitor reports connection is lost then stream can still be used.',
        () async {
          var messageReceived = Completer();
          var inputStream = StreamController<int>();
          var stream = client.methodStreaming.intEchoStream(inputStream.stream);

          stream.listen((event) {
            messageReceived.complete();
          });
          inputStream.sink.add(42);
          await messageReceived.future;

          testConnectivityMonitor.notifyConnectionLost();

          messageReceived = Completer();
          inputStream.sink.add(42);
          expectLater(messageReceived.future, completes);
        },
      );
    },
  );
}

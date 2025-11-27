// Add tests for when passing an input parameter to the stream.
import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    serverUrl,
    authenticationKeyManager: TestAuthKeyManager(),
  );

  test(
    'Given multiple streaming method connections when one is finished then the open method stream can still transmit messages.',
    () async {
      var keepAliveStreamComplete = Completer();
      var closeStreamComplete = Completer();
      var keepAliveInputStream = StreamController<int>();
      var keepAliveStream = client.methodStreaming.intEchoStream(
        keepAliveInputStream.stream,
      );
      var closeStreamInputStream = StreamController<int>();
      var closeStream = client.methodStreaming.intEchoStream(
        closeStreamInputStream.stream,
      );

      closeStream.listen(
        (event) {
          // Do nothing
        },
        onDone: () {
          closeStreamComplete.complete();
        },
      );

      var received = <int>[];
      keepAliveStream.listen(
        (event) {
          received.add(event);
        },
        onDone: () {
          keepAliveStreamComplete.complete();
        },
      );

      await closeStreamInputStream.close();
      await expectLater(closeStreamComplete.future, completes);

      keepAliveInputStream.add(42);
      await keepAliveInputStream.close();
      await expectLater(keepAliveStreamComplete.future, completes);

      expect(received, [42]);
    },
  );
}

import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  // Creates a client with a URL that doesn't exist
  // This will cause an WebSocketConnectException when the client tries to
  // connect to the server.
  var client = Client('http://localhost:123456789/');

  test(
    'Given method call with stream response when exception occurs during call setup then exception is received in stream.',
    () async {
      var stream = Stream<int>.fromIterable([1, 2, 3]);
      var methodStream = client.methodStreaming.intEchoStream(stream);

      var errorCompleter = Completer<dynamic>();
      methodStream.listen(
        (event) {},
        onError: (e) => errorCompleter.complete(e),
      );

      await expectLater(errorCompleter.future, completes);
      var error = await errorCompleter.future;
      expect(error, isA<WebSocketConnectException>());
    },
  );

  test(
    'Given method call with future response when exception occurs during call setup then future is resolved with exception.',
    () async {
      var stream = Stream<int>.fromIterable([1, 2, 3]);

      await expectLater(
        client.methodStreaming.intReturnFromStream(stream),
        throwsA(isA<WebSocketConnectException>()),
      );
    },
  );
}

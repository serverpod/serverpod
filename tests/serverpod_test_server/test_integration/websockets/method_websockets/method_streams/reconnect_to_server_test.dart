import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart' as c;
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  late Serverpod server;
  late c.Client client;

  setUp(() async {
    server = IntegrationTestServer.create();
    await server.start();

    client = c.Client(
      serverUrl,
      authenticationKeyManager: TestAuthKeyManager(),
    );
  });

  tearDown(() async {
    await server.shutdown(exitProcess: false);
    client.close();
  });

  test('Given a connected streaming method '
      'when server is restarted '
      'then streaming method can successfully reconnect.', () async {
    // This method constantly yields a new integer every [delay] milliseconds.
    var outStream = client.methodStreaming.neverEndingStreamWithDelay(100);
    {
      var valueReceivedCompleter = Completer<int>();
      var errorReceivedCompleter = Completer<dynamic>();
      outStream.listen(
        (event) {
          if (valueReceivedCompleter.isCompleted) {
            return;
          }
          valueReceivedCompleter.complete(event);
        },
        onError: (e) {
          errorReceivedCompleter.complete(e);
        },
      );

      await valueReceivedCompleter.future;
      await server.shutdown(exitProcess: false);
      await errorReceivedCompleter.future;
      await server.start();
    }

    outStream = client.methodStreaming.neverEndingStreamWithDelay(100);
    var value = outStream.first;
    await expectLater(value, completes);
  });
}

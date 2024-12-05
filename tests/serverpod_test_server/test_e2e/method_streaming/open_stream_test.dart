@Timeout(Duration(minutes: 5))

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a client '
      'when calling an endpoint multiple times in quick succession '
      'then all streams complete successfully', () async {
    var client = Client(serverUrl);
    var numMessages = 1000;
    var stream;
    for (var i = 0; i < 10; i++) {
      stream = client.methodStreaming.intStreamFromValue(numMessages);
    }

    await expectLater(stream.last, completes);
  });
}

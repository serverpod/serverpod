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
    List<Future> streamCompleteFutures = [];
    for (var i = 0; i < 10; i++) {
      var stream = client.methodStreaming.intStreamFromValue(numMessages);
      streamCompleteFutures.add(stream.last);
    }

    for (var future in streamCompleteFutures) {
      await expectLater(future, completes);
    }
  });
}

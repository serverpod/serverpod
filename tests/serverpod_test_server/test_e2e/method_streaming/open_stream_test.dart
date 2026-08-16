import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  test('Given a client '
      'when calling an endpoint multiple times in quick succession '
      'then all streams complete successfully', () async {
    var client = Client(serverUrl);
    var numMessages = 1000;
    List<Future> streamCompleteFutures = [];
    for (var i = 0; i < 10; i++) {
      var stream = client.methodStreaming.intStreamFromValue(numMessages);
      streamCompleteFutures.add(stream.last);
    }

    await [
      for (var future in streamCompleteFutures) expectLater(future, completes),
    ].wait;
  });

  test('Given multiple method streaming connections to the same endpoint '
      'when streams are listened, paused and resumed '
      'then all streams complete successfully', () async {
    var client = Client(serverUrl);
    var numMessages = 1000;
    List<Future> streamCompleteFutures = [];
    for (var i = 0; i < 10; i++) {
      var streamIsComplete = Completer();
      streamCompleteFutures.add(streamIsComplete.future);

      var stream = client.methodStreaming.intStreamFromValue(numMessages);
      var beenPaused = false;
      late StreamSubscription<int> subscription;
      subscription = stream.listen(
        (data) async {
          if (!beenPaused) {
            subscription.pause();
            beenPaused = true;
            await Future.delayed(Duration(milliseconds: 100), () {
              subscription.resume();
            });
          }
        },
        onDone: () => streamIsComplete.complete(),
      );
    }

    await [
      for (var future in streamCompleteFutures) expectLater(future, completes),
    ].wait;
  });
}

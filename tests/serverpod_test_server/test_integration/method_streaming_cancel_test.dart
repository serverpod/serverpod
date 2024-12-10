import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given call to MethodStreamingEndpoint',
    (sessionBuilder, endpoints) {
      test(
          'when calling an endpoint returning a non-broadcast stream and cancelling '
          'then will cancel', () async {
        var stream =
            endpoints.methodStreaming.intStreamFromValue(sessionBuilder, 1);
        var subscription = stream.listen((event) {});

        await expectLater(subscription.cancel(), completes);
      });

      test(
          'when calling an endpoint returning a broadcast stream and cancelling '
          'then it should cancel and trigger the onCancel hook on the stream controller',
          () async {
        var wasStreamCancelled = endpoints.methodStreaming
            .wasBroadcastStreamCanceled(sessionBuilder);

        var stream =
            endpoints.methodStreaming.getBroadcastStream(sessionBuilder);
        // Wait for the stream to be created, otherwise cancel is called before creation
        await flushEventQueue();

        var subscription = stream.listen((event) {});
        await subscription.cancel();

        await expectLater(
          wasStreamCancelled,
          completion(true),
        );
      });

      test(
          'when calling an endpoint returning a broadcast stream and cancelling '
          'then it should close the session and call its will close listener',
          () async {
        var wasSessionWillCloseListenerCalled = endpoints.methodStreaming
            .wasSessionWillCloseListenerCalled(sessionBuilder);

        var stream =
            endpoints.methodStreaming.getBroadcastStream(sessionBuilder);
        // Wait for the stream to be created, otherwise cancel is called before creation
        await flushEventQueue();

        var subscription = stream.listen((event) {});
        await subscription.cancel();

        await expectLater(
          wasSessionWillCloseListenerCalled,
          completion(true),
        );
      });
    },
  );
}

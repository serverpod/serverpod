import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given call to MethodStreamingEndpoint',
    (endpoints, session) {
      test(
          'when calling an endpoint returning a non-broadcast stream and cancelling '
          'then will cancel', () async {
        var stream = endpoints.methodStreaming.intStreamFromValue(session, 1);
        var subscription = stream.listen((event) {});

        await expectLater(subscription.cancel(), completes);
      });

      test(
        'when calling an endpoint returning a broadcast stream and cancelling '
        'then will cancel',
        () async {
          var stream = endpoints.methodStreaming.getBroadcastStream(session);
          var subscription = stream.listen((event) {});

          await expectLater(subscription.cancel(), completes);
        },
      );
    },
    runMode: ServerpodRunMode.production,
  );
}

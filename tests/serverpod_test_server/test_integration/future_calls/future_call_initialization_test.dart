import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

class _FutureCallInitializer extends FutureCallInitializer {
  _FutureCallInitializer(this.completer);

  final Completer<String> completer;

  @override
  void initialize(FutureCallManager futureCallManager, String serverId) {
    completer.complete(serverId);
  }
}

class _Endpoint extends EndpointDispatch {
  _Endpoint(this.completer);

  final Completer<String> completer;

  @override
  FutureCallInitializer get futureCallInitializer =>
      _FutureCallInitializer(completer);

  @override
  void initializeEndpoints(Server server) {}
}

void main() {
  group(
    'Given a Serverpod with an EndpointDispatch containing a FutureCallInitializer',
    () {
      late Serverpod pod;
      late Completer<String> completer;

      setUp(() {
        completer = Completer();
        pod = IntegrationTestServer.create(endpoints: _Endpoint(completer));
      });

      test(
        'when pod is started then the future call initializer is invoked',
        () async {
          await pod.start();
          expectLater(completer.future, completes);
        },
      );
    },
  );
}

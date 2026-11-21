import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given an open session,', () {
    late Serverpod pod;
    late Session session;

    setUp(() async {
      pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
          database: null,
          runMode: ServerpodRunMode.development,
          healthCheckInterval: Duration.zero,
        ),
      );
      session = await pod.createSession(enableLogging: false);
    });

    tearDown(() async {
      await session.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when time passes, '
      'then the duration grows with the elapsed time.',
      () async {
        final stopwatch = Stopwatch()..start();
        final before = session.duration;

        await Future<void>.delayed(const Duration(milliseconds: 100));

        final after = session.duration;
        stopwatch.stop();

        expect(before, greaterThanOrEqualTo(Duration.zero));
        expect(after - before, greaterThanOrEqualTo(stopwatch.elapsed * 0.9));
        expect(after, lessThan(stopwatch.elapsed + const Duration(seconds: 1)));
      },
    );

    test(
      'when the duration is read repeatedly, '
      'then it never decreases.',
      () async {
        var previous = session.duration;
        for (var i = 0; i < 1000; i++) {
          final current = session.duration;
          expect(current, greaterThanOrEqualTo(previous));
          previous = current;
        }
      },
    );
  });
}

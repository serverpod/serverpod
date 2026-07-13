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

  group(
    'Given a Serverpod configured without a database, '
    'when a session accesses the database, ',
    () {
      late Serverpod pod;
      late InternalSession session;

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

      test('then a StateError is thrown.', () {
        expect(
          () => session.db,
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              'Database is not available in this session.',
            ),
          ),
        );
      });
    },
  );
}

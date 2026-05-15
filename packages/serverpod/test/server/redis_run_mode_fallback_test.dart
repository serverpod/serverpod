import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  RedisConfig unreachableRedis() => RedisConfig(
    enabled: true,
    host: '127.0.0.1',
    port: 1,
    requireSsl: false,
  );

  group(
    'Given Redis is enabled but unreachable in development run mode, '
    'when Serverpod completes startup, ',
    () {
      late Serverpod pod;

      setUp(() async {
        pod = Serverpod(
          [],
          internal.Protocol(),
          _EmptyEndpoints(),
          config: ServerpodConfig(
            apiServer: portZeroConfig,
            webServer: portZeroConfig,
            database: null,
            redis: unreachableRedis(),
            runMode: ServerpodRunMode.development,
            healthCheckInterval: Duration.zero,
          ),
        );

        await pod.start(runInGuardedZone: false);
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('then Redis controller is cleared.', () async {
        expect(pod.redisController, isNull);
      });
    },
  );

  group(
    'Given Redis is enabled but unreachable in production run mode, '
    'when Serverpod completes startup, ',
    () {
      late Serverpod pod;

      setUp(() async {
        pod = Serverpod(
          [],
          internal.Protocol(),
          _EmptyEndpoints(),
          config: ServerpodConfig(
            apiServer: portZeroConfig,
            webServer: portZeroConfig,
            database: null,
            redis: unreachableRedis(),
            runMode: ServerpodRunMode.production,
            healthCheckInterval: Duration.zero,
          ),
        );

        await pod.start(runInGuardedZone: false);
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('then Redis controller remains configured.', () async {
        expect(pod.redisController, isNotNull);
      });
    },
  );
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}

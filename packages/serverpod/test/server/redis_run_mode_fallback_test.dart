import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/local_cache.dart';
import 'package:serverpod/src/cache/redis_cache.dart';
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
          EmptyEndpoints(),
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

      test('then global cache falls back to local storage.', () async {
        expect(pod.caches.global, isA<LocalCache>());
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
          EmptyEndpoints(),
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

      test('then global cache stays Redis-backed.', () async {
        expect(pod.caches.global, isA<RedisCache>());
      });
    },
  );
}

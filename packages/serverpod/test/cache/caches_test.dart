import 'package:serverpod/src/cache/caches.dart';
import 'package:serverpod/src/cache/local_cache.dart';
import 'package:serverpod/src/cache/redis_cache.dart';
import 'package:serverpod/src/generated/protocol.dart';
import 'package:serverpod/src/redis/controller.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  final apiServer = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  final config = ServerpodConfig(
    apiServer: apiServer,
    webServer: apiServer,
    serverId: 'test-server',
  );

  final serializationManager = Protocol();

  group(
    'Given a Caches collection with Redis configured, '
    'when global cache is accessed, ',
    () {
      late Caches caches;

      setUp(() {
        caches = Caches(
          serializationManager,
          config,
          config.serverId,
          RedisController(
            host: '127.0.0.1',
            port: 6379,
            requireSsl: false,
          ),
        );
      });

      test(
        'then global uses Redis-backed cache.',
        () {
          expect(caches.global, isA<RedisCache>());
        },
      );
    },
  );

  group(
    'Given a Caches collection without Redis, '
    'when global cache is accessed, ',
    () {
      late Caches caches;

      setUp(() {
        caches = Caches(
          serializationManager,
          config,
          config.serverId,
          null,
        );
      });

      test(
        'then global uses a dedicated local cache.',
        () {
          expect(caches.global, isA<LocalCache>());
        },
      );

      test(
        'then global cache is not the same instance as the existing local caches.',
        () {
          expect(caches.global, isNot(same(caches.local)));
          expect(caches.global, isNot(same(caches.localPrio)));
        },
      );

      test(
        'when values are stored on local and global under the same key, '
        'then reads stay isolated per cache.',
        () async {
          const key = 'shared-key';
          await caches.local.put(key, 1);
          await caches.global.put(key, 2);

          expect(await caches.local.get<int>(key), 1);
          expect(await caches.global.get<int>(key), 2);
        },
      );
    },
  );

  group(
    'Given a Caches collection without Redis with entries in local and global, '
    'when clear is called, ',
    () {
      late Caches caches;

      setUp(() async {
        caches = Caches(
          serializationManager,
          config,
          config.serverId,
          null,
        );

        await caches.local.put('k', 1);
        await caches.global.put('k', 2);
      });

      test(
        'then both primary local and fallback global caches are emptied.',
        () async {
          await caches.clear();

          expect(await caches.local.get<int>('k'), isNull);
          expect(await caches.global.get<int>('k'), isNull);
        },
      );
    },
  );
}

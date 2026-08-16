import 'package:serverpod/src/cache/redis_cache.dart';
import 'package:serverpod/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  final throwsRedisNotEnabled = throwsA(
    isA<StateError>().having(
      (e) => e.message,
      'message',
      'Redis is not enabled for this Serverpod instance.',
    ),
  );

  group('Given a RedisCache without a Redis controller, ', () {
    late RedisCache cache;

    setUp(() {
      cache = RedisCache(Protocol(), null);
    });

    test(
      'when the redisController getter is accessed '
      'then a StateError is thrown.',
      () {
        expect(() => cache.redisController, throwsRedisNotEnabled);
      },
    );

    test(
      'when clear is called then a StateError is thrown.',
      () async {
        await expectLater(cache.clear(), throwsRedisNotEnabled);
      },
    );

    test(
      'when containsKey is called then a StateError is thrown.',
      () async {
        await expectLater(cache.containsKey('key'), throwsRedisNotEnabled);
      },
    );

    test(
      'when get is called then a StateError is thrown.',
      () async {
        await expectLater(cache.get<int>('key'), throwsRedisNotEnabled);
      },
    );

    test(
      'when put is called then a StateError is thrown.',
      () async {
        await expectLater(cache.put('key', 1), throwsRedisNotEnabled);
      },
    );

    test(
      'when invalidateKey is called then a StateError is thrown.',
      () async {
        await expectLater(cache.invalidateKey('key'), throwsRedisNotEnabled);
      },
    );
  });
}

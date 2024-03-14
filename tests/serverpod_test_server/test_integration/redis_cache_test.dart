import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/redis_cache.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  var cache = RedisCache(Protocol(), session.serverpod.redisController);

  tearDown(() async => await cache.clear());

  test('Put and get object', () async {
    var entry = SimpleData(num: 0);

    await cache.put('entry', entry);
    var retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved!.num, equals(0));

    retrieved = await cache.get<SimpleData>('missing');
    expect(retrieved, isNull);

    retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved!.num, equals(0));
  });

  test('Put and get object with lifetime', () async {
    var entry = SimpleData(num: 0);

    await cache.put('entry', entry,
        lifetime: const Duration(milliseconds: 100));
    var retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved!.num, equals(0));

    await Future.delayed(const Duration(milliseconds: 110));
    retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved, isNull);
  });

  test('Put multiple with same key', () async {
    var entryA = SimpleData(num: 0);
    var entryB = SimpleData(num: 1);

    await cache.put('entry', entryA);
    await cache.put('entry', entryB);

    var retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved!.num, equals(1));
  });

  test('Invalidate key', () async {
    await cache.put('entry:1337', SimpleData(num: 1337));

    await cache.invalidateKey('entry:1337');
    var retrieved = await cache.get<SimpleData>('entry:1337');
    expect(retrieved, isNull);
  });

  test('get object not in cache then null is returned', () async {
    var retrieved = await cache.get<SimpleData>('invalidEntry');
    expect(retrieved, isNull);
  });

  group('get object not in cache when cacheMissHandler is specified', () {
    const cacheKey = 'testKey';
    SimpleData? retrieved;
    setUp(() async {
      retrieved = await cache.get(
        cacheKey,
        CacheMissHandler(() async => SimpleData(num: 1337)),
      );
    });

    test('then object from cacheMissHandler is returned', () {
      expect(retrieved?.num, equals(1337));
    });

    test('then cacheMissHandler value is retrievable from the cache', () async {
      var value = await cache.get<SimpleData>(cacheKey);
      expect(value?.num, equals(1337));
    });
  });

  group('get object already in cache when cacheMissHandler is specified', () {
    const cacheKey = 'testKey';
    SimpleData? retrieved;
    setUp(() async {
      await cache.put(cacheKey, SimpleData(num: 1));
      retrieved = await cache.get(
        cacheKey,
        CacheMissHandler(() async => SimpleData(num: 1337)),
      );
    });

    test('then object already in cache is returned', () {
      expect(retrieved?.num, equals(1));
    });

    test('then object already in cache is still retrievable from the cache',
        () async {
      var value = await cache.get<SimpleData>(cacheKey);
      expect(value?.num, equals(1));
    });
  });
}

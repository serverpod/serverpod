import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/local_cache.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

const cacheMaxSize = 10;

void main() {
  var cache = LocalCache(cacheMaxSize, Protocol());

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

    expect(cache.localSize, equals(1));
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

    expect(cache.localSize, equals(0));
  });

  test('Put multiple with same key', () async {
    var entryA = SimpleData(num: 0);
    var entryB = SimpleData(num: 1);

    await cache.put('entry', entryA);
    await cache.put('entry', entryB);

    var retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved!.num, equals(1));

    expect(cache.localSize, equals(1));
  });

  test('Cache overflow', () async {
    var numEntries = cacheMaxSize * 2;

    for (var i = 0; i < numEntries; i++) {
      var entry = SimpleData(num: i);
      await cache.put('entry:$i', entry);
    }

    expect(cache.localSize, equals(cacheMaxSize));

    var first = await cache.get<SimpleData>('entry:0');
    expect(first, isNull);

    var last = await cache.get<SimpleData>('entry:${numEntries - 1}');
    expect(last!.num, equals(numEntries - 1));
  });

  test('Invalidate keys', () async {
    for (var i = 0; i < cacheMaxSize; i++) {
      var entry = SimpleData(num: i);
      await cache.put('entry:$i', entry);
    }

    var middleId = cacheMaxSize ~/ 4;

    var retrieved = await cache.get<SimpleData>('entry:$middleId');
    expect(retrieved!.num, equals(middleId));

    await cache.invalidateKey('entry:$middleId');
    retrieved = await cache.get<SimpleData>('entry:$middleId');
    expect(retrieved, isNull);

    expect(cache.localSize, equals(cacheMaxSize - 1));
  });

  test('Invalidate group', () async {
    for (var i = 0; i < cacheMaxSize ~/ 2; i++) {
      var entry = SimpleData(num: i);
      await cache.put('entry:$i', entry, group: 'group:0');
    }
    for (var i = cacheMaxSize ~/ 2; i < cacheMaxSize; i++) {
      var entry = SimpleData(num: i);
      await cache.put('entry:$i', entry, group: 'group:1');
    }

    expect(cache.localSize, equals(cacheMaxSize));

    await cache.invalidateGroup('group:0');
    expect(cache.localSize, equals(cacheMaxSize ~/ 2));

    var retrieved = await cache.get<SimpleData>('entry:0');
    expect(retrieved, isNull);

    retrieved = await cache.get<SimpleData>('entry:${cacheMaxSize - 1}');
    expect(retrieved!.num, equals(cacheMaxSize - 1));

    await cache.invalidateGroup('group:1');
    expect(cache.localSize, equals(0));

    await cache.invalidateGroup('group:1');
    expect(cache.localSize, equals(0));
  });

  test('Invalidate key then group', () async {
    for (var i = 0; i < cacheMaxSize ~/ 2; i++) {
      var entry = SimpleData(num: i);
      await cache.put('entry:$i', entry, group: 'group:0');
    }
    for (var i = cacheMaxSize ~/ 2; i < cacheMaxSize; i++) {
      var entry = SimpleData(num: i);
      await cache.put('entry:$i', entry, group: 'group:1');
    }

    await cache.invalidateKey('entry:0');
    var retrieved = await cache.get<SimpleData>('entry:0');
    expect(retrieved, isNull);

    retrieved = await cache.get<SimpleData>('entry:1');
    expect(retrieved!.num, equals(1));

    await cache.invalidateGroup('group:0');

    expect(cache.localSize, equals(cacheMaxSize ~/ 2));

    for (var i = cacheMaxSize ~/ 2; i < cacheMaxSize; i++) {
      await cache.invalidateKey('entry:$i');
    }

    expect(cache.localSize, equals(0));
  });

  test('get object not in cache then null is returned', () async {
    var retrieved = await cache.get<SimpleData>('invalidEntry');
    expect(retrieved, isNull);
  });

  group('get object not in cache when cache miss handler is specified', () {
    const cacheKey = 'testKey';
    SimpleData? retrieved;
    setUp(() async {
      retrieved = await cache.get(
        cacheKey,
        CacheMissHandler(() async => SimpleData(num: 1337)),
      );
    });
    test('then object from cache miss handler is returned', () {
      expect(retrieved?.num, equals(1337));
    });

    test('then cache miss handler value is retrievable from the cache',
        () async {
      var value = await cache.get<SimpleData>(cacheKey);
      expect(value?.num, equals(1337));
    });
  });

  group('get object already in cache when cache miss handler is specified', () {
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

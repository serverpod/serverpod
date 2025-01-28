import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/local_cache.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

const cacheMaxSize = 10;

void main() {
  late LocalCache cache;
  setUp(() {
    cache = LocalCache(cacheMaxSize, Protocol());
  });

  tearDown(() async => await cache.clear());

  test(
      'Given an entry was `put` to the cache, when it is accessed, then it can be read',
      () async {
    const key = 'entry';
    var entry = SimpleData(num: 0);

    await cache.put(key, entry);

    var retrieved = await cache.get<SimpleData>(key);
    expect(retrieved?.num, equals(0));
  });

  test(
      'Given an entry was written to the cache, when the size is checked, then it will be 1',
      () async {
    var entry = SimpleData(num: 0);

    await cache.put('entry', entry);

    expect(cache.localSize, equals(1));
  });

  test(
      'Given an empty cache, when any item is accessed, then it will return `null`',
      () async {
    var retrieved = await cache.get<SimpleData>('missing');

    expect(retrieved, isNull);
  });

  test(
      'Given a cache entry with a lifetime, when it is accessed before it has expired, then the cache will return the item',
      () async {
    const key = 'entry_lifetime_1';
    var entry = SimpleData(num: 0);

    await cache.put(
      key,
      entry,
      lifetime: const Duration(milliseconds: 100),
    );

    var retrieved = await cache.get<SimpleData>(key);
    expect(retrieved?.num, equals(0));
  });

  test(
      'Given a cache entry with a lifetime, when it is accessed after it has expired, then the cache will return `null`',
      () async {
    const key = 'entry_lifetime_2';
    var entry = SimpleData(num: 0);

    await cache.put(
      key,
      entry,
      lifetime: const Duration(milliseconds: 100),
    );

    await Future.delayed(const Duration(milliseconds: 110));

    var retrieved = await cache.get<SimpleData>(key);
    expect(retrieved, isNull);
  });

  test(
      'Given a cache where multiple writes happened for the same key, when that key is accessed, then the latest value will be returned',
      () async {
    final key = 'multi_write';
    var entryA = SimpleData(num: 0);
    var entryB = SimpleData(num: 1);

    await cache.put(key, entryA);
    await cache.put(key, entryB);

    var retrieved = await cache.get<SimpleData>(key);
    expect(retrieved?.num, equals(1));
  });

  test(
      'Given a cache where more entries than it should hold are added, when its size is checked, then it will only contain the latest \$CACHE_SIZE items',
      () async {
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

  test(
      'Given a cache with various items, when a single key is invalidated, then it will return `null` for that key while retaining all others',
      () async {
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

    for (var i = 0; i < cacheMaxSize; i++) {
      if (i == middleId) {
        continue;
      }

      retrieved = await cache.get<SimpleData>('entry:$i');
      expect(retrieved, isNotNull);
    }
  });

  test(
      'Given a cache with items in 2 groups, when a single group is invalidated, then it will loose all items associated with that group',
      () async {
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

  test(
      'Given a cache with an expired item, when `get` is invoked with a `cacheMissHandler`, then the `cacheMissHandler` will be invoked and the newly create value returned',
      () async {
    final key = 'obj1';

    await cache.put(
      key,
      SimpleData(num: 1),
      lifetime: Duration(milliseconds: 100),
    );

    await Future.delayed(const Duration(milliseconds: 200));

    var retrieved = await cache.get<SimpleData>(
      key,
      CacheMissHandler(
        () async => SimpleData(num: 2),
        lifetime: Duration(minutes: 10),
      ),
    );

    expect(retrieved?.num, 2);
  });

  test(
      'Given an empty cache, when simultaneous `get`s are executed for the same key, then only the `cacheMissHandler` of the first request will be invoked',
      () async {
    final key = 'value_to_be_computed';

    final completer = Completer<SimpleData>();

    final retrieved1Future = cache.get<SimpleData>(
      key,
      CacheMissHandler(
        () async => completer.future,
        lifetime: Duration(minutes: 10),
      ),
    );

    final retrieved2Future = cache.get<SimpleData>(
      key,
      CacheMissHandler(
        () async => throw '`cacheMissHandler` should not be called twice',
        lifetime: Duration(minutes: 10),
      ),
    );

    completer.complete(SimpleData(num: 100));

    expect((await retrieved1Future)?.num, 100);
    expect((await retrieved2Future)?.num, 100);
  });

  test(
      'Given an empty cache, when `get` is called with a `cacheMissHandler` returning an object, then that handler will be invoked to generate a new item to be stored in the cache and returned',
      () async {
    const cacheKey = 'testKey';

    var retrieved = await cache.get<SimpleData>(
      cacheKey,
      CacheMissHandler(() async => SimpleData(num: 1337)),
    );

    expect(retrieved?.num, equals(1337));

    var value = await cache.get<SimpleData>(cacheKey);
    expect(value?.num, equals(1337));
  });

  test(
      'Given an empty cache, when `get` is called with a `cacheMissHandler` returning null, then that handler will be invoked and `null` will be returned and nothing stored in the cache',
      () async {
    const cacheKey = 'testKey';

    var retrieved = await cache.get<SimpleData>(
      cacheKey,
      CacheMissHandler(() async => null),
    );

    expect(retrieved, isNull);

    var value = await cache.get<SimpleData>(cacheKey);
    expect(value, isNull);
  });

  test(
      'Given a cache containing an item with infinite lifetime, when that item is retrieved, then it will be returned and the `cacheMissHandler` will not be invoked',
      () async {
    const cacheKey = 'testKey';

    await cache.put(cacheKey, SimpleData(num: 1));
    var retrieved = await cache.get<SimpleData>(
      cacheKey,
      CacheMissHandler(() async => SimpleData(num: 1337)),
    );

    expect(retrieved?.num, equals(1));
  });
}

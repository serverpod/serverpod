import 'package:serverpod/src/cache/local_cache.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

const int cacheMaxSize = 10;

void main() {
  Protocol serializationManager;
  late LocalCache cache;

  setUp(() {
    serializationManager = Protocol();
    cache = LocalCache(cacheMaxSize, serializationManager);
  });

  test('Put and get object', () async {
    SimpleData entry = SimpleData(num: 0);

    await cache.put('entry', entry);
    SimpleData? retrieved = await cache.get('entry') as SimpleData?;
    expect(retrieved!.num, equals(0));

    retrieved = await cache.get('missing') as SimpleData?;
    expect(retrieved, isNull);

    retrieved = await cache.get('entry') as SimpleData?;
    expect(retrieved!.num, equals(0));

    expect(cache.localSize, equals(1));
  });

  test('Put and get object with lifetime', () async {
    SimpleData entry = SimpleData(num: 0);

    await cache.put('entry', entry,
        lifetime: const Duration(milliseconds: 100));
    SimpleData? retrieved = await cache.get('entry') as SimpleData?;
    expect(retrieved!.num, equals(0));

    await Future<void>.delayed(const Duration(milliseconds: 110));
    retrieved = await cache.get('entry') as SimpleData?;
    expect(retrieved, isNull);

    expect(cache.localSize, equals(0));
  });

  test('Put multiple with same key', () async {
    SimpleData entryA = SimpleData(num: 0);
    SimpleData entryB = SimpleData(num: 1);

    await cache.put('entry', entryA);
    await cache.put('entry', entryB);

    SimpleData? retrieved = await cache.get('entry') as SimpleData?;
    expect(retrieved!.num, equals(1));

    expect(cache.localSize, equals(1));
  });

  test('Cache overflow', () async {
    int numEntries = cacheMaxSize * 2;

    for (int i = 0; i < numEntries; i++) {
      SimpleData entry = SimpleData(num: i);
      await cache.put('entry:$i', entry);
    }

    expect(cache.localSize, equals(cacheMaxSize));

    SimpleData? first = await cache.get('entry:0') as SimpleData?;
    expect(first, isNull);

    SimpleData? last =
        await cache.get('entry:${numEntries - 1}') as SimpleData?;
    expect(last!.num, equals(numEntries - 1));
  });

  test('Invalidate keys', () async {
    for (int i = 0; i < cacheMaxSize; i++) {
      SimpleData entry = SimpleData(num: i);
      await cache.put('entry:$i', entry);
    }

    int middleId = cacheMaxSize ~/ 4;

    SimpleData? retrieved = await cache.get('entry:$middleId') as SimpleData?;
    expect(retrieved!.num, equals(middleId));

    await cache.invalidateKey('entry:$middleId');
    retrieved = await cache.get('entry:$middleId') as SimpleData?;
    expect(retrieved, isNull);

    expect(cache.localSize, equals(cacheMaxSize - 1));
  });

  test('Invalidate group', () async {
    for (int i = 0; i < cacheMaxSize ~/ 2; i++) {
      SimpleData entry = SimpleData(num: i);
      await cache.put('entry:$i', entry, group: 'group:0');
    }
    for (int i = cacheMaxSize ~/ 2; i < cacheMaxSize; i++) {
      SimpleData entry = SimpleData(num: i);
      await cache.put('entry:$i', entry, group: 'group:1');
    }

    expect(cache.localSize, equals(cacheMaxSize));

    await cache.invalidateGroup('group:0');
    expect(cache.localSize, equals(cacheMaxSize ~/ 2));

    SimpleData? retrieved = await cache.get('entry:0') as SimpleData?;
    expect(retrieved, isNull);

    retrieved = await cache.get('entry:${cacheMaxSize - 1}') as SimpleData?;
    expect(retrieved!.num, equals(cacheMaxSize - 1));

    await cache.invalidateGroup('group:1');
    expect(cache.localSize, equals(0));

    await cache.invalidateGroup('group:1');
    expect(cache.localSize, equals(0));
  });

  test('Invalidate key then group', () async {
    for (int i = 0; i < cacheMaxSize ~/ 2; i++) {
      SimpleData entry = SimpleData(num: i);
      await cache.put('entry:$i', entry, group: 'group:0');
    }
    for (int i = cacheMaxSize ~/ 2; i < cacheMaxSize; i++) {
      SimpleData entry = SimpleData(num: i);
      await cache.put('entry:$i', entry, group: 'group:1');
    }

    await cache.invalidateKey('entry:0');
    SimpleData? retrieved = await cache.get('entry:0') as SimpleData?;
    expect(retrieved, isNull);

    retrieved = await cache.get('entry:1') as SimpleData?;
    expect(retrieved!.num, equals(1));

    await cache.invalidateGroup('group:0');

    expect(cache.localSize, equals(cacheMaxSize ~/ 2));

    for (int i = cacheMaxSize ~/ 2; i < cacheMaxSize; i++) {
      await cache.invalidateKey('entry:$i');
    }

    expect(cache.localSize, equals(0));
  });
}

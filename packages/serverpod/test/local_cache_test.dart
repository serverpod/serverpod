import 'package:test/test.dart';
import 'package:serverpod/src/generated/protocol.dart';
import 'package:serverpod/src/cache/local_cache.dart';

const cacheMaxSize = 10;

void main() {
  Protocol serializationManager;
  late LocalCache cache;

  setUp(() {
    serializationManager = Protocol();
    cache = LocalCache(cacheMaxSize, serializationManager);
  });

  test('Put and get object', () async {
    var entry = FutureCallEntry(serverId: 0, name: 'test', time: DateTime.now());
    
    await cache.put('entry', entry);
    FutureCallEntry retrieved = await cache.get('entry') as FutureCallEntry;
    expect(retrieved.serverId, equals(0));

    retrieved = await cache.get('missing') as FutureCallEntry;
    expect(retrieved, isNull);

    retrieved = await cache.get('entry') as FutureCallEntry;
    expect(retrieved.serverId, equals(0));

    expect(cache.localSize, equals(1));
  });

  test('Put and get object with lifetime', () async {
    var entry = FutureCallEntry(serverId: 0, name: 'test', time: DateTime.now());

    await cache.put('entry', entry, lifetime: Duration(milliseconds: 100));
    FutureCallEntry retrieved = await cache.get('entry') as FutureCallEntry;
    expect(retrieved.serverId, equals(0));

    await Future.delayed(Duration(milliseconds: 110));
    retrieved = await cache.get('entry') as FutureCallEntry;
    expect(retrieved, isNull);

    expect(cache.localSize, equals(0));
  });

  test('Put multiple with same key', () async {
    var entryA = FutureCallEntry(serverId: 0, name: 'test', time: DateTime.now());
    var entryB = FutureCallEntry(serverId: 1, name: 'test', time: DateTime.now());

    await cache.put('entry', entryA);
    await cache.put('entry', entryB);

    FutureCallEntry retrieved = await cache.get('entry') as FutureCallEntry;
    expect(retrieved.serverId, equals(1));

    expect(cache.localSize, equals(1));
  });

  test('Cache overflow', () async {
    int numEntries = cacheMaxSize * 2;

    for (int i = 0; i < numEntries; i++) {
      var entry = FutureCallEntry(serverId: i, name: 'test', time: DateTime.now());
      await cache.put('entry:$i', entry);
    }

    expect(cache.localSize, equals(cacheMaxSize));

    FutureCallEntry? first = await cache.get('entry:0') as FutureCallEntry?;
    expect(first, isNull);

    FutureCallEntry last = await cache.get('entry:${numEntries - 1}') as FutureCallEntry;
    expect(last.serverId, equals(numEntries - 1));
  });

  test('Invalidate keys', () async {
    for (int i = 0; i < cacheMaxSize; i++) {
      var entry = FutureCallEntry(serverId: i, name: 'test', time: DateTime.now());
      await cache.put('entry:$i', entry);
    }

    int middleId = cacheMaxSize ~/ 4;

    FutureCallEntry retrieved = await cache.get('entry:$middleId') as FutureCallEntry;
    expect(retrieved.serverId, equals(middleId));

    await cache.invalidateKey('entry:$middleId');
    retrieved = await cache.get('entry:$middleId') as FutureCallEntry;
    expect(retrieved, isNull);

    expect(cache.localSize, equals(cacheMaxSize - 1));
  });

  test('Invalidate group', () async {
    for (int i = 0; i < cacheMaxSize ~/ 2; i++) {
      var entry = FutureCallEntry(serverId: i, name: 'test', time: DateTime.now());
      await cache.put('entry:$i', entry, group: 'group:0');
    }
    for (int i = cacheMaxSize ~/ 2; i < cacheMaxSize; i++) {
      var entry = FutureCallEntry(serverId: i, name: 'test', time: DateTime.now());
      await cache.put('entry:$i', entry, group: 'group:1');
    }

    expect(cache.localSize, equals(cacheMaxSize));

    await cache.invalidateGroup('group:0');
    expect(cache.localSize, equals(cacheMaxSize ~/ 2));

    FutureCallEntry? retrieved = await cache.get('entry:0') as FutureCallEntry;
    expect(retrieved, isNull);

    retrieved = await cache.get('entry:${cacheMaxSize - 1}') as FutureCallEntry?;
    expect(retrieved!.serverId, equals(cacheMaxSize - 1));

    await cache.invalidateGroup('group:1');
    expect(cache.localSize, equals(0));

    await cache.invalidateGroup('group:1');
    expect(cache.localSize, equals(0));
  });

  test('Invalidate key then group', () async {
    for (int i = 0; i < cacheMaxSize ~/ 2; i++) {
      var entry = FutureCallEntry(serverId: i, name: 'test', time: DateTime.now());
      await cache.put('entry:$i', entry, group: 'group:0');
    }
    for (int i = cacheMaxSize ~/ 2; i < cacheMaxSize; i++) {
      var entry = FutureCallEntry(serverId: i, name: 'test', time: DateTime.now());
      await cache.put('entry:$i', entry, group: 'group:1');
    }

    await cache.invalidateKey('entry:0');
    FutureCallEntry? retrieved = await cache.get('entry:0') as FutureCallEntry;
    expect(retrieved, isNull);

    retrieved = await cache.get('entry:1') as FutureCallEntry;
    expect(retrieved.serverId, equals(1));

    await cache.invalidateGroup('group:0');

    expect(cache.localSize, equals(cacheMaxSize ~/ 2));

    for (int i = cacheMaxSize ~/ 2; i < cacheMaxSize; i++) {
      await cache.invalidateKey('entry:$i');
    }

    expect(cache.localSize, equals(0));
  });
}
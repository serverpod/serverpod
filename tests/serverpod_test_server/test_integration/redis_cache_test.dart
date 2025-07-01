import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/redis_cache.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  late RedisCache cache;
  setUpAll(() async {
    var redisController = session.serverpod.redisController;
    await redisController?.start();
    cache = RedisCache(Protocol(), redisController);
  });

  tearDown(() async => await cache.clear());

  test(
      'Given an object is stored in the cache '
      'when it is retrieved '
      'then the correct object is returned', () async {
    var entry = SimpleData(num: 0);

    await cache.put('entry', entry);
    var retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved!.num, equals(0));

    retrieved = await cache.get<SimpleData>('missing');
    expect(retrieved, isNull);

    retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved!.num, equals(0));
  });

  test(
      'Given an object is stored in the cache with a lifetime '
      'when the lifetime expires '
      'then the object is no longer retrievable', () async {
    var entry = SimpleData(num: 0);

    await cache.put('entry', entry,
        lifetime: const Duration(milliseconds: 100));
    var retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved!.num, equals(0));

    await Future.delayed(const Duration(milliseconds: 110));
    retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved, isNull);
  });

  test(
      'Given multiple objects are stored with the same key '
      'when a new object is added '
      'then the last object overwrites the previous one', () async {
    var entryA = SimpleData(num: 0);
    var entryB = SimpleData(num: 1);

    await cache.put('entry', entryA);
    await cache.put('entry', entryB);

    var retrieved = await cache.get<SimpleData>('entry');
    expect(retrieved!.num, equals(1));
  });

  test(
      'Given a key is invalidated '
      'when the key is retrieved '
      'then the object is no longer retrievable', () async {
    await cache.put('entry:1337', SimpleData(num: 1337));

    await cache.invalidateKey('entry:1337');
    var retrieved = await cache.get<SimpleData>('entry:1337');
    expect(retrieved, isNull);
  });

  test(
      'Given an object is not in the cache '
      'when it is retrieved '
      'then null is returned', () async {
    var retrieved = await cache.get<SimpleData>('invalidEntry');
    expect(retrieved, isNull);
  });

  group(
      'Given an object is not in the cache and a cache miss handler '
      'is specified to return an object', () {
    const cacheKey = 'testKey';
    SimpleData? retrieved;
    setUp(() async {
      retrieved = await cache.get(
        cacheKey,
        CacheMissHandler(() async => SimpleData(num: 1337)),
      );
    });

    test(
        'when the object is retrieved '
        'then the cache miss handler returns the correct object', () {
      expect(retrieved?.num, equals(1337));
    });

    test(
        'when the object is retrieved again '
        'then the cache miss handler value is retrievable from the cache',
        () async {
      var value = await cache.get<SimpleData>(cacheKey);
      expect(value?.num, equals(1337));
    });
  });

  group(
      'Given an object is not in the cache and '
      'the cache miss handler returns null', () {
    const cacheKey = 'testKey';
    SimpleData? retrieved;
    setUp(() async {
      retrieved = await cache.get(
        cacheKey,
        CacheMissHandler(() async => null),
      );
    });

    test(
        'when the object is retrieved '
        'then null is returned', () {
      expect(retrieved, isNull);
    });

    test(
        'when the object is retrieved again '
        'then no value is set in the cache', () async {
      var value = await cache.get<SimpleData>(cacheKey);
      expect(value, isNull);
    });
  });

  group(
      'Given an object is already in the cache '
      'and a cache miss handler is specified', () {
    const cacheKey = 'testKey';
    SimpleData? retrieved;
    setUp(() async {
      await cache.put(cacheKey, SimpleData(num: 1));
      retrieved = await cache.get(
        cacheKey,
        CacheMissHandler(() async => SimpleData(num: 1337)),
      );
    });

    test(
        'when the object is retrieved '
        'then the object already in the cache is returned', () {
      expect(retrieved?.num, equals(1));
    });

    test(
        'when the object is retrieved again '
        'then the object in the cache is still retrievable', () async {
      var value = await cache.get<SimpleData>(cacheKey);
      expect(value?.num, equals(1));
    });
  });

  group('Given listener registered on a channel', () {
    const channelName = 'testChannel';
    var messageSent = SimpleData(num: 1337);
    late Completer<SimpleData?> messageCompleter;
    MessageCentralListenerCallback listener = (message) {
      if (message is SimpleData) {
        messageCompleter.complete(message);
      }
    };

    setUp(() async {
      messageCompleter = Completer();
      session.messages.addListener(channelName, listener);
    });

    tearDown(() async {
      session.messages.removeListener(channelName, listener);
    });

    test(
        'when a global message is published to the channel '
        'then postMessage returns true', () async {
      final result = await session.messages.postMessage(
        channelName,
        messageSent,
        global: true,
      );

      expect(result, isTrue);
    });

    test(
        'when a global message is published to the channel '
        'then the message is received', () async {
      await session.messages.postMessage(
        channelName,
        messageSent,
        global: true,
      );

      var messageReceived = await messageCompleter.future.timeout(
        Duration(seconds: 10),
        onTimeout: () => null,
      );

      expect(messageReceived, isNotNull);
      expect(messageReceived?.num, messageSent.num);
    });

    test(
        'when a global message is published to the channel '
        'then confirmation is received', () async {
      var published = await session.messages.postMessage(
        channelName,
        messageSent,
        global: true,
      );

      expect(published, true);
    });

    group('when a global message is published to a different channel', () {
      var uniqueChannelName = Uuid().v4();
      late Completer<SimpleData?> uniqueChannelMessageCompleter;
      MessageCentralListenerCallback uniqueChannelListener = (message) {
        if (message is SimpleData) {
          uniqueChannelMessageCompleter.complete(message);
        }
      };

      setUp(() async {
        session.messages.addListener(uniqueChannelName, uniqueChannelListener);
        uniqueChannelMessageCompleter = Completer();
      });

      tearDown(() async {
        session.messages
            .removeListener(uniqueChannelName, uniqueChannelListener);
      });

      test('then no message is received', () async {
        await session.messages.postMessage(
          uniqueChannelName,
          messageSent,
          global: true,
        );

        var uniqueChannelMessageReceived =
            await uniqueChannelMessageCompleter.future.timeout(
          Duration(seconds: 10),
          onTimeout: () => null,
        );
        expect(uniqueChannelMessageReceived, isNotNull);

        expectLater(
          messageCompleter.future.timeout(
            Duration(milliseconds: 100),
          ),
          throwsA(isA<TimeoutException>()),
        );
      });
    });

    test(
        'when a global message is published to a channel with no listeners '
        'then the publish is still successful', () async {
      var uniqueChannelName = Uuid().v4();
      var published = await session.messages.postMessage(
        uniqueChannelName,
        messageSent,
        global: true,
      );

      expect(published, true);
    });
  });

  group('Given a stopped Redis controller', () {
    setUp(() async {
      var controller = session.serverpod.redisController;
      assert(controller != null, 'Expected Redis controller to be not null');
      if (controller != null) {
        await controller.stop();
      }
    });

    tearDown(() async {
      var controller = session.serverpod.redisController;
      assert(controller != null, 'Expected Redis controller to be not null');
      if (controller != null) {
        await controller.start();
      }
    });

    test('when publishing a global message then the publish fails', () async {
      var published = await session.messages.postMessage(
        'testChannel',
        SimpleData(num: 1337),
        global: true,
      );

      expect(published, false);
    });
  });

  group('Given a null Redis controller', () {
    final tempController = session.serverpod.redisController;
    setUp(() async {
      assert(
        session.serverpod.redisController != null,
        'Expected Redis controller to be not null',
      );
      session.serverpod.redisController = null;
    });

    tearDown(() async {
      assert(
        session.serverpod.redisController == null,
        'Expected Redis controller to be null',
      );
      session.serverpod.redisController = tempController;
    });

    test('when publishing a global message then a state error is thrown',
        () async {
      expectLater(
        () async => await session.messages.postMessage(
          'testChannel',
          SimpleData(num: 1337),
          global: true,
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Redis needs to be enabled to use this method',
          ),
        ),
      );
    });
  });
}

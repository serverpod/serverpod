import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/redis_cache.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
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

  group(
      'get object not in cache when cacheMissHandler is specified to return object',
      () {
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

  group(
      'get object not in cache when cache miss handler is specified to return null',
      () {
    const cacheKey = 'testKey';
    SimpleData? retrieved;
    setUp(() async {
      retrieved = await cache.get(
        cacheKey,
        CacheMissHandler(() async => null),
      );
    });
    test('then null is returned', () {
      expect(retrieved, isNull);
    });

    test('then no value is set in cache', () async {
      var value = await cache.get<SimpleData>(cacheKey);
      expect(value, isNull);
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

  group('Given listener registered on channel', () {
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

    test('when global message is published to channel then message is received',
        () async {
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

    test('when global message is published to channel confirmation is received',
        () async {
      var published = await session.messages.postMessage(
        channelName,
        messageSent,
        global: true,
      );

      expect(published, true);
    });

    group('when global message is published to different channel ', () {
      var uniqueChannelName = Uuid().v4();
      late Completer<SimpleData?> uniqueChannelMessageCompleter;
      MessageCentralListenerCallback uniqueCannelListener = (message) {
        if (message is SimpleData) {
          uniqueChannelMessageCompleter.complete(message);
        }
      };

      setUp(() async {
        session.messages.addListener(uniqueChannelName, uniqueCannelListener);
        uniqueChannelMessageCompleter = Completer();
      });

      tearDown(() async {
        session.messages
            .removeListener(uniqueChannelName, uniqueCannelListener);
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

        /// Ensure that the message was not received on the original channel
        expectLater(
          messageCompleter.future.timeout(
            Duration(milliseconds: 100),
          ),
          throwsA(isA<TimeoutException>()),
        );
      });
    });

    test(
        'when global message is published to channel with no listeners then publish is still successful',
        () async {
      var uniqueChannelName = Uuid().v4();
      var published = await session.messages.postMessage(
        uniqueChannelName,
        messageSent,
        global: true,
      );

      expect(published, true);
    });
  });

  group('Given stopped redis controller', () {
    setUp(() async {
      var controller = session.serverpod.redisController;
      assert(controller != null, 'Expected redis controller to be not null');
      if (controller != null) {
        await controller.stop();
      }
    });

    tearDown(() async {
      var controller = session.serverpod.redisController;
      assert(controller != null, 'Expected redis controller to be not null');
      if (controller != null) {
        await controller.start();
      }
    });

    test('when publishing global message then publish fails', () async {
      var published = await session.messages.postMessage(
        'testChannel',
        SimpleData(num: 1337),
        global: true,
      );

      expect(published, false);
    });
  });

  group('Given null redis controller', () {
    final tempController = session.serverpod.redisController;
    setUp(() async {
      assert(
        session.serverpod.redisController != null,
        'Expected redis controller to be not null',
      );
      session.serverpod.redisController = null;
    });

    tearDown(() async {
      assert(
        session.serverpod.redisController == null,
        'Expected redis controller to be null',
      );
      session.serverpod.redisController = tempController;
    });

    test('when publishing global message then state error is thrown', () async {
      expectLater(
        () async => await session.messages.postMessage(
          'testChannel',
          SimpleData(num: 1337),
          global: true,
        ),
        throwsStateError,
      );
    });
  });
}

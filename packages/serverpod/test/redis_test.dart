import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    'http://serverpod_test_server:8080/',
  );

  setUp(() {});

  group('Redis cache set and get', () {
    test('Set and get', () async {
      final data = SimpleData(num: 42);
      await client.redis.setSimpleData('test', data);

      final retrievedData = await client.redis.getSimpleData('test');
      expect(retrievedData, isNotNull);
      expect(retrievedData!.num, equals(42));
    });

    test('Get non-existing', () async {
      final retrievedData =
          await client.redis.getSimpleData('test-nonexistant');
      expect(retrievedData, isNull);
    });

    test('Delete key', () async {
      await client.redis.deleteSimpleData('test');

      final retrievedData = await client.redis.getSimpleData('test');
      expect(retrievedData, isNull);
    });

    test('Expiring object', () async {
      final data = SimpleData(num: 42);
      await client.redis.setSimpleDataWithLifetime('test', data);

      final retrievedData = await client.redis.getSimpleData('test');
      expect(retrievedData, isNotNull);
      expect(retrievedData!.num, equals(42));

      await Future.delayed(const Duration(seconds: 1));

      final retrievedDataAgain = await client.redis.getSimpleData('test');
      expect(retrievedDataAgain, isNull);
    });
  });

  group('Redis message central', () {
    test('Post and listen', () async {
      final data = SimpleData(num: 42);

      SimpleData? retrieved;
      unawaited(client.redis.listenToChannel('test').then((value) {
        retrieved = value;
      }));

      await client.redis.postToChannel('test', data);
      var channelCount = await client.redis.countSubscribedChannels();
      expect(channelCount, equals(1));

      await Future.delayed(const Duration(seconds: 1));

      expect(retrieved, isNotNull);
      expect(retrieved!.num, equals(42));

      // Channels should be unlistened to when the listening session in
      // the server has closed.
      channelCount = await client.redis.countSubscribedChannels();
      expect(channelCount, equals(0));
    });
  });
}

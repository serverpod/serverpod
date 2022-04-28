import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  Client client = Client(
    'http://serverpod_test_server:8080/',
  );

  setUp(() {});

  group('Redis cache set and get', () {
    test('Set and get', () async {
      SimpleData data = SimpleData(num: 42);
      await client.redis.setSimpleData('test', data);

      SimpleData? retrievedData = await client.redis.getSimpleData('test');
      expect(retrievedData, isNotNull);
      expect(retrievedData!.num, equals(42));
    });

    test('Get non-existing', () async {
      SimpleData? retrievedData = await client.redis.getSimpleData('test-nonexistant');
      expect(retrievedData, isNull);
    });

    test('Delete key', () async {
      await client.redis.deleteSimpleData('test');

      SimpleData? retrievedData = await client.redis.getSimpleData('test');
      expect(retrievedData, isNull);
    });

    test('Expiring object', () async {
      SimpleData data = SimpleData(num: 42);
      await client.redis.setSimpleDataWithLifetime('test', data);

      SimpleData? retrievedData = await client.redis.getSimpleData('test');
      expect(retrievedData, isNotNull);
      expect(retrievedData!.num, equals(42));

      await Future<void>.delayed(const Duration(seconds: 1));

      SimpleData? retrievedDataAgain = await client.redis.getSimpleData('test');
      expect(retrievedDataAgain, isNull);
    });
  });

  group('Redis message central', () {
    test('Post and listen', () async {
      SimpleData data = SimpleData(num: 42);

      SimpleData? retrieved;
      unawaited(client.redis.listenToChannel('test').then((SimpleData? value) {
        retrieved = value;
      }));

      await client.redis.postToChannel('test', data);
      int channelCount = await client.redis.countSubscribedChannels();
      expect(channelCount, equals(1));

      await Future<void>.delayed(const Duration(seconds: 4));

      expect(retrieved, isNotNull);
      expect(retrieved!.num, equals(42));

      // Channels should be unlistened to when the listening session in
      // the server has closed.
      channelCount = await client.redis.countSubscribedChannels();
      expect(channelCount, equals(0));
    });
  });
}

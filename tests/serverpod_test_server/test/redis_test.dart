import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart'
    as service;

import 'config.dart';
import 'service_protocol_test.dart';

void main() {
  var client = Client(
    serverUrl,
  );
  var serviceClient = service.Client(
    serviceServerUrl,
    authenticationKeyManager: ServiceKeyManager('0', 'password'),
  );

  setUp(() {});

  group('Redis cache set and get', () {
    test('Set and get', () async {
      var data = SimpleData(num: 42);
      await client.redis.setSimpleData('test', data);

      var retrievedData = await client.redis.getSimpleData('test');
      expect(retrievedData, isNotNull);
      expect(retrievedData!.num, equals(42));
    });

    test('Get non-existing', () async {
      var retrievedData = await client.redis.getSimpleData('test-nonexistant');
      expect(retrievedData, isNull);
    });

    test('Delete key', () async {
      await client.redis.deleteSimpleData('test');

      var retrievedData = await client.redis.getSimpleData('test');
      expect(retrievedData, isNull);
    });

    test('Expiring object', () async {
      var data = SimpleData(num: 42);
      await client.redis.setSimpleDataWithLifetime('test', data);

      var retrievedData = await client.redis.getSimpleData('test');
      expect(retrievedData, isNotNull);
      expect(retrievedData!.num, equals(42));

      await Future.delayed(const Duration(seconds: 1));

      var retrievedDataAgain = await client.redis.getSimpleData('test');
      expect(retrievedDataAgain, isNull);
    });
  });

  group('Redis message central', () {
    test('Post and listen', () async {
      var data = SimpleData(num: 42);

      SimpleData? retrieved;
      unawaited(client.redis.listenToChannel('test').then((value) {
        retrieved = value;
      }));
      await Future.delayed(const Duration(seconds: 1));
      await client.redis.postToChannel('test', data);
      var channelCount = await client.redis.countSubscribedChannels();
      expect(channelCount, equals(1));

      await Future.delayed(const Duration(seconds: 5));

      var logResult = await serviceClient.insights.getSessionLog(
          1,
          service.SessionLogFilter(
            slow: true,
            error: false,
            open: false,
            endpoint: 'redis',
            method: 'listenToChannel',
          ));
      expect(logResult.sessionLog.first.logs.first.error,
          equals('Exception: Test exception'));
      expect(logResult.sessionLog.first.logs.first.message,
          equals('Failed to execute callback in channel test'));

      await Future.delayed(const Duration(seconds: 4));

      expect(retrieved, isNotNull);
      expect(retrieved!.num, equals(42));

      // Channels should be unlistened to when the listening session in
      // the server has closed.
      channelCount = await client.redis.countSubscribedChannels();
      expect(channelCount, equals(0));
    });
  });
}

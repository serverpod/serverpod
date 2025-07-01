import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given withServerpod with cache operations',
    (sessionBuilder, endpoints) {
      group('when tests store data in local cache', () {
        test('then the value is retrieved.', () async {
          // First test stores data
          final testData = SimpleData(num: 42);
          await endpoints.testTools
              .putInLocalCache(sessionBuilder, 'test-key', testData);

          // Verify data was stored
          final cached1 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'test-key');
          expect(cached1, isNotNull);
          expect(cached1!.num, equals(42));
        });

        test('then local cache should be empty from previous test', () async {
          // This test should find cache empty due to automatic cleanup
          final cached = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'test-key');
          expect(cached, isNull,
              reason: 'Local cache should be cleared between tests');
        });
      });

      group('when tests store data in localPrio cache', () {
        test('then the value is retrieved.', () async {
          // First test stores data
          final testData = SimpleData(num: 84);
          await endpoints.testTools
              .putInLocalPrioCache(sessionBuilder, 'prio-key', testData);

          // Verify data was stored
          final cached1 = await endpoints.testTools
              .getFromLocalPrioCache(sessionBuilder, 'prio-key');
          expect(cached1, isNotNull);
          expect(cached1!.num, equals(84));
        });

        test('then localPrio cache should be empty from previous test',
            () async {
          // This test should find cache empty due to automatic cleanup
          final cached = await endpoints.testTools
              .getFromLocalPrioCache(sessionBuilder, 'prio-key');
          expect(cached, isNull,
              reason: 'LocalPrio cache should be cleared between tests');
        });
      });

      group('when tests store data in query cache', () {
        test('then the value is retrieved.', () async {
          // First test stores data
          final testData = SimpleData(num: 168);
          await endpoints.testTools
              .putInQueryCache(sessionBuilder, 'query-key', testData);

          // Verify data was stored
          final cached1 = await endpoints.testTools
              .getFromQueryCache(sessionBuilder, 'query-key');
          expect(cached1, isNotNull);
          expect(cached1!.num, equals(168));
        });

        test('then query cache should be empty from previous test', () async {
          // This test should find cache empty due to automatic cleanup
          final cached = await endpoints.testTools
              .getFromQueryCache(sessionBuilder, 'query-key');
          expect(cached, isNull,
              reason: 'Query cache should be cleared between tests');
        });
      });

      group('when tests store data with cache groups', () {
        test('then the value is retrieved.', () async {
          // Store data with group
          final testData1 = SimpleData(num: 100);
          final testData2 = SimpleData(num: 200);

          await endpoints.testTools.putInLocalCacheWithGroup(
              sessionBuilder, 'group-key-1', testData1, 'test-group');
          await endpoints.testTools.putInLocalCacheWithGroup(
              sessionBuilder, 'group-key-2', testData2, 'test-group');

          // Verify both items are cached
          final cached1 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'group-key-1');
          final cached2 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'group-key-2');
          expect(cached1?.num, equals(100));
          expect(cached2?.num, equals(200));
        });

        test('then grouped cache should be empty from previous test', () async {
          // Both grouped items should be cleared
          final cached1 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'group-key-1');
          final cached2 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'group-key-2');
          expect(cached1, isNull,
              reason: 'Grouped cache item 1 should be cleared');
          expect(cached2, isNull,
              reason: 'Grouped cache item 2 should be cleared');
        });
      });

      group('when tests store data with different keys', () {
        test('then the value is retrieved.', () async {
          // Store multiple entries
          await endpoints.testTools
              .putInLocalCache(sessionBuilder, 'multi-1', SimpleData(num: 1));
          await endpoints.testTools
              .putInLocalCache(sessionBuilder, 'multi-2', SimpleData(num: 2));
          await endpoints.testTools
              .putInLocalCache(sessionBuilder, 'multi-3', SimpleData(num: 3));

          // Verify all are cached
          final cached1 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'multi-1');
          final cached2 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'multi-2');
          final cached3 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'multi-3');

          expect(cached1?.num, equals(1));
          expect(cached2?.num, equals(2));
          expect(cached3?.num, equals(3));
        });

        test('then all multiple cache entries should be cleared', () async {
          // All entries should be cleared
          final cached1 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'multi-1');
          final cached2 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'multi-2');
          final cached3 = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'multi-3');

          expect(cached1, isNull,
              reason: 'Multiple cache entry 1 should be cleared');
          expect(cached2, isNull,
              reason: 'Multiple cache entry 2 should be cleared');
          expect(cached3, isNull,
              reason: 'Multiple cache entry 3 should be cleared');
        });
      });

      group('when cache data is set in setUp', () {
        setUp(() async {
          final sharedData = SimpleData(num: 999);
          await endpoints.testTools
              .putInLocalCache(sessionBuilder, 'setup-key', sharedData);
        });

        test('then setup cache data should be available in first test',
            () async {
          final cached = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'setup-key');
          expect(cached, isNotNull);
          expect(cached!.num, equals(999));
        });

        test('then setup cache data should still be available in second test',
            () async {
          final cached = await endpoints.testTools
              .getFromLocalCache(sessionBuilder, 'setup-key');
          expect(cached, isNotNull,
              reason: 'Cache data from setUpAll should persist across tests');
          expect(cached!.num, equals(999));
        });
      });
    },
  );
}

import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import 'test_utils/test_auth_key_providers.dart';

void main() {
  late TestRefresherAuthKeyProvider delegate;
  late MutexRefresherClientAuthKeyProvider provider;

  setUp(() {
    delegate = TestRefresherAuthKeyProvider();
    provider = MutexRefresherClientAuthKeyProvider(delegate);
  });

  group('Given a mutex protected auth key provider with an initial token', () {
    setUp(() {
      delegate.setAuthKey('initial-token');
    });

    test(
      'when refresh fails then returns original auth header value.',
      () async {
        delegate.setRefresh(() => RefreshAuthKeyResult.failedOther);

        final result = await provider.authHeaderValue;

        expect(result, 'Bearer initial-token');
        expect(delegate.refreshCallCount, 1);
      },
    );

    test('when refresh succeeds then returns new auth header value.', () async {
      delegate.setRefresh(() {
        delegate.setAuthKey('refreshed-token');
        return RefreshAuthKeyResult.success;
      });

      final result = await provider.authHeaderValue;

      expect(result, 'Bearer refreshed-token');
      expect(delegate.refreshCallCount, 1);
    });

    test('when multiple refreshAuthKey calls are made concurrently '
        'then only one call performs refresh due to locking.', () async {
      delegate.setRefresh(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        return RefreshAuthKeyResult.success;
      });

      final futures = List.generate(3, (_) => provider.refreshAuthKey());
      final results = await Future.wait(futures);

      expect(results, everyElement(RefreshAuthKeyResult.success));
      expect(delegate.refreshCallCount, 1);
    });

    test('when multiple authHeaderValue calls are made concurrently '
        'then only one call performs refresh due to locking.', () async {
      delegate.setRefresh(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        delegate.setAuthKey('refreshed-token');
        return RefreshAuthKeyResult.success;
      });

      final futures = List.generate(3, (_) => provider.authHeaderValue);
      final results = await Future.wait(futures);

      expect(results, everyElement('Bearer refreshed-token'));
      expect(delegate.refreshCallCount, 1);
    });

    test(
      'when refresh is already in progress and new call is made '
      'then it waits for existing refresh to complete and no new refresh is started.',
      () async {
        delegate.setRefresh(() async {
          await Future.delayed(const Duration(milliseconds: 200));
          return RefreshAuthKeyResult.success;
        });

        final firstRefresh = provider.refreshAuthKey();
        await Future.delayed(const Duration(milliseconds: 50));

        final secondRefresh = provider.refreshAuthKey();
        final results = await Future.wait([firstRefresh, secondRefresh]);

        expect(results, everyElement(RefreshAuthKeyResult.success));
        expect(delegate.refreshCallCount, 1);
      },
    );

    test(
      'when multiple refreshAuthKey calls are made concurrently and refresh fails '
      'then all calls return false and no new refresh is started.',
      () async {
        delegate.setRefresh(() async {
          await Future.delayed(const Duration(milliseconds: 50));
          return RefreshAuthKeyResult.failedOther;
        });

        final futures = List.generate(3, (_) => provider.refreshAuthKey());
        final results = await Future.wait(futures);

        expect(results, everyElement(RefreshAuthKeyResult.failedOther));
        expect(delegate.refreshCallCount, 1);
      },
    );

    test(
      'when first refresh fails with unauthorized and auth header value does not change '
      'then subsequent refresh calls with same auth header value are skipped.',
      () async {
        delegate.setRefresh(() => RefreshAuthKeyResult.failedUnauthorized);

        final firstResult = await provider.refreshAuthKey();
        final secondResult = await provider.refreshAuthKey();

        expect(firstResult, RefreshAuthKeyResult.failedUnauthorized);
        expect(secondResult, RefreshAuthKeyResult.failedUnauthorized);
        expect(delegate.refreshCallCount, 1);
      },
    );

    test(
      'when first refresh fails with other error and auth header value does not change '
      'then subsequent refresh calls are allowed.',
      () async {
        delegate.setRefresh(() => RefreshAuthKeyResult.failedOther);

        final firstResult = await provider.refreshAuthKey();
        expect(firstResult, RefreshAuthKeyResult.failedOther);
        expect(delegate.refreshCallCount, 1);

        delegate.setRefresh(() => RefreshAuthKeyResult.success);

        final secondResult = await provider.refreshAuthKey();
        expect(secondResult, RefreshAuthKeyResult.success);
        expect(delegate.refreshCallCount, 2);
      },
    );

    test(
      'when first refresh fails with unauthorized and auth header value changes '
      'then subsequent refresh calls are allowed.',
      () async {
        delegate.setRefresh(() => RefreshAuthKeyResult.failedUnauthorized);

        final firstResult = await provider.refreshAuthKey();
        expect(firstResult, RefreshAuthKeyResult.failedUnauthorized);
        expect(delegate.refreshCallCount, 1);

        delegate.setAuthKey('new-login-token');
        delegate.setRefresh(() => RefreshAuthKeyResult.skipped);

        final secondResult = await provider.refreshAuthKey();
        expect(secondResult, RefreshAuthKeyResult.skipped);
        expect(delegate.refreshCallCount, 2);
      },
    );

    test(
      'when refresh fails with unauthorized and auth header value changes to null '
      'then subsequent refresh calls are allowed.',
      () async {
        delegate.setRefresh(() => RefreshAuthKeyResult.failedUnauthorized);

        final firstResult = await provider.refreshAuthKey();
        expect(firstResult, RefreshAuthKeyResult.failedUnauthorized);
        expect(delegate.refreshCallCount, 1);

        delegate.setAuthKey(null);
        delegate.setRefresh(() => RefreshAuthKeyResult.skipped);

        final secondResult = await provider.refreshAuthKey();
        expect(secondResult, RefreshAuthKeyResult.skipped);
        expect(delegate.refreshCallCount, 2);
      },
    );

    test(
      'when first refresh fails with unauthorized and auth header value does not change, but force parameter is true '
      'then refresh is performed regardless of the previous refresh result.',
      () async {
        delegate.setRefresh(() => RefreshAuthKeyResult.failedUnauthorized);

        final firstResult = await provider.refreshAuthKey();
        expect(firstResult, RefreshAuthKeyResult.failedUnauthorized);
        expect(delegate.refreshCallCount, 1);

        final secondResult = await provider.refreshAuthKey(force: true);
        expect(secondResult, RefreshAuthKeyResult.failedUnauthorized);
        expect(delegate.refreshCallCount, 2);
      },
    );

    test('when refreshing throws an exception '
        'then refreshAuthKey rethrows the exception.', () async {
      delegate.setRefresh(() => throw Exception('Refresh failed'));

      await expectLater(provider.refreshAuthKey(), throwsA(isA<Exception>()));
      expect(delegate.refreshCallCount, 1);
    });

    test(
      'when multiple refreshAuthKey calls are made concurrently and refresh throws an exception '
      'then refreshAuthKey rethrows the exception for all calls.',
      () async {
        delegate.setRefresh(() => throw Exception('Refresh failed'));

        final futures = List.generate(3, (_) => provider.refreshAuthKey());

        await [
          for (final future in futures)
            expectLater(future, throwsA(isA<Exception>())),
        ].wait;
        expect(delegate.refreshCallCount, 1);
      },
    );

    test('when refreshing throws an exception '
        'then authHeaderValue rethrows the exception.', () async {
      delegate.setRefresh(() => throw Exception('Refresh failed'));

      await expectLater(provider.authHeaderValue, throwsA(isA<Exception>()));
      expect(delegate.refreshCallCount, 1);
    });

    test(
      'when multiple authHeaderValue calls are made concurrently and refresh throws an exception '
      'then authHeaderValue rethrows the exception for all calls.',
      () async {
        delegate.setRefresh(() => throw Exception('Refresh failed'));

        final futures = List.generate(3, (_) => provider.authHeaderValue);

        await [
          for (final future in futures)
            expectLater(future, throwsA(isA<Exception>())),
        ].wait;
        expect(delegate.refreshCallCount, 1);
      },
    );

    test('when calling refreshAuthKey without setting force parameter '
        'then delegate is called with force set to false.', () async {
      delegate.setRefresh(() => RefreshAuthKeyResult.failedUnauthorized);

      await provider.refreshAuthKey();
      expect(delegate.refreshCallCount, 1);
      expect(delegate.refreshCallForced, [false]);
    });

    test('when calling refreshAuthKey with force parameter set to true '
        'then delegate is also called with force set to true.', () async {
      delegate.setRefresh(() => RefreshAuthKeyResult.failedUnauthorized);

      await provider.refreshAuthKey(force: true);
      expect(delegate.refreshCallCount, 1);
      expect(delegate.refreshCallForced, [true]);
    });
  });
}

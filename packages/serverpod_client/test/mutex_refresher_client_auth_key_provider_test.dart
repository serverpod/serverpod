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

    test('when refresh fails then returns original auth header value.',
        () async {
      delegate.setRefresh(() => RefreshAuthKeyResult.failedOther);

      final result = await provider.authHeaderValue;

      expect(result, 'Bearer initial-token');
      expect(delegate.refreshCallCount, 1);
    });

    test('when refresh succeeds then returns new auth header value.', () async {
      delegate.setRefresh(() {
        delegate.updateAuthKey();
        return RefreshAuthKeyResult.success;
      });

      final result = await provider.authHeaderValue;

      expect(result, 'Bearer refreshed-token-1');
      expect(delegate.refreshCallCount, 1);
    });

    test(
        'when multiple refreshAuthKey calls are made concurrently '
        'then only one call performs refresh due to locking.', () async {
      delegate.setRefresh(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        delegate.updateAuthKey();
        return RefreshAuthKeyResult.success;
      });

      final futures = List.generate(3, (_) => provider.refreshAuthKey());
      final results = await Future.wait(futures);

      expect(results, everyElement(RefreshAuthKeyResult.success));
      expect(delegate.refreshCallCount, 1);
    });

    test(
        'when multiple authHeaderValue calls are made concurrently '
        'then only one call performs refresh due to locking.', () async {
      delegate.setRefresh(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        delegate.updateAuthKey();
        return RefreshAuthKeyResult.success;
      });

      final futures = List.generate(3, (_) => provider.authHeaderValue);
      final results = await Future.wait(futures);

      expect(results, everyElement('Bearer refreshed-token-1'));
      expect(delegate.refreshCallCount, 1);
    });

    test(
        'when refresh is already in progress and new call is made '
        'then it waits for existing refresh to complete and no new refresh is started.',
        () async {
      delegate.setRefresh(() async {
        await Future.delayed(const Duration(milliseconds: 200));
        delegate.updateAuthKey();
        return RefreshAuthKeyResult.success;
      });

      final firstRefresh = provider.refreshAuthKey();
      await Future.delayed(const Duration(milliseconds: 50));

      final secondRefresh = provider.refreshAuthKey();
      final results = await Future.wait([firstRefresh, secondRefresh]);

      expect(results, everyElement(RefreshAuthKeyResult.success));
      expect(delegate.refreshCallCount, 1);
    });

    test(
        'when multiple refreshAuthKey calls are made concurrently and refresh fails '
        'then all calls return false and no new refresh is started.', () async {
      delegate.setRefresh(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        return RefreshAuthKeyResult.failedOther;
      });

      final futures = List.generate(3, (_) => provider.refreshAuthKey());
      final results = await Future.wait(futures);

      expect(results, everyElement(RefreshAuthKeyResult.failedOther));
      expect(delegate.refreshCallCount, 1);
    });

    test(
        'when refreshing throws an exception '
        'then refreshAuthKey rethrows the exception.', () async {
      delegate.setRefresh(() => throw Exception('Refresh failed'));

      await expectLater(provider.refreshAuthKey(), throwsA(isA<Exception>()));
      expect(delegate.refreshCallCount, 1);
    });

    test(
        'when refreshing throws an exception '
        'then authHeaderValue rethrows the exception.', () async {
      delegate.setRefresh(() => throw Exception('Refresh failed'));

      await expectLater(provider.authHeaderValue, throwsA(isA<Exception>()));
      expect(delegate.refreshCallCount, 1);
    });
  });
}

import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import '../test_utils/test_serverpod_client.dart';

void main() {
  late TestServerpodClient client;
  late TestRequestDelegate requestDelegate;

  group('Given a Client with an authKeyProvider that does not support refresh',
      () {
    setUp(() {
      requestDelegate = TestRequestDelegate(
        exceptionToThrow: unauthorizedException,
      );

      client = TestServerpodClient(
        authKeyProvider: TestNonRefresherAuthKeyProvider('token'),
        requestDelegate: requestDelegate,
      );
    });

    test('when first call fails with 401 then no retry is attempted.',
        () async {
      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientException>()
            .having((e) => e.statusCode, 'statusCode', 401)),
      );

      expect(requestDelegate.callCount, 1);
    });
  });

  late TestRefresherAuthKeyProvider authKeyProvider;

  group('Given a Client with an authKeyProvider that supports refresh', () {
    setUp(() {
      requestDelegate = TestRequestDelegate();
      authKeyProvider = TestRefresherAuthKeyProvider(
        initialAuthKey: 'initial-token',
      );
      client = TestServerpodClient(
        authKeyProvider: authKeyProvider,
        requestDelegate: requestDelegate,
      );
    });

    test('when first call succeeds then no retry is attempted.', () async {
      requestDelegate.responseProvider = () => '"success"';

      final result = await client.callServerEndpoint<String>(
        'test',
        'method',
        {'arg': 'value'},
      );

      expect(result, 'success');
      expect(requestDelegate.callCount, 1);
      expect(authKeyProvider.refreshCallCount, 0);
    });

    test(
        'when first call fails with 401 and refresh succeeds '
        'then request is retried.', () async {
      requestDelegate
        ..exceptionToThrow = unauthorizedException
        ..throwOnFirstCallOnly = true
        ..responseProvider = () => '"success"';

      final result = await client.callServerEndpoint<String>(
        'test',
        'method',
        {'arg': 'value'},
      );

      expect(result, 'success');
      expect(requestDelegate.callCount, 2);
      expect(authKeyProvider.refreshCallCount, 1);
      expect(requestDelegate.requestLog[0], contains('initial-token'));
      expect(requestDelegate.requestLog[1], contains('refreshed-token-1'));
    });

    test(
        'when first call fails with 401 but refresh fails '
        'then original exception is rethrown.', () async {
      requestDelegate.exceptionToThrow = unauthorizedException;
      authKeyProvider.setRefreshResult(false);

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientException>()
            .having((e) => e.statusCode, 'statusCode', 401)
            .having((e) => e.message, 'message', 'Unauthorized')),
      );

      expect(requestDelegate.callCount, 1);
      expect(authKeyProvider.refreshCallCount, 1);
    });

    test(
        'when first and second calls fails with 401 '
        'then no second retry is attempted and original exception is rethrown.',
        () async {
      requestDelegate
        ..exceptionToThrow = unauthorizedException
        ..throwOnFirstCallOnly = false;

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientException>()
            .having((e) => e.statusCode, 'statusCode', 401)),
      );

      expect(requestDelegate.callCount, 2);
      expect(authKeyProvider.refreshCallCount, 1);
      expect(requestDelegate.requestLog[0], contains('initial-token'));
      expect(requestDelegate.requestLog[1], contains('refreshed-token-1'));
    });

    test(
        'when first call fails with non-401 error '
        'then no retry is attempted.', () async {
      requestDelegate.exceptionToThrow =
          const ServerpodClientException('Server Error', 500);

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<ServerpodClientException>()
            .having((e) => e.statusCode, 'statusCode', 500)),
      );

      expect(requestDelegate.callCount, 1);
      expect(authKeyProvider.refreshCallCount, 0);
    });

    test(
        'when exception is not ServerpodClientException '
        'then no retry is attempted.', () async {
      requestDelegate.exceptionToThrow = Exception('Network error');

      await expectLater(
        client.callServerEndpoint<String>('test', 'method', {'arg': 'value'}),
        throwsA(isA<Exception>()),
      );

      expect(authKeyProvider.refreshCallCount, 0);
    });

    test(
        'when shouldRetryOnAuthFailed is false '
        'then no retry is attempted.', () async {
      requestDelegate.exceptionToThrow = unauthorizedException;

      await expectLater(
        client.callServerEndpoint<String>(
            'test', 'method', {'arg': 'value'}, false),
        throwsA(isA<ServerpodClientException>()
            .having((e) => e.statusCode, 'statusCode', 401)),
      );

      expect(requestDelegate.callCount, 1);
      expect(authKeyProvider.refreshCallCount, 0);
    });
  });
}

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

void main() {
  group('Given a zero attempt limit, ', () {
    const maxAttempts = 0;

    group('when creating a rate limiter configuration, ', () {
      Object? error;

      setUpAll(() {
        try {
          RateLimiterConfig(
            domain: 'email',
            source: 'login',
            maxAttempts: maxAttempts,
          );
        } catch (caughtError) {
          error = caughtError;
        }
      });

      test('then it throws an argument error.', () {
        expect(error, isA<ArgumentError>());
      });
    });
  });

  group('Given a negative attempt limit, ', () {
    const maxAttempts = -1;

    group('when creating a rate limiter configuration, ', () {
      Object? error;

      setUpAll(() {
        try {
          RateLimiterConfig(
            domain: 'email',
            source: 'login',
            maxAttempts: maxAttempts,
          );
        } catch (caughtError) {
          error = caughtError;
        }
      });

      test('then it throws an argument error.', () {
        expect(error, isA<ArgumentError>());
      });
    });
  });

  group('Given a zero rolling window, ', () {
    const maxAttempts = 1;
    const timeframe = Duration.zero;

    group('when creating a rate limiter configuration, ', () {
      Object? error;

      setUpAll(() {
        try {
          RateLimiterConfig(
            domain: 'email',
            source: 'login',
            maxAttempts: maxAttempts,
            timeframe: timeframe,
          );
        } catch (caughtError) {
          error = caughtError;
        }
      });

      test('then it throws an argument error.', () {
        expect(error, isA<ArgumentError>());
      });
    });
  });

  group('Given a negative rolling window, ', () {
    const maxAttempts = 1;
    const timeframe = Duration(seconds: -1);

    group('when creating a rate limiter configuration, ', () {
      Object? error;

      setUpAll(() {
        try {
          RateLimiterConfig(
            domain: 'email',
            source: 'login',
            maxAttempts: maxAttempts,
            timeframe: timeframe,
          );
        } catch (caughtError) {
          error = caughtError;
        }
      });

      test('then it throws an argument error.', () {
        expect(error, isA<ArgumentError>());
      });
    });
  });
}

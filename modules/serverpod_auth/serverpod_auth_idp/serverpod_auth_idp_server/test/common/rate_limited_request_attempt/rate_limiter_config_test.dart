import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a zero attempt limit, '
    'when creating a rate limiter configuration, '
    'then it throws an argument error.',
    () {
      expect(
        () => RateLimiterConfig(
          domain: 'email',
          source: 'login',
          maxAttempts: 0,
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given a negative attempt limit, '
    'when creating a rate limiter configuration, '
    'then it throws an argument error.',
    () {
      expect(
        () => RateLimiterConfig(
          domain: 'email',
          source: 'login',
          maxAttempts: -1,
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given a zero rolling window, '
    'when creating a rate limiter configuration, '
    'then it throws an argument error.',
    () {
      expect(
        () => RateLimiterConfig(
          domain: 'email',
          source: 'login',
          maxAttempts: 1,
          timeframe: Duration.zero,
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given a negative rolling window, '
    'when creating a rate limiter configuration, '
    'then it throws an argument error.',
    () {
      expect(
        () => RateLimiterConfig(
          domain: 'email',
          source: 'login',
          maxAttempts: 1,
          timeframe: const Duration(seconds: -1),
        ),
        throwsArgumentError,
      );
    },
  );
}

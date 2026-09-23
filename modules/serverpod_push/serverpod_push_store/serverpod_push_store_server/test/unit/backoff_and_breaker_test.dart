import 'dart:math';

import 'package:serverpod_push_store_server/src/business/push_backoff.dart';
import 'package:serverpod_push_store_server/src/business/push_circuit_breaker.dart';
import 'package:serverpod_push_store_server/src/business/push_store_config.dart';
import 'package:test/test.dart';

void main() {
  group('Given pushBackoff', () {
    const config = PushStoreConfig(
      baseBackoff: Duration(seconds: 10),
      maxBackoff: Duration(hours: 1),
      backoffJitter: 0,
    );

    test('when exponent is 0 then the delay is baseBackoff.', () {
      expect(
        pushBackoff(0, config, random: _FixedRandom(0.5)),
        const Duration(seconds: 10),
      );
    });

    test('when exponent grows then the delay doubles until maxBackoff.', () {
      expect(
        pushBackoff(1, config, random: _FixedRandom(0.5)),
        const Duration(seconds: 20),
      );
      expect(
        pushBackoff(2, config, random: _FixedRandom(0.5)),
        const Duration(seconds: 40),
      );
      expect(
        pushBackoff(20, config, random: _FixedRandom(0.5)),
        const Duration(hours: 1),
      );
    });
  });

  group('Given a PushCircuitBreaker', () {
    const config = PushStoreConfig(
      authFailureThreshold: 3,
      authFailureCooldown: Duration(seconds: 60),
    );

    test('when auth failures hit the threshold then it opens.', () {
      final breaker = PushCircuitBreaker(config);
      final now = DateTime.utc(2026, 1, 1);
      expect(breaker.isOpen(now), isFalse);
      breaker.recordAuthFailure(now);
      breaker.recordAuthFailure(now);
      expect(breaker.isOpen(now), isFalse);
      breaker.recordAuthFailure(now);
      expect(breaker.isOpen(now), isTrue);
      expect(breaker.openUntil, now.add(const Duration(seconds: 60)));
    });

    test('when it trips twice then cooldown grows.', () {
      final breaker = PushCircuitBreaker(config);
      final now = DateTime.utc(2026, 1, 1);
      for (var i = 0; i < 3; i++) {
        breaker.recordAuthFailure(now);
      }
      expect(breaker.openUntil, now.add(const Duration(seconds: 60)));
      final later = now.add(const Duration(minutes: 2));
      expect(breaker.isOpen(later), isFalse);
      for (var i = 0; i < 3; i++) {
        breaker.recordAuthFailure(later);
      }
      expect(breaker.openUntil, later.add(const Duration(seconds: 120)));
    });

    test('when isAuthFailure is called then only 401/403 codes match.', () {
      expect(PushCircuitBreaker.isAuthFailure('UNAUTHENTICATED'), isTrue);
      expect(PushCircuitBreaker.isAuthFailure('PERMISSION_DENIED'), isTrue);
      expect(PushCircuitBreaker.isAuthFailure('UNAVAILABLE'), isFalse);
    });
  });
}

class _FixedRandom implements Random {
  _FixedRandom(this.value);
  final double value;

  @override
  double nextDouble() => value;

  @override
  int nextInt(final int max) => 0;

  @override
  bool nextBool() => false;
}

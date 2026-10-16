import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

FutureCallRetryContext _contextFor(int retryAttempt) {
  return FutureCallRetryContext(
    error: Exception(),
    stackTrace: StackTrace.empty,
    retryAttempt: retryAttempt,
  );
}

void main() {
  group('Given a FixedDelayRetryPolicy with maxAttempts 3,', () {
    late FixedDelayRetryPolicy policy;

    setUp(() {
      policy = const FixedDelayRetryPolicy(
        maxAttempts: 3,
        delay: Duration(seconds: 30),
      );
    });

    test(
      'when nextDelay is called 4 times with increasing retry attempts,'
      'then it returns the same delay 3 times before returning null.',
      () {
        final delays = List.generate(
          4,
          (i) => policy.nextDelay(_contextFor(i)),
        );
        expect(delays, [
          const Duration(seconds: 30),
          const Duration(seconds: 30),
          const Duration(seconds: 30),
          null,
        ]);
      },
    );

    test(
      'when serialized and deserialized,'
      'then the policy has the same configuration.',
      () {
        var restored = FixedDelayRetryPolicy.fromJson(policy.toJson());

        expect(restored.maxAttempts, policy.maxAttempts);
        expect(restored.delay, policy.delay);
      },
    );

    test('when validated then no error is thrown', () {
      expect(policy.validate, returnsNormally);
    });
  });

  group('Given a LinearBackoffRetryPolicy with maxAttempts 4,', () {
    late LinearBackoffRetryPolicy policy;

    setUp(() {
      policy = const LinearBackoffRetryPolicy(
        maxAttempts: 4,
        initialDelay: Duration(seconds: 10),
        increment: Duration(seconds: 10),
      );
    });

    test(
      'when nextDelay is called 5 times with increasing retry attempts,'
      'then it returns 4 delays that each grow by the increment before returning null.',
      () {
        final delays = List.generate(
          5,
          (i) => policy.nextDelay(_contextFor(i)),
        );
        expect(delays, [
          const Duration(seconds: 10),
          const Duration(seconds: 20),
          const Duration(seconds: 30),
          const Duration(seconds: 40),
          null,
        ]);
      },
    );

    test(
      'when serialized and deserialized,'
      'then the policy has the same configuration.',
      () {
        var restored = LinearBackoffRetryPolicy.fromJson(policy.toJson());

        expect(restored.maxAttempts, policy.maxAttempts);
        expect(restored.initialDelay, policy.initialDelay);
        expect(restored.increment, policy.increment);
        expect(restored.maxDelay, policy.maxDelay);
      },
    );
  });

  group('Given a LinearBackoffRetryPolicy with a maxDelay,', () {
    late LinearBackoffRetryPolicy policy;

    setUp(() {
      policy = const LinearBackoffRetryPolicy(
        maxAttempts: 4,
        initialDelay: Duration(seconds: 10),
        increment: Duration(seconds: 10),
        maxDelay: Duration(seconds: 25),
      );
    });

    test(
      'when nextDelay is called 5 times with increasing retry attempts,'
      'then the returned delays stop growing at maxDelay before returning null.',
      () {
        final delays = List.generate(
          5,
          (i) => policy.nextDelay(_contextFor(i)),
        );
        expect(delays, [
          const Duration(seconds: 10),
          const Duration(seconds: 20),
          const Duration(seconds: 25),
          const Duration(seconds: 25),
          null,
        ]);
      },
    );

    test(
      'when serialized and deserialized,'
      'then the policy has the same maxDelay.',
      () {
        var restored = LinearBackoffRetryPolicy.fromJson(policy.toJson());

        expect(restored.maxDelay, policy.maxDelay);
      },
    );
  });

  group(
    'Given an ExponentialBackoffRetryPolicy with maxAttempts 5, multiplier 2 and a maxDelay,',
    () {
      late ExponentialBackoffRetryPolicy policy;

      setUp(() {
        policy = const ExponentialBackoffRetryPolicy(
          maxAttempts: 5,
          multiplier: 2,
          initialDelay: Duration(seconds: 2),
          maxDelay: Duration(seconds: 20),
        );
      });

      test(
        'when nextDelay is called 6 times with increasing retry attempts,'
        'then it returns 5 delays that double each time up to maxDelay before returning null.',
        () {
          final delays = List.generate(
            6,
            (i) => policy.nextDelay(_contextFor(i)),
          );
          expect(delays, [
            const Duration(seconds: 2),
            const Duration(seconds: 4),
            const Duration(seconds: 8),
            const Duration(seconds: 16),
            const Duration(seconds: 20),
            null,
          ]);
        },
      );

      test(
        'when serialized and deserialized,'
        'then the policy has the same configuration.',
        () {
          var restored = ExponentialBackoffRetryPolicy.fromJson(
            policy.toJson(),
          );

          expect(restored.maxAttempts, policy.maxAttempts);
          expect(restored.initialDelay, policy.initialDelay);
          expect(restored.multiplier, policy.multiplier);
          expect(restored.maxDelay, policy.maxDelay);
        },
      );
    },
  );

  group('Given an ExponentialBackoffRetryPolicy with multiplier 3,', () {
    late ExponentialBackoffRetryPolicy policy;

    setUp(() {
      policy = const ExponentialBackoffRetryPolicy(
        maxAttempts: 3,
        initialDelay: Duration(seconds: 1),
        multiplier: 3,
      );
    });

    test(
      'when nextDelay is called 4 times with increasing retry attempts,'
      'then each returned delay is 3 times the previous one before returning null.',
      () {
        final delays = List.generate(
          4,
          (i) => policy.nextDelay(_contextFor(i)),
        );
        expect(delays, [
          const Duration(seconds: 1),
          const Duration(seconds: 3),
          const Duration(seconds: 9),
          null,
        ]);
      },
    );
  });

  group('Given a RandomDelayRetryPolicy with maxAttempts 3,', () {
    late RandomDelayRetryPolicy policy;

    setUp(() {
      policy = const RandomDelayRetryPolicy(
        maxAttempts: 3,
        min: Duration(seconds: 1),
        max: Duration(seconds: 10),
      );
    });

    test(
      'when nextDelay is called 4 times with increasing retry attempts,'
      'then it returns 3 delays between min and max before returning null.',
      () {
        final delays = List.generate(
          4,
          (i) => policy.nextDelay(_contextFor(i)),
        );
        expect(
          delays.take(3),
          everyElement(
            allOf(
              greaterThanOrEqualTo(policy.min),
              lessThanOrEqualTo(policy.max),
            ),
          ),
        );
        expect(delays.last, isNull);
      },
    );

    test(
      'when serialized and deserialized,'
      'then the policy has the same configuration.',
      () {
        var restored = RandomDelayRetryPolicy.fromJson(policy.toJson());

        expect(restored.maxAttempts, policy.maxAttempts);
        expect(restored.min, policy.min);
        expect(restored.max, policy.max);
      },
    );
  });

  group('Given a CustomDelaysRetryPolicy with 3 delays,', () {
    late CustomDelaysRetryPolicy policy;

    setUp(() {
      policy = const CustomDelaysRetryPolicy([
        Duration(seconds: 1),
        Duration(seconds: 1),
        Duration(seconds: 2),
      ]);
    });

    test(
      'when nextDelay is called 4 times with increasing retry attempts,'
      'then it returns each delay of the list in order before returning null.',
      () {
        final delays = List.generate(
          4,
          (i) => policy.nextDelay(_contextFor(i)),
        );
        expect(delays, [...policy.delays, null]);
      },
    );

    test(
      'when serialized and deserialized,'
      'then the policy has the same delays.',
      () {
        var restored = CustomDelaysRetryPolicy.fromJson(policy.toJson());
        expect(restored.delays, policy.delays);
      },
    );
  });

  var invalidPolicies = <String, (FutureCallRetryPolicy, String)>{
    'a FixedDelayRetryPolicy with a negative delay': (
      const FixedDelayRetryPolicy(
        maxAttempts: 1,
        delay: Duration(seconds: -1),
      ),
      'Must not be negative.',
    ),
    'a LinearBackoffRetryPolicy with maxAttempts 0': (
      const LinearBackoffRetryPolicy(
        maxAttempts: 0,
        initialDelay: Duration(seconds: 1),
        increment: Duration(seconds: 1),
      ),
      'Must be 1 or greater.',
    ),
    'a LinearBackoffRetryPolicy with a negative initialDelay': (
      const LinearBackoffRetryPolicy(
        maxAttempts: 1,
        initialDelay: Duration(seconds: -1),
        increment: Duration(seconds: 1),
      ),
      'Must not be negative.',
    ),
    'a LinearBackoffRetryPolicy with a negative increment': (
      const LinearBackoffRetryPolicy(
        maxAttempts: 1,
        initialDelay: Duration(seconds: 1),
        increment: Duration(seconds: -1),
      ),
      'Must not be negative.',
    ),
    'a LinearBackoffRetryPolicy with a negative maxDelay': (
      const LinearBackoffRetryPolicy(
        maxAttempts: 1,
        initialDelay: Duration(seconds: 1),
        increment: Duration(seconds: 1),
        maxDelay: Duration(seconds: -1),
      ),
      'Must not be negative.',
    ),
    'an ExponentialBackoffRetryPolicy with maxAttempts 0': (
      const ExponentialBackoffRetryPolicy(
        maxAttempts: 0,
        initialDelay: Duration(seconds: 1),
      ),
      'Must be 1 or greater.',
    ),
    'an ExponentialBackoffRetryPolicy with a negative initialDelay': (
      const ExponentialBackoffRetryPolicy(
        maxAttempts: 1,
        initialDelay: Duration(seconds: -1),
      ),
      'Must not be negative.',
    ),
    'an ExponentialBackoffRetryPolicy with a negative multiplier': (
      const ExponentialBackoffRetryPolicy(
        maxAttempts: 1,
        initialDelay: Duration(seconds: 1),
        multiplier: -2,
      ),
      'Must not be negative.',
    ),
    'an ExponentialBackoffRetryPolicy with a negative maxDelay': (
      const ExponentialBackoffRetryPolicy(
        maxAttempts: 1,
        initialDelay: Duration(seconds: 1),
        maxDelay: Duration(seconds: -1),
      ),
      'Must not be negative.',
    ),
    'a RandomDelayRetryPolicy with maxAttempts 0': (
      const RandomDelayRetryPolicy(
        maxAttempts: 0,
        min: Duration(seconds: 1),
        max: Duration(seconds: 2),
      ),
      'Must be 1 or greater.',
    ),
    'a RandomDelayRetryPolicy with a negative min': (
      const RandomDelayRetryPolicy(
        maxAttempts: 1,
        min: Duration(seconds: -1),
        max: Duration(seconds: 2),
      ),
      'Must not be negative.',
    ),
    'a RandomDelayRetryPolicy with min greater than max': (
      const RandomDelayRetryPolicy(
        maxAttempts: 1,
        min: Duration(seconds: 10),
        max: Duration(seconds: 1),
      ),
      'Must not be greater than max.',
    ),
    'a CustomDelaysRetryPolicy with an empty list': (
      const CustomDelaysRetryPolicy([]),
      'Must not be empty.',
    ),
    'a CustomDelaysRetryPolicy with a negative delay': (
      const CustomDelaysRetryPolicy([
        Duration(seconds: 1),
        Duration(seconds: -1),
      ]),
      'Must not be negative.',
    ),
  };

  for (var MapEntry(key: description, value: (policy, message))
      in invalidPolicies.entries) {
    group('Given $description,', () {
      test(
        'when the policy is validated,'
        'then an ArgumentError is thrown.',
        () {
          expect(
            () => policy.validate(),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                message,
              ),
            ),
          );
        },
      );
    });
  }
}

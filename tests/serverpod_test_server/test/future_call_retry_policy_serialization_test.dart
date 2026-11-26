import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/futureCalls/test_retry_policies.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  var protocol = Protocol();

  group('Given a built-in FixedDelayRetryPolicy,', () {
    late FixedDelayRetryPolicy policy;

    setUp(() {
      policy = const FixedDelayRetryPolicy(
        maxAttempts: 3,
        delay: Duration(seconds: 30),
      );
    });

    test(
      'when the class name is looked up in the project protocol,'
      'then the name of the policy in the serverpod protocol is returned.',
      () {
        expect(
          protocol.getClassNameForObject(policy),
          'serverpod.FixedDelayRetryPolicy',
        );
      },
    );

    test(
      'when encoded and decoded with type by the project protocol,'
      'then a FixedDelayRetryPolicy with the same configuration is returned.',
      () {
        var decoded = protocol.decodeWithType(protocol.encodeWithType(policy));

        expect(
          decoded,
          isA<FixedDelayRetryPolicy>()
              .having((p) => p.maxAttempts, 'maxAttempts', policy.maxAttempts)
              .having((p) => p.delay, 'delay', policy.delay),
        );
      },
    );
  });

  group('Given a retry policy declared in the project,', () {
    late TestRetryPolicy policy;

    setUp(() {
      policy = TestRetryPolicy(
        maxAttempts: 2,
        delay: const Duration(seconds: 5),
      );
    });

    test(
      'when the class name is looked up in the project protocol,'
      'then the name of the class is returned.',
      () {
        expect(protocol.getClassNameForObject(policy), 'TestRetryPolicy');
      },
    );

    test(
      'when encoded and decoded with type by the project protocol,'
      'then a TestRetryPolicy with the same configuration is returned.',
      () {
        var decoded = protocol.decodeWithType(protocol.encodeWithType(policy));

        expect(
          decoded,
          isA<TestRetryPolicy>()
              .having((p) => p.maxAttempts, 'maxAttempts', policy.maxAttempts)
              .having((p) => p.delay, 'delay', policy.delay),
        );
      },
    );
  });

  group(
    'Given a project retry policy that extends another project policy,',
    () {
      late TestRetryPolicyWithDoubling policy;

      setUp(() {
        policy = TestRetryPolicyWithDoubling(
          maxAttempts: 2,
          delay: const Duration(seconds: 5),
        );
      });

      test(
        'when the class name is looked up in the project protocol,'
        'then the name of the subclass is returned.',
        () {
          expect(
            protocol.getClassNameForObject(policy),
            'TestRetryPolicyWithDoubling',
          );
        },
      );

      test(
        'when encoded and decoded with type by the project protocol,'
        'then an instance of the subclass is returned.',
        () {
          var decoded = protocol.decodeWithType(
            protocol.encodeWithType(policy),
          );

          expect(decoded, isA<TestRetryPolicyWithDoubling>());
        },
      );
    },
  );
}

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/passwordless.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/passwordless_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given passwordless login is configured',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late PasswordlessIdpTestFixture fixture;
      late Map<String, UuidValue> nonceToUserId;

      const handle = 'test-handle';
      late String verificationCode;
      late UuidValue deliveredRequestId;
      late String deliveredVerificationCode;

      setUp(() async {
        session = sessionBuilder.build();
        nonceToUserId = {};
        verificationCode = const Uuid().v4().toString();

        fixture = PasswordlessIdpTestFixture(
          config: PasswordlessIdpConfig(
            secretHashPepper: 'pepper',
            loginVerificationCodeGenerator: () => verificationCode,
            sendLoginVerificationCode:
                (
                  final Session session, {
                  required final String handle,
                  required final UuidValue requestId,
                  required final String verificationCode,
                  required final Transaction? transaction,
                }) async {
                  deliveredRequestId = requestId;
                  deliveredVerificationCode = verificationCode;
                },
            resolveAuthUserId:
                (
                  final Session session, {
                  required final String nonce,
                  required final Transaction? transaction,
                }) async {
                  final authUserId = nonceToUserId[nonce];
                  if (authUserId == null) {
                    throw PasswordlessLoginNotFoundException();
                  }
                  return authUserId;
                },
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        nonceToUserId[handle] = authUser.id;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test('when startLogin is called then it returns a request id', () async {
        final requestId = await fixture.passwordlessIdp.startLogin(
          session,
          handle: handle,
        );

        expect(requestId, isA<UuidValue>());
        expect(deliveredRequestId, equals(requestId));
        expect(deliveredVerificationCode, equals(verificationCode));
      });

      test(
        'when verifyLoginCode is called with invalid verification code then it throws PasswordlessLoginException with reason "invalid"',
        () async {
          final requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );

          final result = fixture.passwordlessIdp.verifyLoginCode(
            session,
            loginRequestId: requestId,
            verificationCode: '$verificationCode-invalid',
          );

          await expectLater(
            result,
            throwsA(
              isA<PasswordlessLoginException>().having(
                (final e) => e.reason,
                'reason',
                PasswordlessLoginExceptionReason.invalid,
              ),
            ),
          );
        },
      );

      test(
        'when startLogin is called too many times then it throws PasswordlessLoginException with reason "tooManyAttempts"',
        () async {
          for (var i = 0; i < 5; i++) {
            await fixture.passwordlessIdp.startLogin(session, handle: handle);
          }

          final result = fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );

          await expectLater(
            result,
            throwsA(
              isA<PasswordlessLoginException>().having(
                (final e) => e.reason,
                'reason',
                PasswordlessLoginExceptionReason.tooManyAttempts,
              ),
            ),
          );
        },
      );

      test(
        'when login is completed then it returns AuthSuccess',
        () async {
          final requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );

          final token = await fixture.passwordlessIdp.verifyLoginCode(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredVerificationCode,
          );

          final result = await fixture.passwordlessIdp.finishLogin(
            session,
            loginToken: token,
          );

          expect(result, isA<AuthSuccess>());
        },
      );
    },
  );
}

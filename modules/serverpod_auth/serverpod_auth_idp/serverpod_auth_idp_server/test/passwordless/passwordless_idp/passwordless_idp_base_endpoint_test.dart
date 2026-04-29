import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passwordless.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Passwordless base endpoint wiring',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late _PasswordlessEndpoint endpoint;

      late Map<String, UuidValue> handleToUserId;
      late String verificationCode;
      late String deliveredHandle;
      late String resolvedHandle;
      late UuidValue deliveredRequestId;
      late String deliveredVerificationCode;

      const handle = 'test-handle';

      setUp(() async {
        session = sessionBuilder.build();
        endpoint = _PasswordlessEndpoint();

        handleToUserId = {};
        verificationCode = const Uuid().v4().toString();

        AuthServices.set(
          tokenManagerBuilders: [
            ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
          ],
          identityProviderBuilders: [
            PasswordlessIdpConfig(
              secretHashPepper: 'pepper',
              resolveAuthUserId:
                  (
                    final Session session, {
                    required final String handle,
                    required final String? handleType,
                    required final Transaction? transaction,
                  }) async {
                    resolvedHandle = handle;
                    return handleToUserId[handle]!;
                  },
              loginVerificationCodeGenerator: () => verificationCode,
              sendLoginVerificationCode:
                  (
                    final Session session, {
                    required final String handle,
                    required final UuidValue requestId,
                    required final String verificationCode,
                    required final Transaction? transaction,
                    required final String? handleType,
                  }) async {
                    deliveredHandle = handle;
                    deliveredRequestId = requestId;
                    deliveredVerificationCode = verificationCode;
                  },
            ),
          ],
        );

        final authUsers = AuthServices.instance.authUsers;
        handleToUserId[handle] = (await authUsers.create(session)).id;
      });

      tearDown(() async {
        await session.db.transaction((final transaction) async {
          await Future.wait([
            PasswordlessLoginRequest.db.deleteWhere(
              session,
              where: (final _) => Constant.bool(true),
              transaction: transaction,
            ),
            RateLimitedRequestAttempt.db.deleteWhere(
              session,
              where: (final t) => t.domain.equals('passwordless'),
              transaction: transaction,
            ),
            SecretChallenge.db.deleteWhere(
              session,
              where: (final _) => Constant.bool(true),
              transaction: transaction,
            ),
            AuthUser.db.deleteWhere(
              session,
              where: (final _) => Constant.bool(true),
              transaction: transaction,
            ),
          ]);
        });
      });

      test(
        'when using base endpoint then it resolves the passwordless provider and keeps String handle semantics',
        () async {
          expect(
            endpoint.passwordlessIdp,
            same(AuthServices.getIdentityProvider<PasswordlessIdp>()),
          );

          final requestId = await endpoint.startLogin(
            session,
            handle: handle,
          );

          expect(requestId, equals(deliveredRequestId));
          expect(deliveredHandle, equals(handle));
          expect(deliveredVerificationCode, equals(verificationCode));

          final authSuccess = await endpoint.finishLogin(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredVerificationCode,
          );

          expect(authSuccess, isA<AuthSuccess>());
          expect(resolvedHandle, equals(handle));
        },
      );

      test(
        'when finishLogin is called through the base endpoint with a missing request then it surfaces invalid',
        () async {
          final result = endpoint.finishLogin(
            session,
            loginRequestId: UuidValue.withValidation(const Uuid().v4()),
            verificationCode: verificationCode,
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
        'when finishLogin is called through the base endpoint for an expired request then it surfaces expired',
        () async {
          final requestId = await endpoint.startLogin(
            session,
            handle: handle,
          );

          await withClock(
            Clock.fixed(clock.now().add(const Duration(minutes: 11))),
            () async {
              final result = endpoint.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: deliveredVerificationCode,
              );

              await expectLater(
                result,
                throwsA(
                  isA<PasswordlessLoginException>().having(
                    (final e) => e.reason,
                    'reason',
                    PasswordlessLoginExceptionReason.expired,
                  ),
                ),
              );
            },
          );
        },
      );

      test(
        'when finishLogin is called through the base endpoint after too many invalid verification attempts then it surfaces tooManyAttempts',
        () async {
          final requestId = await endpoint.startLogin(
            session,
            handle: handle,
          );

          for (
            var i = 0;
            i <
                endpoint
                    .passwordlessIdp
                    .config
                    .loginVerificationCodeAllowedAttempts;
            i++
          ) {
            await expectLater(
              endpoint.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: '$deliveredVerificationCode-invalid-$i',
              ),
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
          }

          final result = endpoint.finishLogin(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredVerificationCode,
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
        'when finishLogin is called through the base endpoint for a blocked auth user then it surfaces AuthUserBlockedException',
        () async {
          final requestId = await endpoint.startLogin(
            session,
            handle: handle,
          );

          await AuthServices.instance.authUsers.update(
            session,
            authUserId: handleToUserId[handle]!,
            blocked: true,
          );

          final result = endpoint.finishLogin(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredVerificationCode,
          );

          await expectLater(result, throwsA(isA<AuthUserBlockedException>()));
        },
      );
    },
  );
}

final class _PasswordlessEndpoint extends PasswordlessIdpBaseEndpoint {}

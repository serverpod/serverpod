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
      late _StringPasswordlessEndpoint stringEndpoint;
      late _IntPasswordlessEndpoint intEndpoint;

      late Map<String, UuidValue> stringHandleToUserId;
      late String stringVerificationCode;
      late String deliveredStringHandle;
      late String resolvedStringHandle;
      late UuidValue deliveredStringRequestId;
      late String deliveredStringVerificationCode;

      late Map<int, UuidValue> intHandleToUserId;
      late String intVerificationCode;
      late int deliveredIntHandle;
      late int resolvedIntHandle;
      late UuidValue deliveredIntRequestId;
      late String deliveredIntVerificationCode;

      const stringHandle = 'string-handle';
      const intHandle = '42';

      setUp(() async {
        session = sessionBuilder.build();
        stringEndpoint = _StringPasswordlessEndpoint();
        intEndpoint = _IntPasswordlessEndpoint();

        stringHandleToUserId = {};
        intHandleToUserId = {};
        stringVerificationCode = const Uuid().v4().toString();
        intVerificationCode = const Uuid().v4().toString();

        AuthServices.set(
          tokenManagerBuilders: [
            ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
          ],
          identityProviderBuilders: [
            PasswordlessIdpConfig<String>(
              secretHashPepper: 'pepper',
              resolveAuthUserId:
                  (
                    final Session session, {
                    required final String handle,
                    required final String? handleType,
                    required final Transaction? transaction,
                  }) async {
                    resolvedStringHandle = handle;
                    return stringHandleToUserId[handle]!;
                  },
              loginVerificationCodeGenerator: () => stringVerificationCode,
              sendLoginVerificationCode:
                  (
                    final Session session, {
                    required final String handle,
                    required final UuidValue requestId,
                    required final String verificationCode,
                    required final Transaction? transaction,
                    required final String? handleType,
                  }) async {
                    deliveredStringHandle = handle;
                    deliveredStringRequestId = requestId;
                    deliveredStringVerificationCode = verificationCode;
                  },
            ),
            PasswordlessIdpConfig<int>(
              secretHashPepper: 'pepper',
              resolveAuthUserId:
                  (
                    final Session session, {
                    required final int handle,
                    required final String? handleType,
                    required final Transaction? transaction,
                  }) async {
                    resolvedIntHandle = handle;
                    return intHandleToUserId[handle]!;
                  },
              loginVerificationCodeGenerator: () => intVerificationCode,
              sendLoginVerificationCode:
                  (
                    final Session session, {
                    required final int handle,
                    required final UuidValue requestId,
                    required final String verificationCode,
                    required final Transaction? transaction,
                    required final String? handleType,
                  }) async {
                    deliveredIntHandle = handle;
                    deliveredIntRequestId = requestId;
                    deliveredIntVerificationCode = verificationCode;
                  },
            ),
          ],
        );

        final authUsers = AuthServices.instance.authUsers;
        stringHandleToUserId[stringHandle] = (await authUsers.create(
          session,
        )).id;
        intHandleToUserId[42] = (await authUsers.create(session)).id;
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
        'when using explicit String base endpoint then it resolves the String provider and keeps String handle semantics',
        () async {
          expect(
            stringEndpoint.passwordlessIdp,
            same(AuthServices.getIdentityProvider<PasswordlessIdp<String>>()),
          );

          final requestId = await stringEndpoint.startLogin(
            session,
            handle: stringHandle,
          );

          expect(requestId, equals(deliveredStringRequestId));
          expect(deliveredStringHandle, equals(stringHandle));
          expect(
            deliveredStringVerificationCode,
            equals(stringVerificationCode),
          );

          final authSuccess = await stringEndpoint.finishLogin(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredStringVerificationCode,
          );

          expect(authSuccess, isA<AuthSuccess>());
          expect(resolvedStringHandle, equals(stringHandle));
        },
      );

      test(
        'when finishLogin is called through the base endpoint with a missing request then it surfaces invalid',
        () async {
          final result = stringEndpoint.finishLogin(
            session,
            loginRequestId: UuidValue.withValidation(const Uuid().v4()),
            verificationCode: stringVerificationCode,
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
          final requestId = await stringEndpoint.startLogin(
            session,
            handle: stringHandle,
          );

          await withClock(
            Clock.fixed(clock.now().add(const Duration(minutes: 11))),
            () async {
              final result = stringEndpoint.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: deliveredStringVerificationCode,
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
          final requestId = await stringEndpoint.startLogin(
            session,
            handle: stringHandle,
          );

          for (
            var i = 0;
            i <
                stringEndpoint
                    .passwordlessIdp
                    .config
                    .loginVerificationCodeAllowedAttempts;
            i++
          ) {
            await expectLater(
              stringEndpoint.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: '$deliveredStringVerificationCode-invalid-$i',
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

          final result = stringEndpoint.finishLogin(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredStringVerificationCode,
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
          final requestId = await stringEndpoint.startLogin(
            session,
            handle: stringHandle,
          );

          await AuthServices.instance.authUsers.update(
            session,
            authUserId: stringHandleToUserId[stringHandle]!,
            blocked: true,
          );

          final result = stringEndpoint.finishLogin(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredStringVerificationCode,
          );

          await expectLater(result, throwsA(isA<AuthUserBlockedException>()));
        },
      );

      test(
        'when using a non-String base endpoint then it resolves the exact provider type and passes typed handles to both callbacks',
        () async {
          expect(
            intEndpoint.passwordlessIdp,
            same(AuthServices.getIdentityProvider<PasswordlessIdp<int>>()),
          );

          final requestId = await intEndpoint.startLogin(
            session,
            handle: intHandle,
          );

          expect(requestId, equals(deliveredIntRequestId));
          expect(deliveredIntHandle, equals(42));
          expect(deliveredIntVerificationCode, equals(intVerificationCode));

          final authSuccess = await intEndpoint.finishLogin(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredIntVerificationCode,
          );

          expect(authSuccess, isA<AuthSuccess>());
          expect(resolvedIntHandle, equals(42));
        },
      );

      test(
        'when startLogin is called through a non-String base endpoint with an invalid handle then it surfaces invalid',
        () async {
          final result = intEndpoint.startLogin(
            session,
            handle: 'not-a-number',
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
    },
  );
}

final class _IntPasswordlessEndpoint extends PasswordlessIdpBaseEndpoint<int> {}

final class _StringPasswordlessEndpoint
    extends PasswordlessIdpBaseEndpoint<String> {}

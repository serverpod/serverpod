import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passwordless.dart';
import 'package:serverpod_auth_idp_server/src/providers/passwordless/business/passwordless_idp_server_exceptions.dart'
    show PasswordlessLoginNotFoundException;
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/passwordless_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Passwordless finishLogin auth scenarios',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late PasswordlessIdpTestFixture fixture;
      late Map<String, UuidValue> handleToUserId;

      const handle = 'test-handle';
      late String verificationCode;
      late String deliveredVerificationCode;

      Future<void> initializeFixture() async {
        handleToUserId = {};
        verificationCode = const Uuid().v4().toString();

        fixture = PasswordlessIdpTestFixture(
          config: PasswordlessIdpConfig(
            secretHashPepper: 'pepper',
            resolveAuthUserId:
                (
                  final Session session, {
                  required final String handle,
                  required final String handleType,
                  required final Transaction? transaction,
                }) async {
                  final authUserId = handleToUserId[handle];
                  if (authUserId == null) {
                    throw PasswordlessLoginNotFoundException();
                  }
                  return authUserId;
                },
            loginVerificationCodeGenerator: () => verificationCode,
            sendLoginVerificationCode:
                (
                  final Session session, {
                  required final String handle,
                  required final UuidValue requestId,
                  required final String verificationCode,
                  required final Transaction? transaction,
                  required final String handleType,
                }) async {
                  deliveredVerificationCode = verificationCode;
                },
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        handleToUserId[handle] = authUser.id;
      }

      group('Given a valid login request', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin is called with correct code then it returns AuthSuccess',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(result, isA<AuthSuccess>());
          },
        );
      });

      group('Given a provider that creates auth users during resolution', () {
        late UuidValue createdAuthUserId;

        setUp(() async {
          session = sessionBuilder.build();
          handleToUserId = {};
          verificationCode = const Uuid().v4().toString();

          fixture = PasswordlessIdpTestFixture(
            config: PasswordlessIdpConfig(
              secretHashPepper: 'pepper',
              resolveAuthUserId:
                  (
                    final Session session, {
                    required final String handle,
                    required final String handleType,
                    required final Transaction? transaction,
                  }) async {
                    final authUser = await fixture.authUsers.create(
                      session,
                      transaction: transaction,
                    );
                    createdAuthUserId = authUser.id;
                    return authUser.id;
                  },
              loginVerificationCodeGenerator: () => verificationCode,
              sendLoginVerificationCode:
                  (
                    final Session session, {
                    required final String handle,
                    required final UuidValue requestId,
                    required final String verificationCode,
                    required final Transaction? transaction,
                    required final String handleType,
                  }) async {
                    deliveredVerificationCode = verificationCode;
                  },
            ),
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when login is completed then it returns AuthSuccess for the created auth user',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(result.authUserId, equals(createdAuthUserId));
          },
        );
      });

      group('Given an existing account with scopes', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          final authUserId = handleToUserId[handle]!;
          await fixture.authUsers.update(
            session,
            authUserId: authUserId,
            scopes: {const Scope('test-scope'), const Scope('admin')},
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when login is completed then the returned AuthSuccess contains the user scopes',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(result.scopeNames, contains('test-scope'));
            expect(result.scopeNames, contains('admin'));
            expect(result.scopeNames, hasLength(2));
          },
        );
      });

      group('Given a blocked auth user account', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          final authUserId = handleToUserId[handle]!;
          await fixture.authUsers.update(
            session,
            authUserId: authUserId,
            blocked: true,
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when login is completed with correct credentials then it throws AuthUserBlockedException',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(result, throwsA(isA<AuthUserBlockedException>()));
          },
        );

        test(
          'when login is blocked after verification then the request is still consumed',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );
            final request = await PasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengeId = request!.challengeId;

            final firstAttempt = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(
              firstAttempt,
              throwsA(isA<AuthUserBlockedException>()),
            );
            expect(
              await PasswordlessLoginRequest.db.findById(session, requestId),
              isNull,
            );
            expect(
              await SecretChallenge.db.findById(session, challengeId),
              isNull,
            );

            final secondAttempt = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(
              secondAttempt,
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
      });

      group('Given a login request with missing auth user resolution', () {
        late UuidValue requestId;

        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );
          handleToUserId.remove(handle);
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin is called then it throws PasswordlessLoginException with reason "invalid"',
          () async {
            final result = fixture.passwordlessIdp.finishLogin(
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
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
          },
        );

        test(
          'when finishLogin fails during auth user resolution then the request is still consumed',
          () async {
            final request = await PasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengeId = request!.challengeId;

            final firstAttempt = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(
              firstAttempt,
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
            expect(
              await PasswordlessLoginRequest.db.findById(session, requestId),
              isNull,
            );
            expect(
              await SecretChallenge.db.findById(session, challengeId),
              isNull,
            );

            final secondAttempt = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(
              secondAttempt,
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
      });
    },
  );
}

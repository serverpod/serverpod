import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passwordless.dart';
import 'package:serverpod_auth_idp_server/src/providers/passwordless/business/passwordless_idp_server_exceptions.dart'
    show PasswordlessLoginNotFoundException;
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/passwordless_idp_test_fixture.dart';
import '../test_utils/passwordless_rate_limit_test_helpers.dart';

void main() {
  withServerpod(
    'Passwordless startLogin scenarios',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late PasswordlessIdpTestFixture fixture;
      late Map<String, UuidValue> handleToUserId;

      const handle = 'test-handle';
      late String verificationCode;
      late UuidValue deliveredRequestId;
      late String deliveredHandle;
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
                  required final String? handleType,
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
                  required final String? handleType,
                }) async {
                  deliveredHandle = handle;
                  deliveredRequestId = requestId;
                  deliveredVerificationCode = verificationCode;
                },
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        handleToUserId[handle] = authUser.id;
      }

      group('Given a valid handle and configured passwordless provider', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when startLogin is called then it returns a request id',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            expect(requestId, isA<UuidValue>());
            expect(deliveredRequestId, equals(requestId));
            expect(deliveredHandle, equals(handle));
            expect(deliveredVerificationCode, equals(verificationCode));
          },
        );
      });

      group(
        'Given passwordless provider without sendLoginVerificationCode callback',
        () {
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
                      required final String? handleType,
                      required final Transaction? transaction,
                    }) async {
                      final authUserId = handleToUserId[handle];
                      if (authUserId == null) {
                        throw PasswordlessLoginNotFoundException();
                      }
                      return authUserId;
                    },
                loginVerificationCodeGenerator: () => verificationCode,
                sendLoginVerificationCode: null,
              ),
            );

            final authUser = await fixture.authUsers.create(session);
            handleToUserId[handle] = authUser.id;
          });

          tearDown(() async {
            await fixture.tearDown(session);
          });

          test(
            'when startLogin and finishLogin are called then login still succeeds',
            () async {
              final requestId = await fixture.passwordlessIdp.startLogin(
                session,
                handle: handle,
              );

              final result = await fixture.passwordlessIdp.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: verificationCode,
              );

              expect(requestId, isA<UuidValue>());
              expect(result, isA<AuthSuccess>());
            },
          );
        },
      );

      group('Given sendLoginVerificationCode throws', () {
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
                    required final String? handleType,
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
                    required final String? handleType,
                  }) async {
                    throw StateError('send failed');
                  },
            ),
          );

          final authUser = await fixture.authUsers.create(session);
          handleToUserId[handle] = authUser.id;
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when startLogin is called then the error propagates, login_request rate limit is recorded, and no pending request or challenge remains',
          () async {
            expect(
              await countPasswordlessLoginRequestAttempts(
                session,
                handle: handle,
              ),
              equals(0),
            );
            expect(
              await PasswordlessLoginRequest.db.count(session),
              equals(0),
            );
            expect(await SecretChallenge.db.count(session), equals(0));

            await expectLater(
              fixture.passwordlessIdp.startLogin(session, handle: handle),
              throwsA(
                isA<StateError>().having(
                  (final e) => e.message,
                  'message',
                  'send failed',
                ),
              ),
            );

            expect(
              await countPasswordlessLoginRequestAttempts(
                session,
                handle: handle,
              ),
              equals(1),
            );
            expect(
              await PasswordlessLoginRequest.db.find(
                session,
                where: (final t) => t.handle.equals(handle),
              ),
              isEmpty,
            );
            expect(await SecretChallenge.db.find(session), isEmpty);
          },
        );
      });

      group('Given an existing login request', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when startLogin is called for the same handle then previous request is replaced',
          () async {
            final firstRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );
            final secondRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final firstRequest = await PasswordlessLoginRequest.db.findById(
              session,
              firstRequestId,
            );
            final secondRequest = await PasswordlessLoginRequest.db.findById(
              session,
              secondRequestId,
            );

            expect(firstRequest, isNull);
            expect(secondRequest, isNotNull);
          },
        );

        test(
          'when startLogin replaces a previous request then the old SecretChallenge is also deleted',
          () async {
            final firstRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final firstRequest = await PasswordlessLoginRequest.db.findById(
              session,
              firstRequestId,
            );
            final firstChallengeId = firstRequest!.challengeId;

            await fixture.passwordlessIdp.startLogin(session, handle: handle);

            final oldChallenge = await SecretChallenge.db.findById(
              session,
              firstChallengeId,
            );
            expect(oldChallenge, isNull);
          },
        );

        test(
          'when startLogin is called for the same handle with a different handleType then previous request is kept',
          () async {
            final firstRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
              handleType: 'email',
            );
            final secondRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
              handleType: 'sms',
            );

            final firstRequest = await PasswordlessLoginRequest.db.findById(
              session,
              firstRequestId,
            );
            final secondRequest = await PasswordlessLoginRequest.db.findById(
              session,
              secondRequestId,
            );

            expect(firstRequest, isNotNull);
            expect(firstRequest!.handleType, equals('email'));
            expect(secondRequest, isNotNull);
            expect(secondRequest!.handleType, equals('sms'));
            expect(
              await countPasswordlessLoginRequestAttempts(
                session,
                handle: handle,
                handleType: 'email',
              ),
              equals(1),
            );
            expect(
              await countPasswordlessLoginRequestAttempts(
                session,
                handle: handle,
                handleType: 'sms',
              ),
              equals(1),
            );
          },
        );
      });

      group('Given login request attempts at the default rate limit', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          for (
            var i = 0;
            i <
                fixture
                    .passwordlessIdp
                    .config
                    .loginRequestRateLimit
                    .maxAttempts;
            i++
          ) {
            await fixture.passwordlessIdp.startLogin(session, handle: handle);
          }
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when startLogin is called then it throws PasswordlessLoginException with reason "tooManyAttempts"',
          () async {
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
      });
    },
  );
}

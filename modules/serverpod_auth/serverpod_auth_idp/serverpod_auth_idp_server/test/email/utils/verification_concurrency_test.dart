import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  late Session session;
  late EmailIdpTestFixture fixture;

  withServerpod(
    '[Email verification concurrency]',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      setUpAll(() {
        session = sessionBuilder.build();
      });

      group(
        'Given an unverified registration request allowing two verification attempts, ',
        () {
          const verificationCode = '12345678';
          late UuidValue requestId;

          setUpAll(() async {
            fixture = EmailIdpTestFixture(
              config: EmailIdpConfig(
                secretHashPepper: 'pepper',
                registrationVerificationCodeGenerator: () => verificationCode,
                registrationVerificationCodeAllowedAttempts: 2,
              ),
            );

            requestId = await session.db.transaction(
              (final transaction) =>
                  fixture.accountCreationUtil.startRegistration(
                    session,
                    email: 'registration-race@serverpod.dev',
                    transaction: transaction,
                  ),
            );
          });

          tearDownAll(() async {
            await fixture.tearDown(session);
          });

          group('when two sessions concurrently verify the correct code, ', () {
            late List<Object> results;
            late EmailAccountRequest request;
            late List<SecretChallenge> challenges;
            late SecretChallenge completionChallenge;
            late List<String> tokenParts;

            setUpAll(() async {
              results = await Future.wait<Object>([
                for (final attemptSession in [
                  sessionBuilder.build(),
                  sessionBuilder.build(),
                ])
                  () async {
                    try {
                      return await attemptSession.db.transaction(
                        (final transaction) =>
                            fixture.accountCreationUtil.verifyRegistrationCode(
                              attemptSession,
                              accountRequestId: requestId,
                              verificationCode: verificationCode,
                              transaction: transaction,
                            ),
                      );
                    } catch (error) {
                      return error;
                    }
                  }(),
              ]);

              request = (await EmailAccountRequest.db.findById(
                session,
                requestId,
              ))!;

              challenges = await SecretChallenge.db.find(session);

              completionChallenge = challenges.singleWhere(
                (final challenge) =>
                    challenge.id == request.createAccountChallengeId,
              );

              tokenParts = utf8
                  .decode(base64Decode(results.whereType<String>().single))
                  .split(':');
            });

            test(
              'then only the winning completion challenge is issued and persisted.',
              () async {
                expect(
                  results,
                  unorderedMatches([
                    isA<String>(),
                    isA<
                      EmailAccountRequestVerificationCodeAlreadyUsedException
                    >(),
                  ]),
                );

                expect(
                  challenges.map((final challenge) => challenge.id),
                  unorderedEquals([
                    request.challengeId,
                    request.createAccountChallengeId,
                  ]),
                );

                expect(tokenParts.first, requestId.uuid);

                expect(
                  await fixture.passwordHashUtil.validateHashFromString(
                    secret: tokenParts.last,
                    hashString: completionChallenge.challengeCodeHash,
                  ),
                  isTrue,
                );
              },
            );
          });
        },
      );

      group(
        'Given an unverified password reset request allowing two verification attempts, ',
        () {
          const verificationCode = '12345678';
          const email = 'password-reset-race@serverpod.dev';
          late AuthUserModel authUser;
          late UuidValue requestId;

          setUpAll(() async {
            fixture = EmailIdpTestFixture(
              config: EmailIdpConfig(
                secretHashPepper: 'pepper',
                passwordResetVerificationCodeGenerator: () => verificationCode,
                passwordResetVerificationCodeAllowedAttempts: 2,
              ),
            );

            authUser = await fixture.authUsers.create(session);

            await fixture.createEmailAccount(
              session,
              authUserId: authUser.id,
              email: email,
              password: EmailAccountPassword.fromString('Foobar123!'),
            );

            requestId = await session.db.transaction(
              (final transaction) =>
                  fixture.passwordResetUtil.startPasswordReset(
                    session,
                    email: email,
                    transaction: transaction,
                  ),
            );
          });

          tearDownAll(() async {
            await fixture.tearDown(session);
          });

          group('when two sessions concurrently verify the correct code, ', () {
            late List<Object> results;
            late EmailAccountPasswordResetRequest request;
            late List<SecretChallenge> challenges;
            late SecretChallenge completionChallenge;
            late List<String> tokenParts;

            setUpAll(() async {
              results = await Future.wait<Object>([
                for (final attemptSession in [
                  sessionBuilder.build(),
                  sessionBuilder.build(),
                ])
                  () async {
                    try {
                      return await attemptSession.db.transaction(
                        (final transaction) =>
                            fixture.passwordResetUtil.verifyPasswordResetCode(
                              attemptSession,
                              passwordResetRequestId: requestId,
                              verificationCode: verificationCode,
                              transaction: transaction,
                            ),
                      );
                    } catch (error) {
                      return error;
                    }
                  }(),
              ]);

              request = (await EmailAccountPasswordResetRequest.db.findById(
                session,
                requestId,
              ))!;

              challenges = await SecretChallenge.db.find(session);

              completionChallenge = challenges.singleWhere(
                (final challenge) =>
                    challenge.id == request.setPasswordChallengeId,
              );

              tokenParts = utf8
                  .decode(base64Decode(results.whereType<String>().single))
                  .split(':');
            });

            test(
              'then only the winning completion challenge is issued and persisted.',
              () async {
                expect(
                  results,
                  unorderedMatches([
                    isA<String>(),
                    isA<
                      EmailPasswordResetVerificationCodeAlreadyUsedException
                    >(),
                  ]),
                );

                expect(
                  challenges.map((final challenge) => challenge.id),
                  unorderedEquals([
                    request.challengeId,
                    request.setPasswordChallengeId,
                  ]),
                );

                expect(tokenParts.first, requestId.uuid);

                expect(
                  await fixture.passwordHashUtil.validateHashFromString(
                    secret: tokenParts.last,
                    hashString: completionChallenge.challengeCodeHash,
                  ),
                  isTrue,
                );
              },
            );
          });
        },
      );
    },
  );
}

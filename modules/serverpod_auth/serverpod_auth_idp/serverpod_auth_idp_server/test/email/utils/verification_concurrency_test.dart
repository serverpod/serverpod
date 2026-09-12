import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/email_idp_test_fixture.dart';

void main() {
  late Session Function() buildSession;
  late Session session;
  late EmailIdpTestFixture fixture;

  setUp(() {
    session = buildSession();
  });

  tearDown(() async {
    await fixture.tearDown(session);
  });

  withServerpod(
    '[Email verification concurrency]',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      buildSession = sessionBuilder.build;

      test(
        'Given an unverified registration request allowing two verification attempts, '
        'when two sessions concurrently verify the correct code, '
        'then only the winning completion challenge is issued and persisted.',
        () async {
          const verificationCode = '12345678';
          fixture = EmailIdpTestFixture(
            config: EmailIdpConfig(
              secretHashPepper: 'pepper',
              registrationVerificationCodeGenerator: () => verificationCode,
              registrationVerificationCodeAllowedAttempts: 2,
            ),
          );
          final requestId = await session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.startRegistration(
                  session,
                  email: 'registration-race@serverpod.dev',
                  transaction: transaction,
                ),
          );

          final results = await Future.wait<Object>([
            for (final attemptSession in [buildSession(), buildSession()])
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

          expect(
            results,
            unorderedMatches([
              isA<String>(),
              isA<EmailAccountRequestVerificationCodeAlreadyUsedException>(),
            ]),
          );
          final request = (await EmailAccountRequest.db.findById(
            session,
            requestId,
          ))!;
          final challenges = await SecretChallenge.db.find(session);
          expect(
            challenges.map((final challenge) => challenge.id),
            unorderedEquals([
              request.challengeId,
              request.createAccountChallengeId,
            ]),
          );
          final completionChallenge = challenges.singleWhere(
            (final challenge) =>
                challenge.id == request.createAccountChallengeId,
          );
          final tokenParts = utf8
              .decode(base64Decode(results.whereType<String>().single))
              .split(':');
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

      test(
        'Given an unverified password reset request allowing two verification attempts, '
        'when two sessions concurrently verify the correct code, '
        'then only the winning completion challenge is issued and persisted.',
        () async {
          const verificationCode = '12345678';
          const email = 'password-reset-race@serverpod.dev';
          fixture = EmailIdpTestFixture(
            config: EmailIdpConfig(
              secretHashPepper: 'pepper',
              passwordResetVerificationCodeGenerator: () => verificationCode,
              passwordResetVerificationCodeAllowedAttempts: 2,
            ),
          );
          final authUser = await fixture.authUsers.create(session);
          await fixture.createEmailAccount(
            session,
            authUserId: authUser.id,
            email: email,
            password: EmailAccountPassword.fromString('Foobar123!'),
          );
          final requestId = await session.db.transaction(
            (final transaction) => fixture.passwordResetUtil.startPasswordReset(
              session,
              email: email,
              transaction: transaction,
            ),
          );

          final results = await Future.wait<Object>([
            for (final attemptSession in [buildSession(), buildSession()])
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

          expect(
            results,
            unorderedMatches([
              isA<String>(),
              isA<EmailPasswordResetVerificationCodeAlreadyUsedException>(),
            ]),
          );
          final request = (await EmailAccountPasswordResetRequest.db.findById(
            session,
            requestId,
          ))!;
          final challenges = await SecretChallenge.db.find(session);
          expect(
            challenges.map((final challenge) => challenge.id),
            unorderedEquals([
              request.challengeId,
              request.setPasswordChallengeId,
            ]),
          );
          final completionChallenge = challenges.singleWhere(
            (final challenge) => challenge.id == request.setPasswordChallengeId,
          );
          final tokenParts = utf8
              .decode(base64Decode(results.whereType<String>().single))
              .split(':');
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
    },
  );
}

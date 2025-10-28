import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../test_tags.dart';
import '../../../test_tools/serverpod_test_tools.dart';
import '../../test_utils/email_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given verified account request and auth user',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      late String verificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            passwordHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        accountRequestId = result.accountRequestId!;

        // Verify the request
        await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        // Create auth user
        final authUser = await fixture.createAuthUser(session);
        authUserId = authUser.id;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      group('when finalize account request is called', () {
        late Future<EmailIDPFinalizeAccountRequestResult>
            finalizeAccountRequestFuture;
        setUp(() async {
          finalizeAccountRequestFuture = session.db.transaction(
            (final transaction) =>
                fixture.accountCreationUtil.finalizeAccountRequest(
              session,
              accountRequestId: accountRequestId,
              authUserId: authUserId,
              transaction: transaction,
            ),
          );
        });

        test('then it succeeds and returns result with account id and email',
            () async {
          await expectLater(
            finalizeAccountRequestFuture,
            completion(
              isA<EmailIDPFinalizeAccountRequestResult>()
                  .having(
                    (final result) => result.accountId,
                    'accountId',
                    isA<UuidValue>(),
                  )
                  .having(
                    (final result) => result.email,
                    'email',
                    equals(email),
                  ),
            ),
          );
        });

        test(
            'then user can authenticate with the registered credentials as auth user',
            () async {
          await finalizeAccountRequestFuture;
          final authResult = session.db.transaction(
            (final transaction) => fixture.authenticationUtil.authenticate(
              session,
              email: email,
              password: password,
              transaction: transaction,
            ),
          );

          await expectLater(authResult, completion(equals(authUserId)));
        });
      });
    },
  );

  withServerpod(
    'Given unverified account request and auth user',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';

      setUp(() async {
        session = sessionBuilder.build();

        fixture = EmailIDPTestFixture();

        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        accountRequestId = result.accountRequestId!;

        // Create auth user but don't verify the request
        final authUser = await fixture.createAuthUser(session);
        authUserId = authUser.id;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when finalize account request is called then it throws request not verified exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.finalizeAccountRequest(
            session,
            accountRequestId: accountRequestId,
            authUserId: authUserId,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailAccountRequestNotVerifiedException>()),
        );
      });
    },
  );

  withServerpod(
    'Given completed account request and auth user',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      late UuidValue accountRequestId;
      late UuidValue authUserId;
      const email = 'test@serverpod.dev';
      const password = 'Foobar123!';
      late String verificationCode;

      setUp(() async {
        session = sessionBuilder.build();

        verificationCode = const Uuid().v4().toString();
        fixture = EmailIDPTestFixture(
          config: EmailIDPConfig(
            passwordHashPepper: 'pepper',
            registrationVerificationCodeGenerator: () => verificationCode,
          ),
        );

        final result = await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.startAccountCreation(
            session,
            email: email,
            password: password,
            transaction: transaction,
          ),
        );

        accountRequestId = result.accountRequestId!;

        // Verify and finalize the request
        await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.verifyAccountRequest(
            session,
            accountRequestId: accountRequestId,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );

        final authUser = await fixture.createAuthUser(session);
        authUserId = authUser.id;

        await session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.finalizeAccountRequest(
            session,
            accountRequestId: accountRequestId,
            authUserId: authUserId,
            transaction: transaction,
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when finalize account request is called then it throws request not found exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.finalizeAccountRequest(
            session,
            accountRequestId: accountRequestId,
            authUserId: authUserId,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailAccountRequestNotFoundException>()),
        );
      });
    },
  );

  withServerpod(
    'Given no account request and auth user',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late EmailIDPTestFixture fixture;
      final accountRequestId = const Uuid().v4obj();
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIDPTestFixture();

        // Create auth user but no account request
        final authUser = await fixture.createAuthUser(session);
        authUserId = authUser.id;
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
          'when finalize account request is called then it throws request not found exception',
          () async {
        final result = session.db.transaction(
          (final transaction) =>
              fixture.accountCreationUtil.finalizeAccountRequest(
            session,
            accountRequestId: accountRequestId,
            authUserId: authUserId,
            transaction: transaction,
          ),
        );

        await expectLater(
          result,
          throwsA(isA<EmailAccountRequestNotFoundException>()),
        );
      });
    },
  );
}
